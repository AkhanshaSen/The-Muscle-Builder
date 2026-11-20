import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/custom_routine_launcher.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';

void main() {
  test('maps exercise ids to planned rows in order', () {
    final bank = [
      Exercise(
        id: 'a',
        name: 'Move A',
        muscleGroups: const [MuscleGroup.chest],
        equipment: const [Equipment.dumbbell],
        difficulty: ExperienceLevel.beginner,
        estimatedCalories: 90,
        formCues: const [],
        commonMistakes: const [],
        variants: const {
          ExperienceLevel.intermediate:
              ExerciseVariant(sets: 4, reps: 8, restSeconds: 50),
        },
      ),
    ];

    final planned = CustomRoutineLauncher.plannedExercises(
      exerciseIds: const ['a'],
      bank: bank,
      experience: ExperienceLevel.intermediate,
    );

    expect(planned.length, 1);
    expect(planned.first.exerciseId, 'a');
    expect(planned.first.reps, 8);
    expect(planned.first.sets, greaterThan(0));
  });
}