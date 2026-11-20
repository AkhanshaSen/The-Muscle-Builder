import '../models/enums.dart';
import '../models/models.dart';
import 'routine_engine.dart';

class CustomRoutineLauncher {
  CustomRoutineLauncher._();

  /// Maps saved exercise ids to plan rows using profile experience defaults.
  static List<PlannedExercise> plannedExercises({
    required List<String> exerciseIds,
    required List<Exercise> bank,
    required ExperienceLevel experience,
    Intensity intensity = Intensity.moderate,
  }) {
    final byId = {for (final e in bank) e.id: e};
    final sets = RoutineEngine.idealSets(intensity: intensity);
    final out = <PlannedExercise>[];

    for (final id in exerciseIds) {
      final exercise = byId[id];
      if (exercise == null) continue;
      final variant = exercise.variants[experience] ??
          exercise.variants[ExperienceLevel.beginner] ??
          const ExerciseVariant(sets: 3, reps: 10, restSeconds: 60);

      out.add(
        PlannedExercise(
          exerciseId: exercise.id,
          name: exercise.name,
          muscleGroups: exercise.muscleGroups,
          sets: sets,
          reps: variant.reps,
          restSeconds: variant.restSeconds,
          formCues: exercise.formCues,
          commonMistakes: exercise.commonMistakes,
          includeDropSet: false,
          estimatedCalories: exercise.estimatedCalories,
          demoImages: exercise.demoImages,
          isCompound: exercise.isCompound,
          recommendedSets: sets,
        ),
      );
    }
    return out;
  }

  static List<MuscleGroup> musclesFromIds(
    List<String> exerciseIds,
    List<Exercise> bank,
  ) {
    final byId = {for (final e in bank) e.id: e};
    final set = <MuscleGroup>{};
    for (final id in exerciseIds) {
      final e = byId[id];
      if (e != null) set.addAll(e.muscleGroups);
    }
    return set.toList();
  }
}