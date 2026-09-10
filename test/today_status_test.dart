import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/app/providers.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';

DayLog _log({DayKind planned = DayKind.gym, DayKind? actual}) {
  return DayLog(
    id: 'd1',
    date: DateTime(2026, 9, 10),
    plannedKind: planned,
    actualKind: actual,
    updatedAt: DateTime(2026, 9, 10),
  );
}

void main() {
  test('isRestLogged is false when nothing is logged', () {
    final status = TodayStatus(plan: null, dayLog: _log());
    expect(status.isRestLogged, isFalse);
    expect(status.loggedKind, isNull);
  });

  test('isRestLogged is false when logged Gym', () {
    final status = TodayStatus(
      plan: null,
      dayLog: _log(actual: DayKind.gym),
    );
    expect(status.isRestLogged, isFalse);
  });

  test('isRestLogged is true for Rest, Cheat and Skip', () {
    for (final kind in [DayKind.rest, DayKind.cheat, DayKind.skip]) {
      final status = TodayStatus(
        plan: null,
        dayLog: _log(actual: kind),
      );
      expect(status.isRestLogged, isTrue, reason: kind.name);
      expect(status.loggedKind, kind);
    }
  });

  test('planned-only rest does not suppress the plan', () {
    final status = TodayStatus(
      plan: null,
      dayLog: _log(planned: DayKind.rest),
    );
    expect(status.isRestLogged, isFalse);
  });
}
