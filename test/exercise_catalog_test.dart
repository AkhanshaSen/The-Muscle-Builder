import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/exercise_catalog.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';

Exercise _ex({
  required String id,
  String name = '',
  List<MuscleGroup> muscles = const [MuscleGroup.chest],
  List<ExerciseAudience> audiences = const [ExerciseAudience.all],
  List<String> demoImages = const [],
}) {
  return Exercise(
    id: id,
    name: name.isEmpty ? id : name,
    muscleGroups: muscles,
    equipment: const [Equipment.bodyweight],
    difficulty: ExperienceLevel.beginner,
    estimatedCalories: 80,
    formCues: const ['cue'],
    commonMistakes: const ['mistake'],
    variants: const {
      ExperienceLevel.beginner:
          ExerciseVariant(sets: 3, reps: 10, restSeconds: 60),
    },
    audiences: audiences,
    demoImages: demoImages,
  );
}

void main() {
  test('female filter drops male-only exercises', () {
    final bank = [
      _ex(id: 'all_chest', audiences: const [ExerciseAudience.all]),
      _ex(id: 'male_only', audiences: const [ExerciseAudience.male]),
      _ex(id: 'female_only', audiences: const [ExerciseAudience.female]),
    ];
    final out = ExerciseCatalog.filterExercises(
      bank,
      gender: Gender.female,
    );
    expect(out.map((e) => e.id), containsAll(['all_chest', 'female_only']));
    expect(out.map((e) => e.id), isNot(contains('male_only')));
  });

  test('muscle chip filter keeps overlapping groups only', () {
    final bank = [
      _ex(id: 'chest', muscles: const [MuscleGroup.chest]),
      _ex(id: 'legs', muscles: const [MuscleGroup.legs]),
    ];
    final out = ExerciseCatalog.filterExercises(
      bank,
      muscleGroups: {MuscleGroup.chest},
    );
    expect(out.length, 1);
    expect(out.first.id, 'chest');
  });

  test('search is case-insensitive substring', () {
    final bank = [
      _ex(id: 'Push-Up', muscles: const [MuscleGroup.chest], name: 'Push-Up'),
    ];
    final out = ExerciseCatalog.filterExercises(bank, query: 'push');
    expect(out.length, 1);
  });

  test('dedupeByDisplayName keeps richer duplicate', () {
    final sparse = _ex(id: 'a', name: 'Band Chest Press');
    final rich = _ex(
      id: 'b',
      name: 'Band Chest Press',
      demoImages: const ['http://x/0.jpg', 'http://x/1.jpg'],
    );
    final out = ExerciseCatalog.dedupeByDisplayName([sparse, rich]);
    expect(out.length, 1);
    expect(out.first.id, 'b');
  });

  test('quickSteps prefers json field then trims formCues', () {
    final withJson = Exercise(
      id: 'a',
      name: 'a',
      muscleGroups: const [MuscleGroup.chest],
      equipment: const [Equipment.bodyweight],
      difficulty: ExperienceLevel.beginner,
      estimatedCalories: 1,
      formCues: const ['long unused'],
      commonMistakes: const [],
      variants: const {
        ExperienceLevel.beginner:
            ExerciseVariant(sets: 1, reps: 1, restSeconds: 1),
      },
      quickSteps: const ['One', 'Two', 'Three'],
    );
    expect(ExerciseCatalog.quickSteps(withJson), ['One', 'Two', 'Three']);

    final fromCues = _ex(id: 'b');
    final steps = ExerciseCatalog.quickSteps(fromCues);
    expect(steps.length, 3);
    expect(steps.first, 'cue');
  });
}