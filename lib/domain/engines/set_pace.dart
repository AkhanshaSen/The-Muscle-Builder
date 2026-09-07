/// Practical set-duration targets for controlled lifting tempo.
///
/// Rule of thumb: ~2–3.5s per rep (controlled eccentric + concentric).
/// Holds/isometrics use a wider window around the planned rest cue.
class SetPaceTarget {
  const SetPaceTarget({
    required this.minSeconds,
    required this.maxSeconds,
    required this.tooSlowSeconds,
  });

  final int minSeconds;
  final int maxSeconds;
  final int tooSlowSeconds;

  factory SetPaceTarget.forExercise({
    required int reps,
    required String exerciseName,
  }) {
    final name = exerciseName.toLowerCase();
    final isHold = name.contains('plank') ||
        name.contains('hold') ||
        name.contains('bridge') ||
        name.contains('hang');

    if (isHold) {
      // Treat "reps" as approximate seconds for holds when that's how plans encode them,
      // otherwise default to a 30–60s working hold.
      final base = reps >= 15 ? reps : 40;
      return SetPaceTarget(
        minSeconds: (base * 0.7).round().clamp(20, 180),
        maxSeconds: (base * 1.15).round().clamp(30, 240),
        tooSlowSeconds: (base * 1.4).round().clamp(40, 300),
      );
    }

    // Strength / hypertrophy set: 2s–3.5s per rep ideal band.
    final min = (reps * 2).clamp(12, 180);
    final max = (reps * 3.5).round().clamp(20, 240);
    final tooSlow = (reps * 5).clamp(max + 5, 300);
    return SetPaceTarget(
      minSeconds: min,
      maxSeconds: max,
      tooSlowSeconds: tooSlow,
    );
  }

  String get rangeLabel => '$minSeconds–$maxSeconds s';
}

enum SetPaceVerdict {
  tooFast,
  onPace,
  aBitSlow,
  tooSlow;

  String get label => switch (this) {
        SetPaceVerdict.tooFast => 'Finished early',
        SetPaceVerdict.onPace => 'On pace',
        SetPaceVerdict.aBitSlow => 'A bit slow',
        SetPaceVerdict.tooSlow => 'Took too long',
      };

  String tip(SetPaceTarget target) => switch (this) {
        SetPaceVerdict.tooFast =>
          'Aim closer to ${target.rangeLabel} — control the eccentric.',
        SetPaceVerdict.onPace =>
          'Solid tempo for ${target.rangeLabel}. Keep that rhythm.',
        SetPaceVerdict.aBitSlow =>
          'Slightly over ${target.maxSeconds}s. Tighten rest between reps.',
        SetPaceVerdict.tooSlow =>
          'Over ${target.tooSlowSeconds}s. Shorter pauses between reps next set.',
      };
}

class SetPaceEvaluator {
  const SetPaceEvaluator._();

  static SetPaceVerdict verdict(int seconds, SetPaceTarget target) {
    if (seconds < target.minSeconds) return SetPaceVerdict.tooFast;
    if (seconds <= target.maxSeconds) return SetPaceVerdict.onPace;
    if (seconds <= target.tooSlowSeconds) return SetPaceVerdict.aBitSlow;
    return SetPaceVerdict.tooSlow;
  }

  /// Live coaching while the timer runs (before tick-off).
  static String liveStatus(int seconds, SetPaceTarget target) {
    if (seconds < target.minSeconds) {
      final left = target.minSeconds - seconds;
      return 'Building set · enter target band in ${left}s';
    }
    if (seconds <= target.maxSeconds) {
      return 'Within target · good time to finish';
    }
    if (seconds <= target.tooSlowSeconds) {
      return 'Past target · wrap this set soon';
    }
    return 'Well over target · finish and reset tempo';
  }

  static ColorTone toneFor(SetPaceVerdict v) => switch (v) {
        SetPaceVerdict.tooFast => ColorTone.warning,
        SetPaceVerdict.onPace => ColorTone.good,
        SetPaceVerdict.aBitSlow => ColorTone.warning,
        SetPaceVerdict.tooSlow => ColorTone.bad,
      };

  static ColorTone liveTone(int seconds, SetPaceTarget target) {
    if (seconds < target.minSeconds) return ColorTone.neutral;
    if (seconds <= target.maxSeconds) return ColorTone.good;
    if (seconds <= target.tooSlowSeconds) return ColorTone.warning;
    return ColorTone.bad;
  }
}

enum ColorTone { neutral, good, warning, bad }
