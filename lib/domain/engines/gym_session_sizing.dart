import '../models/models.dart';

/// Maps gym time today → baseline exercise count and per-move time windows.
///
/// [WorkoutPlan.exerciseCountOverride] wins over the time baseline when set.
class GymSessionSizing {
  const GymSessionSizing._();

  static const optionsMinutes = [20, 30, 45, 60, 90, 120, 150];
  static const minExerciseCount = 1;
  static const maxExerciseCount = 12;

  static int exerciseCountFor(int gymMinutes) {
    if (gymMinutes <= 20) return 3;
    if (gymMinutes <= 30) return 4;
    if (gymMinutes <= 45) return 6;
    if (gymMinutes <= 60) return 7;
    if (gymMinutes <= 90) return 9;
    if (gymMinutes <= 120) return 11;
    return 12; // 150
  }

  static int maxCatalogCount() => exerciseCountFor(optionsMinutes.last);

  /// Effective exercise count for a plan (override or gym-time baseline).
  static int resolvedCount(WorkoutPlan plan) {
    final baseline = exerciseCountFor(plan.gymMinutes);
    final raw = plan.exerciseCountOverride ?? baseline;
    final max = plan.exercises.isEmpty ? maxExerciseCount : plan.exercises.length;
    return raw.clamp(minExerciseCount, max);
  }

  /// Rough block length for one exercise (work + rests).
  static int minutesForExercise(PlannedExercise e) {
    final workSeconds = (e.reps * 2.5 * e.sets).round();
    final restSeconds = e.restSeconds * (e.sets > 1 ? e.sets - 1 : 0);
    final total = workSeconds + restSeconds + 45; // transition buffer
    return (total / 60).ceil().clamp(3, 20);
  }

  static List<({int start, int end})> timeWindows(
    List<PlannedExercise> exercises,
  ) {
    var cursor = 0;
    final windows = <({int start, int end})>[];
    for (final e in exercises) {
      final mins = minutesForExercise(e);
      final start = cursor;
      cursor += mins;
      windows.add((start: start, end: cursor));
    }
    return windows;
  }

  static int totalMinutes(List<PlannedExercise> exercises) {
    if (exercises.isEmpty) return 0;
    return timeWindows(exercises).last.end;
  }

  static String labelForMinutes(int minutes) {
    if (minutes <= 20) return 'Quick · ~20 min';
    if (minutes <= 30) return 'Standard · ~30 min';
    if (minutes <= 45) return 'Full · ~45 min';
    if (minutes <= 60) return 'Long · ~60 min';
    if (minutes <= 90) return 'Extended · ~90 min';
    if (minutes <= 120) return 'Deep · ~2 hr';
    return 'Marathon · ~2.5 hr';
  }

  /// Exercises that fit the plan's resolved count (numbered 1…N for that day).
  static List<PlannedExercise> activeExercises(WorkoutPlan plan) {
    if (plan.exercises.isEmpty) return const [];
    final n = resolvedCount(plan).clamp(1, plan.exercises.length);
    return plan.exercises.take(n).toList();
  }

  static int activeBurnKcal(WorkoutPlan plan) =>
      activeExercises(plan).fold(0, (sum, e) => sum + e.estimatedCalories);
}
