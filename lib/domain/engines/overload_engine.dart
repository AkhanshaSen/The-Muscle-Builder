import '../models/models.dart';

/// Progressive overload suggestions from last completed performance.
class OverloadEngine {
  const OverloadEngine._();

  /// If all planned sets were logged and average RPE ≤ 7, suggest +2.5 kg
  /// (or +1 rep when last weight was 0 / bodyweight).
  static OverloadSuggestion? suggest({
    required String exerciseId,
    required List<SetLog> lastSets,
    required int plannedSets,
    required int plannedReps,
  }) {
    if (lastSets.isEmpty) return null;
    final completed = lastSets.where((s) => s.completed).toList();
    if (completed.length < plannedSets) return null;

    final avgRpe =
        completed.map((s) => s.rpe).fold<int>(0, (a, b) => a + b) /
            completed.length;
    final last = completed.last;
    final lastWeight = last.weightKg;
    final lastReps = last.repsCompleted;

    if (avgRpe > 7) {
      return OverloadSuggestion(
        exerciseId: exerciseId,
        lastWeightKg: lastWeight,
        lastReps: lastReps,
        averageRpe: avgRpe,
        suggestedWeightKg: lastWeight,
        suggestedReps: plannedReps,
        message:
            'Last: ${_fmtWeight(lastWeight)} × $lastReps @ RPE ${avgRpe.toStringAsFixed(0)} — hold load',
        bumpWeight: false,
      );
    }

    final bumpWeight = lastWeight > 0;
    final suggestedWeight = bumpWeight ? lastWeight + 2.5 : lastWeight;
    final suggestedReps = bumpWeight ? plannedReps : lastReps + 1;

    final tryPart = bumpWeight
        ? 'try ${_fmtWeight(suggestedWeight)}'
        : 'try $suggestedReps reps';

    return OverloadSuggestion(
      exerciseId: exerciseId,
      lastWeightKg: lastWeight,
      lastReps: lastReps,
      averageRpe: avgRpe,
      suggestedWeightKg: suggestedWeight,
      suggestedReps: suggestedReps,
      message:
          'Last: ${_fmtWeight(lastWeight)} × $lastReps @ RPE ${avgRpe.toStringAsFixed(0)} → $tryPart',
      bumpWeight: bumpWeight,
    );
  }

  /// Prefill weight: last working set, or suggested bump when eligible.
  static double prefillWeight(OverloadSuggestion? suggestion, List<SetLog> lastSets) {
    if (suggestion != null && suggestion.averageRpe <= 7) {
      return suggestion.suggestedWeightKg;
    }
    if (lastSets.isNotEmpty) {
      return lastSets.last.weightKg;
    }
    return 20;
  }

  static String _fmtWeight(double kg) {
    if (kg == 0) return 'BW';
    if (kg == kg.roundToDouble()) return '${kg.toInt()}kg';
    return '${kg.toStringAsFixed(1)}kg';
  }
}
