import 'dart:math';

import '../models/enums.dart';
import '../models/models.dart';

/// Optional future LLM advisor hook. Unused in MVP.
abstract class LlmRoutineAdvisor {
  Future<List<PlannedExercise>?> suggest({
    required Mood mood,
    required Intensity intensity,
    required List<MuscleGroup> muscles,
    required List<Exercise> candidates,
  });
}

class IntensityRules {
  const IntensityRules({
    required this.minExercises,
    required this.maxExercises,
    required this.sets,
    required this.restMin,
    required this.restMax,
    required this.includeDropSet,
    required this.preferCompound,
  });

  final int minExercises;
  final int maxExercises;
  final int sets;
  final int restMin;
  final int restMax;
  final bool includeDropSet;
  final bool preferCompound;

  static IntensityRules forIntensity(Intensity intensity) {
    return switch (intensity) {
      Intensity.light => const IntensityRules(
          minExercises: 4,
          maxExercises: 5,
          sets: 2,
          restMin: 90,
          restMax: 120,
          includeDropSet: false,
          preferCompound: false,
        ),
      Intensity.moderate => const IntensityRules(
          minExercises: 5,
          maxExercises: 6,
          sets: 3,
          restMin: 60,
          restMax: 75,
          includeDropSet: false,
          preferCompound: false,
        ),
      Intensity.pushHard => const IntensityRules(
          minExercises: 6,
          maxExercises: 7,
          sets: 4,
          restMin: 45,
          restMax: 60,
          includeDropSet: true,
          preferCompound: false,
        ),
      Intensity.prAttempt => const IntensityRules(
          minExercises: 4,
          maxExercises: 4,
          sets: 5,
          restMin: 120,
          restMax: 180,
          includeDropSet: false,
          preferCompound: true,
        ),
    };
  }
}

class RoutineEngine {
  RoutineEngine({this.llmAdvisor});

  final LlmRoutineAdvisor? llmAdvisor;

  List<PlannedExercise> generate({
    required Mood mood,
    required Intensity intensity,
    required List<MuscleGroup> muscles,
    required List<Equipment> availableEquipment,
    required ExperienceLevel experience,
    required List<Exercise> bank,
    TrainingFocus focus = TrainingFocus.hypertrophy,
    int? seed,
    int? exerciseCount,
    SorenessLevel soreness = SorenessLevel.none,
    List<MuscleGroup> avoidMuscles = const [],
    bool deloadActive = false,
  }) {
    final rules = IntensityRules.forIntensity(intensity);
    final random = Random(seed ?? DateTime.now().millisecondsSinceEpoch);
    final lightVolume = soreness == SorenessLevel.high ||
        deloadActive ||
        avoidMuscles.isNotEmpty;

    var targetMuscles = muscles
        .where((m) => !avoidMuscles.contains(m))
        .toList();
    if (targetMuscles.isEmpty) {
      targetMuscles = muscles.isEmpty
          ? MuscleGroup.values
              .where((m) => !avoidMuscles.contains(m))
              .take(2)
              .toList()
          : muscles;
    }

    var candidates = bank.where((e) {
      final hitsAvoid =
          e.muscleGroups.any(avoidMuscles.contains) && e.isCompound;
      if (hitsAvoid) return false;
      final muscleMatch = e.muscleGroups.any(targetMuscles.contains);
      final equipmentMatch = e.equipment.any(availableEquipment.contains) ||
          e.equipment.contains(Equipment.bodyweight);
      final levelOk = e.difficulty.index <= experience.index ||
          experience == ExperienceLevel.advanced;
      return muscleMatch && equipmentMatch && levelOk;
    }).toList();

    if (focus == TrainingFocus.stamina || rules.preferCompound) {
      final compounds = candidates.where((e) => e.isCompound).toList();
      if (compounds.length >= rules.minExercises) {
        candidates = compounds;
      } else {
        candidates.sort(
          (a, b) => (b.isCompound ? 1 : 0) - (a.isCompound ? 1 : 0),
        );
      }
    } else if (focus == TrainingFocus.mobility ||
        soreness == SorenessLevel.high) {
      candidates.sort((a, b) {
        final aBw = a.equipment.contains(Equipment.bodyweight) ? 1 : 0;
        final bBw = b.equipment.contains(Equipment.bodyweight) ? 1 : 0;
        return bBw.compareTo(aBw);
      });
    }

    if (rules.preferCompound && focus != TrainingFocus.stamina) {
      final compounds = candidates.where((e) => e.isCompound).toList();
      if (compounds.length >= rules.minExercises) {
        candidates = compounds;
      }
    }

    candidates.shuffle(random);

    final span = rules.maxExercises - rules.minExercises;
    final defaultCount =
        rules.minExercises + (span > 0 ? random.nextInt(span + 1) : 0);
    var count = (exerciseCount ?? defaultCount).clamp(3, 12);
    if (lightVolume) {
      count = (count - 1).clamp(3, 10);
    }

    final selected = <Exercise>[];
    for (final exercise in candidates) {
      if (selected.length >= count) break;
      if (selected.any((s) => s.id == exercise.id)) continue;
      selected.add(exercise);
    }

    if (selected.length < count) {
      final fallback = bank
          .where(
            (e) =>
                e.muscleGroups.any(targetMuscles.contains) &&
                !e.muscleGroups.any(avoidMuscles.contains),
          )
          .toList()
        ..shuffle(random);
      for (final exercise in fallback) {
        if (selected.length >= count) break;
        if (selected.any((s) => s.id == exercise.id)) continue;
        selected.add(exercise);
      }
    }

    // Fresh → fatigued: big multi-joint work first, isolation last.
    selected.sort((a, b) {
      final compound = (b.isCompound ? 1 : 0).compareTo(a.isCompound ? 1 : 0);
      if (compound != 0) return compound;
      return a.name.compareTo(b.name);
    });

    final moodRestBias = switch (mood) {
      Mood.tired || Mood.low => 15,
      Mood.stressed => 10,
      Mood.energetic || Mood.motivated => -5,
    };

    final focusRestBias = switch (focus) {
      TrainingFocus.stamina => -20,
      TrainingFocus.strength => 25,
      TrainingFocus.mobility => 10,
      TrainingFocus.hypertrophy => 0,
    };

    final focusRepBias = switch (focus) {
      TrainingFocus.stamina => 6,
      TrainingFocus.strength => -3,
      TrainingFocus.mobility => 2,
      TrainingFocus.hypertrophy => 0,
    };

    return selected.asMap().entries.map((entry) {
      final index = entry.key;
      final exercise = entry.value;
      final variant = exercise.variants[experience] ??
          exercise.variants[ExperienceLevel.beginner] ??
          const ExerciseVariant(sets: 3, reps: 10, restSeconds: 60);

      final restSpan = (rules.restMax - rules.restMin).clamp(1, 999);
      final rest = (rules.restMin +
              random.nextInt(restSpan) +
              moodRestBias +
              focusRestBias)
          .clamp(20, 240);

      final reps = (variant.reps + focusRepBias).clamp(5, 25);
      var sets = idealSets(intensity: intensity, focus: focus);
      if (lightVolume) {
        sets = (sets * 0.75).round().clamp(1, 6);
      }

      final isLast = index == selected.length - 1;
      return PlannedExercise(
        exerciseId: exercise.id,
        name: exercise.name,
        muscleGroups: exercise.muscleGroups,
        sets: sets,
        reps: reps,
        restSeconds: rest,
        formCues: exercise.formCues,
        commonMistakes: exercise.commonMistakes,
        includeDropSet: rules.includeDropSet && isLast,
        estimatedCalories: exercise.estimatedCalories,
        demoImages: exercise.demoImages,
        isCompound: exercise.isCompound,
        recommendedSets: sets,
      );
    }).toList();
  }

  /// Ideal set count for the user's intensity + focus (shown when they customize).
  static int idealSets({
    required Intensity intensity,
    TrainingFocus focus = TrainingFocus.hypertrophy,
  }) {
    final rules = IntensityRules.forIntensity(intensity);
    if (focus == TrainingFocus.stamina) {
      return (rules.sets + 1).clamp(2, 6);
    }
    return rules.sets.clamp(1, 6);
  }

  PlannedExercise? swapExercise({
    required PlannedExercise current,
    required List<Equipment> availableEquipment,
    required ExperienceLevel experience,
    required List<Exercise> bank,
    required Set<String> excludeIds,
    Intensity intensity = Intensity.moderate,
  }) {
    final candidates = bank.where((e) {
      if (excludeIds.contains(e.id) || e.id == current.exerciseId) return false;
      final muscleMatch = e.muscleGroups.any(current.muscleGroups.contains);
      final equipmentMatch = e.equipment.any(availableEquipment.contains) ||
          e.equipment.contains(Equipment.bodyweight);
      return muscleMatch && equipmentMatch;
    }).toList();

    if (candidates.isEmpty) return null;
    candidates.shuffle(Random());
    final exercise = candidates.first;
    final variant = exercise.variants[experience] ??
        exercise.variants[ExperienceLevel.beginner]!;

    return PlannedExercise(
      exerciseId: exercise.id,
      name: exercise.name,
      muscleGroups: exercise.muscleGroups,
      sets: current.sets,
      reps: variant.reps,
      restSeconds: current.restSeconds,
      formCues: exercise.formCues,
      commonMistakes: exercise.commonMistakes,
      includeDropSet: current.includeDropSet,
      estimatedCalories: exercise.estimatedCalories,
      demoImages: exercise.demoImages,
      isCompound: exercise.isCompound,
      recommendedSets: current.recommendedSets ?? current.sets,
    );
  }
}

/// Explains why routine order is compounds → volume → finishers.
class RoutineOrderGuide {
  const RoutineOrderGuide._();

  static String roleLabel(int index, int total, PlannedExercise exercise) {
    if (total <= 1) return exercise.isCompound ? 'Main lift' : 'Focus move';
    if (index == 0) {
      return exercise.isCompound ? 'Opener · strength' : 'Opener · activation';
    }
    if (index == total - 1) {
      return exercise.includeDropSet
          ? 'Finisher · pump'
          : (exercise.isCompound ? 'Closer' : 'Finisher · isolation');
    }
    final third = total / 3;
    if (index < third) {
      return exercise.isCompound ? 'Primary · power' : 'Early volume';
    }
    if (index < third * 2) {
      return 'Volume · hypertrophy';
    }
    return 'Accessory · detail';
  }

  static String roleWhy(int index, int total, PlannedExercise exercise) {
    if (index == 0) {
      return 'You\'re freshest here — use that energy for form and the biggest strength stimulus.';
    }
    if (index == total - 1) {
      return 'Last so fatigue doesn\'t wreck heavy technique. Chase pump and local fatigue safely.';
    }
    if (exercise.isCompound && index < total / 2) {
      return 'Still early: multi-joint work builds the most muscle and calorie burn while quality is high.';
    }
    return 'Mid-session volume adds growth without stealing focus from your opener.';
  }

  static String sessionGuide(List<PlannedExercise> exercises) {
    if (exercises.isEmpty) {
      return 'Add exercises to see how order helps your progress.';
    }
    final compounds = exercises.where((e) => e.isCompound).length;
    final muscles = exercises.expand((e) => e.muscleGroups).toSet();
    final focus = muscles.map((m) => m.label).take(3).join(', ');
    return 'Order is intentional: big multi-joint moves first ($compounds compound'
        '${compounds == 1 ? '' : 's'}) while you\'re strong, then accessories, '
        'then a finisher. That protects form, improves $focus, and still leaves '
        'gas for a safe pump at the end. Shorten the list anytime — we keep the '
        'highest-priority moves first.';
  }
}
