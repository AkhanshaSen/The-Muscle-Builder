import '../models/enums.dart';

/// How ready a muscle group is for hard work today.
enum MuscleReadiness {
  /// No logged session in the lookback window.
  fresh,

  /// Past the ~48 h recovery window.
  ready,

  /// 24–48 h — trainable, but better kept light.
  caution,

  /// Trained inside 24 h.
  recovering;

  String get label => switch (this) {
        MuscleReadiness.fresh => 'Fresh',
        MuscleReadiness.ready => 'Ready',
        MuscleReadiness.caution => 'Almost ready',
        MuscleReadiness.recovering => 'Recovering',
      };
}

class MuscleStatus {
  const MuscleStatus({
    required this.muscle,
    required this.readiness,
    required this.sessionsThisWeek,
    this.lastTrained,
    this.hoursSince,
  });

  final MuscleGroup muscle;
  final MuscleReadiness readiness;
  final int sessionsThisWeek;
  final DateTime? lastTrained;
  final int? hoursSince;

  bool get isRested =>
      readiness == MuscleReadiness.fresh || readiness == MuscleReadiness.ready;

  /// "Trained today" / "3 days ago" / "Not trained recently".
  String get sinceLabel {
    final hours = hoursSince;
    if (hours == null) return 'Not trained recently';
    if (hours < 12) return 'Trained today';
    if (hours < 36) return 'Trained yesterday';
    return 'Trained ${(hours / 24).floor()} days ago';
  }

  /// Compact badge for the body map: "today", "1d", "4d", "—".
  String get shortSince {
    final hours = hoursSince;
    if (hours == null) return '—';
    if (hours < 12) return 'today';
    return '${(hours / 24).round().clamp(1, 99)}d';
  }

  /// Hours still to wait before this group is past the 48 h window.
  int get hoursRemaining {
    final hours = hoursSince;
    if (hours == null) return 0;
    final left = MuscleRecoveryAdvisor.recoveryHours - hours;
    return left < 0 ? 0 : left;
  }
}

enum VerdictTone { good, stretch, caution }

class SelectionVerdict {
  const SelectionVerdict({
    required this.tone,
    required this.headline,
    required this.detail,
  });

  final VerdictTone tone;
  final String headline;
  final String detail;
}

/// Turns training history into realistic "what should I train today" advice.
///
/// Rules follow mainstream resistance-training guidance: leave roughly 48 h
/// before hitting the same group hard again, aim for 2–3 sessions per group
/// per week, and give every group you pick about two exercises so the
/// stimulus is worth the time.
class MuscleRecoveryAdvisor {
  const MuscleRecoveryAdvisor._();

  static const recoveryHours = 48;
  static const partialRecoveryHours = 24;

  /// A group needs ~2 moves (4–6 sets) in a session to be worth training.
  static const exercisesPerGroup = 2;

  /// Hard ceiling on groups per session regardless of gym time.
  /// Training more than 4 muscle groups in one session spreads volume too thin.
  static const maxGroupsPerDay = 4;

  static const weeklyFrequencyFloor = 2;
  static const weeklyFrequencyCeiling = 3;

  static Map<MuscleGroup, MuscleStatus> statuses({
    required Map<MuscleGroup, DateTime> lastTrained,
    Map<MuscleGroup, int> sessionsThisWeek = const {},
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    return {
      for (final muscle in MuscleGroup.values)
        muscle: _statusFor(
          muscle: muscle,
          lastTrained: lastTrained[muscle],
          sessionsThisWeek: sessionsThisWeek[muscle] ?? 0,
          now: clock,
        ),
    };
  }

  static MuscleStatus _statusFor({
    required MuscleGroup muscle,
    required DateTime? lastTrained,
    required int sessionsThisWeek,
    required DateTime now,
  }) {
    if (lastTrained == null) {
      return MuscleStatus(
        muscle: muscle,
        readiness: MuscleReadiness.fresh,
        sessionsThisWeek: sessionsThisWeek,
      );
    }
    final hours = now.difference(lastTrained).inHours;
    final readiness = hours >= recoveryHours
        ? MuscleReadiness.ready
        : hours >= partialRecoveryHours
            ? MuscleReadiness.caution
            : MuscleReadiness.recovering;
    return MuscleStatus(
      muscle: muscle,
      readiness: readiness,
      sessionsThisWeek: sessionsThisWeek,
      lastTrained: lastTrained,
      hoursSince: hours < 0 ? 0 : hours,
    );
  }

  /// How many groups realistically fit the exercises available today.
  static int maxGroupsFor(int exerciseCount) {
    final fit = exerciseCount ~/ exercisesPerGroup;
    return fit.clamp(1, MuscleGroup.values.length);
  }

  /// Most-recovered groups first, then least trained this week.
  static List<MuscleGroup> rank(Map<MuscleGroup, MuscleStatus> statuses) {
    final all = List<MuscleGroup>.from(MuscleGroup.values);
    all.sort((a, b) {
      final sa = statuses[a];
      final sb = statuses[b];
      if (sa == null || sb == null) return a.index.compareTo(b.index);

      final byReadiness = sa.readiness.index.compareTo(sb.readiness.index);
      if (byReadiness != 0) return byReadiness;

      final byFrequency = sa.sessionsThisWeek.compareTo(sb.sessionsThisWeek);
      if (byFrequency != 0) return byFrequency;

      final ha = sa.hoursSince ?? 1 << 30;
      final hb = sb.hoursSince ?? 1 << 30;
      final byRest = hb.compareTo(ha);
      if (byRest != 0) return byRest;

      return a.index.compareTo(b.index);
    });
    return all;
  }

  /// Groups that are inside the 24 h recovery window and must not be trained.
  /// These are hard-blocked — selecting them risks injury and junk volume.
  static Set<MuscleGroup> blockedGroups(
      Map<MuscleGroup, MuscleStatus> statuses) {
    return {
      for (final entry in statuses.entries)
        if (entry.value.readiness == MuscleReadiness.recovering) entry.key,
    };
  }

  /// Groups worth training today, given the time available.
  /// Never suggests a group inside the 24 h recovery window.
  /// Caps at [maxGroupsPerDay] regardless of gym time.
  static List<MuscleGroup> suggest({
    required Map<MuscleGroup, MuscleStatus> statuses,
    required int exerciseCount,
  }) {
    final blocked = blockedGroups(statuses);
    final cap =
        maxGroupsFor(exerciseCount).clamp(1, maxGroupsPerDay);
    final picks = rank(statuses)
        .where((m) => !blocked.contains(m))
        .take(cap)
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    return picks;
  }

  /// Why those groups came up — shown under the suggestion.
  static String suggestionReason({
    required List<MuscleGroup> suggested,
    required Map<MuscleGroup, MuscleStatus> statuses,
  }) {
    if (suggested.isEmpty) return '';
    final states = suggested
        .map((m) => statuses[m])
        .whereType<MuscleStatus>()
        .toList();
    if (states.isEmpty) return '';

    if (states.every((s) => s.readiness == MuscleReadiness.fresh)) {
      return 'No recent sessions logged for these — a good place to start.';
    }
    if (states.every((s) => s.isRested)) {
      return 'Past the 48 h recovery window and least trained this week.';
    }
    if (states.any((s) => s.readiness == MuscleReadiness.recovering)) {
      return 'Everything is inside 48 h right now — these are the most rested, '
          'but a rest day or light mobility is the honest call.';
    }
    return 'These are your most recovered groups right now.';
  }

  static SelectionVerdict verdict({
    required Set<MuscleGroup> selected,
    required Map<MuscleGroup, MuscleStatus> statuses,
    required int exerciseCount,
  }) {
    final maxGroups = maxGroupsFor(exerciseCount);

    if (selected.isEmpty) {
      return SelectionVerdict(
        tone: VerdictTone.good,
        headline: 'Pick your groups for today',
        detail: '$exerciseCount exercises fit your gym time — room for up to '
            '$maxGroups group${maxGroups == 1 ? '' : 's'} at '
            '~$exercisesPerGroup moves each.',
      );
    }

    final perGroup = exerciseCount / selected.length;
    final perGroupLabel = perGroup >= 2
        ? '~${perGroup.floor()} exercises each'
        : 'about 1 exercise each';
    final tooSoon = selected
        .map((m) => statuses[m])
        .whereType<MuscleStatus>()
        .where((s) => s.readiness == MuscleReadiness.recovering)
        .toList();
    final overworked = selected
        .map((m) => statuses[m])
        .whereType<MuscleStatus>()
        .where((s) => s.sessionsThisWeek >= weeklyFrequencyCeiling)
        .toList();

    if (tooSoon.isNotEmpty) {
      final names = tooSoon.map((s) => s.muscle.label).join(', ');
      final wait = tooSoon
          .map((s) => s.hoursRemaining)
          .reduce((a, b) => a > b ? a : b);
      return SelectionVerdict(
        tone: VerdictTone.caution,
        headline: '$names is blocked — trained in the last 24 h',
        detail: 'Repeating the same group back-to-back cuts gains and risks '
            'injury. Remove it and let it recover (~$wait h left).',
      );
    }

    if (selected.length > maxGroups) {
      return SelectionVerdict(
        tone: VerdictTone.stretch,
        headline: '${selected.length} groups — spreads volume too thin',
        detail: 'That is $perGroupLabel. Cap at $maxGroups group'
            '${maxGroups == 1 ? '' : 's'} (max $maxGroupsPerDay per session) '
            'for a real stimulus, or add gym time.',
      );
    }

    if (overworked.isNotEmpty) {
      final names = overworked.map((s) => s.muscle.label).join(', ');
      return SelectionVerdict(
        tone: VerdictTone.stretch,
        headline: '$names already hit $weeklyFrequencyCeiling× this week',
        detail: '$weeklyFrequencyFloor–$weeklyFrequencyCeiling sessions per '
            'group per week covers most people. Fine to continue, just keep '
            'the volume sensible.',
      );
    }

    final rested = selected
        .map((m) => statuses[m])
        .whereType<MuscleStatus>()
        .where((s) => s.isRested)
        .length;
    return SelectionVerdict(
      tone: VerdictTone.good,
      headline: '${selected.length} group'
          '${selected.length == 1 ? '' : 's'} · $perGroupLabel',
      detail: rested == selected.length
          ? 'All recovered and inside what your session time supports.'
          : 'Fits your session time. $rested of ${selected.length} are past '
              'the 48 h window.',
    );
  }
}
