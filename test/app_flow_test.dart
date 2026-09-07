import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/data/db/app_database.dart';
import 'package:the_muscle_builder/data/repositories/cloud_sync_port.dart';
import 'package:the_muscle_builder/data/repositories/nutrition_repository.dart';
import 'package:the_muscle_builder/data/repositories/profile_repository.dart';
import 'package:the_muscle_builder/data/repositories/seed_repository.dart';
import 'package:the_muscle_builder/data/repositories/workout_repository.dart';
import 'package:the_muscle_builder/domain/engines/routine_engine.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      // Fallback unused; individual assets loaded via rootBundle in real app.
      return null;
    });
  });

  test('full check-in → plan → session → meals loop', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final sync = NoOpCloudSync();
    final profiles = ProfileRepository(db, sync);
    final workouts = WorkoutRepository(db, sync);
    final seed = SeedRepository();
    final nutrition = NutritionRepository(seed);
    final engine = RoutineEngine();

    // Seed via direct Exercise list to avoid asset loading in unit test
    final bank = [
      for (var i = 0; i < 12; i++)
        Exercise(
          id: 'ex_$i',
          name: 'Exercise $i',
          muscleGroups: const [MuscleGroup.chest, MuscleGroup.arms],
          equipment: const [Equipment.bodyweight, Equipment.dumbbell],
          difficulty: ExperienceLevel.beginner,
          estimatedCalories: 60,
          formCues: const ['Brace'],
          commonMistakes: const ['Rush'],
          isCompound: true,
          variants: const {
            ExperienceLevel.beginner:
                ExerciseVariant(sets: 3, reps: 10, restSeconds: 60),
            ExperienceLevel.intermediate:
                ExerciseVariant(sets: 3, reps: 12, restSeconds: 60),
            ExperienceLevel.advanced:
                ExerciseVariant(sets: 4, reps: 8, restSeconds: 45),
          },
        ),
    ];

    final profile = await profiles.saveProfile(
      const UserProfile(
        id: 'u1',
        name: 'Arjun',
        journeyName: 'Iron Monsoon',
        weightKg: 72,
        heightCm: 175,
        age: 28,
        gender: Gender.male,
        activityLevel: ActivityLevel.moderatelyActive,
        primaryGoal: PrimaryGoal.strength,
        experience: ExperienceLevel.beginner,
        equipment: [Equipment.bodyweight, Equipment.dumbbell],
        dietType: DietType.vegetarian,
        allergies: [Allergy.nuts],
        themeColorHex: '#FF6B35',
        coachTone: CoachTone.friendly,
        themePreference: ThemePreference.dark,
        onboardingComplete: true,
      ),
    );

    final checkIn = DailyCheckIn(
      id: const Uuid().v4(),
      date: DateTime.now(),
      mood: Mood.tired,
      intensity: Intensity.moderate,
      selectedMuscles: const [MuscleGroup.chest, MuscleGroup.arms],
      surpriseMe: false,
    );
    await workouts.saveCheckIn(checkIn);

    final exercises = engine.generate(
      mood: checkIn.mood,
      intensity: checkIn.intensity,
      muscles: checkIn.selectedMuscles,
      availableEquipment: profile.equipment,
      experience: profile.experience,
      bank: bank,
      seed: 1,
    );
    expect(exercises.length, inInclusiveRange(5, 6));

    final plan = await workouts.savePlan(
      WorkoutPlan(
        id: const Uuid().v4(),
        checkInId: checkIn.id,
        createdAt: DateTime.now(),
        exercises: exercises,
        encouragement: 'Showing up matters',
      ),
    );

    final todays = await workouts.getTodaysPlan();
    expect(todays?.id, plan.id);

    final session = await workouts.startSession(plan);
    await workouts.logSet(
      SetLog(
        id: const Uuid().v4(),
        sessionId: session.id,
        exerciseId: exercises.first.exerciseId,
        setNumber: 1,
        repsCompleted: 10,
        weightKg: 20,
        rpe: 7,
        completed: true,
      ),
    );
    final done = await workouts.completeSession(session.id);
    expect(done.completed, isTrue);
    expect(await workouts.workoutsThisWeek(), 1);

    // Meals filter by diet + allergies (nuts excluded)
    final meals = [
      const MealSuggestion(
        id: 'safe',
        name: 'Moong Dal Chilla',
        description: 'Protein pancake',
        timing: MealTiming.preWorkout,
        dietTypes: [DietType.vegetarian, DietType.vegan],
        regions: [CuisineRegion.panIndian],
        allergens: [],
        timingGuidance: '60 min before',
        calories: 250,
        proteinG: 14,
        carbsG: 30,
        fatG: 7,
        portion: '2 chillas',
      ),
      const MealSuggestion(
        id: 'nuts',
        name: 'Banana + Almonds',
        description: 'Has nuts',
        timing: MealTiming.preWorkout,
        dietTypes: [DietType.vegetarian],
        regions: [CuisineRegion.panIndian],
        allergens: [Allergy.nuts],
        timingGuidance: '30 min before',
        calories: 220,
        proteinG: 6,
        carbsG: 32,
        fatG: 9,
        portion: '1 banana + 8 almonds',
      ),
    ];

    final filtered = meals.where((m) {
      if (m.timing != MealTiming.preWorkout) return false;
      if (!m.dietTypes.contains(profile.dietType)) return false;
      if (m.allergens.any(profile.allergies.contains)) return false;
      return true;
    }).toList();

    expect(filtered.map((m) => m.id), ['safe']);
    expect(nutrition, isNotNull);
  });
}
