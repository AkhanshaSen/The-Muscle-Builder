import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../domain/engines/custom_routine_launcher.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';

Future<void> useCustomRoutineToday(
  BuildContext context,
  WidgetRef ref,
  CustomRoutine routine,
) async {
  final workouts = ref.read(workoutRepositoryProvider);
  final existingPlan = await workouts.getTodaysPlan();
  if (!context.mounted) return;

  if (existingPlan != null) {
    final replace = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace today’s plan?'),
        content: const Text(
          'You already have a workout plan for today. '
          'Using this routine will replace it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Replace'),
          ),
        ],
      ),
    );
    if (replace != true || !context.mounted) return;
  }

  final profile = await ref.read(profileRepositoryProvider).getProfile();
  if (profile == null || !context.mounted) return;

  final bank = await ref.read(seedRepositoryProvider).loadExercises();
  final catalog = CustomRoutineLauncher.plannedExercises(
    exerciseIds: routine.exerciseIds,
    bank: bank,
    experience: profile.experience,
  );
  if (catalog.isEmpty) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No valid exercises in this routine.')),
    );
    return;
  }

  final muscles = CustomRoutineLauncher.musclesFromIds(
    routine.exerciseIds,
    bank,
  );

  final checkIn = DailyCheckIn(
    id: const Uuid().v4(),
    date: DateTime.now(),
    mood: Mood.motivated,
    intensity: Intensity.moderate,
    selectedMuscles: muscles.isEmpty ? [MuscleGroup.chest] : muscles,
    surpriseMe: false,
    focus: TrainingFocus.hypertrophy,
    soreness: SorenessLevel.none,
    avoidMuscles: const [],
    equipmentOverride: profile.equipment.toList(),
  );
  await workouts.saveCheckIn(checkIn);

  final nutrition = ref.read(nutritionRepositoryProvider);
  final preMeals = await nutrition.suggestionsFor(
    timing: MealTiming.preWorkout,
    dietType: profile.dietType,
    allergies: profile.allergies,
    region: profile.cuisineRegion,
    preferredIngredients: profile.preferredIngredients,
  );
  final postMeals = await nutrition.suggestionsFor(
    timing: MealTiming.postWorkout,
    dietType: profile.dietType,
    allergies: profile.allergies,
    region: profile.cuisineRegion,
    preferredIngredients: profile.preferredIngredients,
  );

  final gymMinutes = (catalog.length * 8).clamp(30, 120);

  final plan = WorkoutPlan(
    id: const Uuid().v4(),
    checkInId: checkIn.id,
    createdAt: DateTime.now(),
    exercises: catalog,
    encouragement: 'Your custom routine · ${routine.name}',
    preMeal: preMeals.isEmpty ? null : preMeals.first,
    postMeal: postMeals.isEmpty ? null : postMeals.first,
    gymMinutes: gymMinutes,
  );
  await workouts.savePlan(plan);

  ref.invalidate(todaysPlanProvider);
  ref.invalidate(todaysCheckInProvider);
  ref.invalidate(recentFuelHistoryProvider);
  ref.invalidate(muscleRecoveryProvider);

  if (!context.mounted) return;
  context.push('/plan/${plan.id}');
}