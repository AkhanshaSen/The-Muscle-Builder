import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/set_pace.dart';

void main() {
  test('10-rep set has a practical target band', () {
    final t = SetPaceTarget.forExercise(reps: 10, exerciseName: 'Bench Press');
    expect(t.minSeconds, 20);
    expect(t.maxSeconds, 35);
    expect(t.tooSlowSeconds, greaterThan(t.maxSeconds));
  });

  test('verdicts map elapsed time to coaching labels', () {
    final t = SetPaceTarget.forExercise(reps: 10, exerciseName: 'Row');
    expect(SetPaceEvaluator.verdict(10, t), SetPaceVerdict.tooFast);
    expect(SetPaceEvaluator.verdict(t.minSeconds + 1, t), SetPaceVerdict.onPace);
    expect(
      SetPaceEvaluator.verdict(t.maxSeconds + 1, t),
      SetPaceVerdict.aBitSlow,
    );
    expect(
      SetPaceEvaluator.verdict(t.tooSlowSeconds + 1, t),
      SetPaceVerdict.tooSlow,
    );
  });
}
