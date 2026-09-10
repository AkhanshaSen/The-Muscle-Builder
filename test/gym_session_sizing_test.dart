import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/gym_session_sizing.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';

PlannedExercise _ex(String id) => PlannedExercise(
      exerciseId: id,
      name: 'Ex $id',
      muscleGroups: const [MuscleGroup.chest],
      sets: 3,
      reps: 10,
      restSeconds: 60,
      formCues: const [],
      commonMistakes: const [],
      includeDropSet: false,
      estimatedCalories: 40,
    );

WorkoutPlan _plan({
  required int gymMinutes,
  required int catalogSize,
  int? exerciseCountOverride,
}) {
  return WorkoutPlan(
    id: 'p1',
    checkInId: 'c1',
    createdAt: DateTime(2026, 9, 10),
    exercises: [for (var i = 0; i < catalogSize; i++) _ex('$i')],
    encouragement: 'Go',
    gymMinutes: gymMinutes,
    exerciseCountOverride: exerciseCountOverride,
  );
}

void main() {
  test('null override falls back to gym-time baseline', () {
    final plan = _plan(gymMinutes: 45, catalogSize: 12);
    expect(GymSessionSizing.exerciseCountFor(45), 6);
    expect(GymSessionSizing.resolvedCount(plan), 6);
    expect(GymSessionSizing.activeExercises(plan).length, 6);
  });

  test('override wins over gym-time baseline', () {
    final plan = _plan(
      gymMinutes: 45,
      catalogSize: 12,
      exerciseCountOverride: 9,
    );
    expect(GymSessionSizing.resolvedCount(plan), 9);
    expect(GymSessionSizing.activeExercises(plan).length, 9);
  });

  test('override clamps to generated catalog length', () {
    final plan = _plan(
      gymMinutes: 150,
      catalogSize: 5,
      exerciseCountOverride: 12,
    );
    expect(GymSessionSizing.resolvedCount(plan), 5);
    expect(GymSessionSizing.activeExercises(plan).length, 5);
  });

  test('override cannot go below one when catalog is non-empty', () {
    final plan = _plan(
      gymMinutes: 45,
      catalogSize: 8,
      exerciseCountOverride: 0,
    );
    expect(GymSessionSizing.resolvedCount(plan), 1);
  });
}
