import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/routine_engine.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';

void main() {
  final bank = [
    for (var i = 0; i < 20; i++)
      Exercise(
        id: 'ex_$i',
        name: 'Exercise $i',
        muscleGroups: [
          i < 10 ? MuscleGroup.chest : MuscleGroup.arms,
        ],
        equipment: const [Equipment.bodyweight, Equipment.dumbbell],
        difficulty: ExperienceLevel.beginner,
        estimatedCalories: 50,
        formCues: const ['Cue'],
        commonMistakes: const ['Mistake'],
        isCompound: i.isEven,
        variants: const {
          ExperienceLevel.beginner:
              ExerciseVariant(sets: 3, reps: 10, restSeconds: 60),
          ExperienceLevel.intermediate:
              ExerciseVariant(sets: 3, reps: 12, restSeconds: 60),
          ExperienceLevel.advanced:
              ExerciseVariant(sets: 4, reps: 8, restSeconds: 45),
        },
      ),
  ];

  test('generate returns intensity-appropriate set count', () {
    final engine = RoutineEngine();
    final plan = engine.generate(
      mood: Mood.motivated,
      intensity: Intensity.moderate,
      muscles: const [MuscleGroup.chest, MuscleGroup.arms],
      availableEquipment: const [Equipment.bodyweight, Equipment.dumbbell],
      experience: ExperienceLevel.beginner,
      bank: bank,
      seed: 42,
    );

    expect(plan, isNotEmpty);
    expect(plan.length, inInclusiveRange(5, 6));
    expect(plan.every((e) => e.sets == 3), isTrue);
  });

  test('exercise order puts compounds before isolation', () {
    final engine = RoutineEngine();
    final plan = engine.generate(
      mood: Mood.motivated,
      intensity: Intensity.pushHard,
      muscles: const [MuscleGroup.chest, MuscleGroup.arms],
      availableEquipment: const [Equipment.bodyweight, Equipment.dumbbell],
      experience: ExperienceLevel.beginner,
      bank: bank,
      seed: 11,
      exerciseCount: 6,
    );

    expect(plan.length, 6);
    final firstCompoundIdx = plan.indexWhere((e) => e.isCompound);
    final lastIsolationIdx = plan.lastIndexWhere((e) => !e.isCompound);
    if (firstCompoundIdx >= 0 && lastIsolationIdx >= 0) {
      expect(firstCompoundIdx, lessThan(lastIsolationIdx));
    }
    expect(RoutineOrderGuide.sessionGuide(plan), contains('Order is intentional'));
  });

  test('surprise muscles prefers undertrained groups', () {
    final engine = RoutineEngine();
    final picks = engine.surpriseMuscles(
      recentlyTrained: const [MuscleGroup.chest, MuscleGroup.arms],
      count: 2,
      seed: 7,
    );
    expect(picks.length, 2);
    expect(picks.contains(MuscleGroup.chest), isFalse);
    expect(picks.contains(MuscleGroup.arms), isFalse);
  });
}
