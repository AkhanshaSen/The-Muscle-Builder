import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/muscle_recovery.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';

void main() {
  final now = DateTime(2026, 9, 10, 9);

  Map<MuscleGroup, MuscleStatus> build({
    Map<MuscleGroup, Duration> trainedAgo = const {},
    Map<MuscleGroup, int> sessionsThisWeek = const {},
  }) {
    return MuscleRecoveryAdvisor.statuses(
      lastTrained: {
        for (final entry in trainedAgo.entries)
          entry.key: now.subtract(entry.value),
      },
      sessionsThisWeek: sessionsThisWeek,
      now: now,
    );
  }

  test('readiness follows the 48 hour recovery window', () {
    final statuses = build(
      trainedAgo: const {
        MuscleGroup.chest: Duration(hours: 6),
        MuscleGroup.back: Duration(hours: 30),
        MuscleGroup.legs: Duration(hours: 60),
      },
    );

    expect(statuses[MuscleGroup.chest]!.readiness, MuscleReadiness.recovering);
    expect(statuses[MuscleGroup.back]!.readiness, MuscleReadiness.caution);
    expect(statuses[MuscleGroup.legs]!.readiness, MuscleReadiness.ready);
    expect(statuses[MuscleGroup.arms]!.readiness, MuscleReadiness.fresh);
  });

  test('group capacity scales with the exercises that fit the session', () {
    expect(MuscleRecoveryAdvisor.maxGroupsFor(3), 1);
    expect(MuscleRecoveryAdvisor.maxGroupsFor(6), 3);
    expect(MuscleRecoveryAdvisor.maxGroupsFor(12), 6);
  });

  test('suggestion skips groups trained yesterday', () {
    final statuses = build(
      trainedAgo: const {
        MuscleGroup.chest: Duration(hours: 8),
        MuscleGroup.arms: Duration(hours: 8),
        MuscleGroup.shoulders: Duration(hours: 20),
      },
    );

    final picks = MuscleRecoveryAdvisor.suggest(
      statuses: statuses,
      exerciseCount: 6,
    );

    expect(picks.length, 3);
    expect(picks, isNot(contains(MuscleGroup.chest)));
    expect(picks, isNot(contains(MuscleGroup.arms)));
    expect(picks, isNot(contains(MuscleGroup.shoulders)));
  });

  test('suggestion prefers the least trained group this week', () {
    final statuses = build(
      trainedAgo: const {
        MuscleGroup.chest: Duration(days: 3),
        MuscleGroup.back: Duration(days: 3),
        MuscleGroup.legs: Duration(days: 3),
        MuscleGroup.shoulders: Duration(days: 3),
        MuscleGroup.arms: Duration(days: 3),
        MuscleGroup.core: Duration(days: 3),
      },
      sessionsThisWeek: const {
        MuscleGroup.chest: 3,
        MuscleGroup.back: 0,
        MuscleGroup.legs: 3,
        MuscleGroup.shoulders: 3,
        MuscleGroup.arms: 3,
        MuscleGroup.core: 3,
      },
    );

    final picks = MuscleRecoveryAdvisor.suggest(
      statuses: statuses,
      exerciseCount: 6,
    );

    expect(picks, contains(MuscleGroup.back));
  });

  test('suggestions are capped at maxGroupsPerDay regardless of gym time', () {
    // 10 exercises would fit 5 groups by time, but hard cap is 4.
    final picks = MuscleRecoveryAdvisor.suggest(
      statuses: build(),
      exerciseCount: 10,
    );

    expect(picks.length, MuscleRecoveryAdvisor.maxGroupsPerDay);
  });

  test('verdict warns when a selected group is inside 24 hours', () {
    final statuses = build(
      trainedAgo: const {MuscleGroup.chest: Duration(hours: 10)},
    );

    final verdict = MuscleRecoveryAdvisor.verdict(
      selected: {MuscleGroup.chest},
      statuses: statuses,
      exerciseCount: 6,
    );

    expect(verdict.tone, VerdictTone.caution);
    expect(verdict.headline, contains('Chest'));
  });

  test('verdict flags too many groups for the time available', () {
    final verdict = MuscleRecoveryAdvisor.verdict(
      selected: MuscleGroup.values.toSet(),
      statuses: build(),
      exerciseCount: 4,
    );

    expect(verdict.tone, VerdictTone.stretch);
    expect(verdict.detail, contains('Cap at 2'));
  });

  test('three rested groups in a long session is a good day', () {
    final verdict = MuscleRecoveryAdvisor.verdict(
      selected: const {MuscleGroup.chest, MuscleGroup.back, MuscleGroup.arms},
      statuses: build(
        trainedAgo: const {
          MuscleGroup.chest: Duration(days: 3),
          MuscleGroup.back: Duration(days: 4),
          MuscleGroup.arms: Duration(days: 3),
        },
      ),
      exerciseCount: 7,
    );

    expect(verdict.tone, VerdictTone.good);
    expect(verdict.headline, contains('3 groups'));
  });
}
