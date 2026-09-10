import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/data/db/app_database.dart';
import 'package:the_muscle_builder/data/repositories/cloud_sync_port.dart';
import 'package:the_muscle_builder/data/repositories/workout_repository.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';
import 'package:uuid/uuid.dart';

PlannedExercise _ex(String id) => PlannedExercise(
      exerciseId: id,
      name: 'Move $id',
      muscleGroups: const [MuscleGroup.chest],
      sets: 3,
      reps: 10,
      restSeconds: 60,
      estimatedCalories: 50,
      formCues: const ['Brace'],
      commonMistakes: const ['Rush'],
      includeDropSet: false,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('resetToday clears check-in and unfinished plans, keeps completed history',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final workouts = WorkoutRepository(db, NoOpCloudSync());
    const uuid = Uuid();

    // Finished workout from earlier today — must survive reset.
    final doneCheckIn = DailyCheckIn(
      id: uuid.v4(),
      date: DateTime.now().subtract(const Duration(hours: 3)),
      mood: Mood.energetic,
      intensity: Intensity.moderate,
      selectedMuscles: const [MuscleGroup.chest],
      surpriseMe: false,
    );
    await workouts.saveCheckIn(doneCheckIn);
    final donePlan = await workouts.savePlan(
      WorkoutPlan(
        id: uuid.v4(),
        checkInId: doneCheckIn.id,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        exercises: [_ex('a')],
        encouragement: 'Done',
      ),
    );
    final session = await workouts.startSession(donePlan);
    await workouts.completeSession(session.id);

    // Current unfinished plan — must be deleted with its check-in.
    final openCheckIn = DailyCheckIn(
      id: uuid.v4(),
      date: DateTime.now(),
      mood: Mood.tired,
      intensity: Intensity.light,
      selectedMuscles: const [MuscleGroup.arms],
      surpriseMe: false,
    );
    await workouts.saveCheckIn(openCheckIn);
    final openPlan = await workouts.savePlan(
      WorkoutPlan(
        id: uuid.v4(),
        checkInId: openCheckIn.id,
        createdAt: DateTime.now(),
        exercises: [_ex('b')],
        encouragement: 'Open',
      ),
    );
    final unfinished = await workouts.startSession(openPlan);

    expect(await workouts.getTodaysCheckIn(), isNotNull);
    expect(await workouts.getTodaysPlan(), isNotNull);

    await workouts.resetToday();

    expect(await workouts.getTodaysCheckIn(), isNull);
    expect(await workouts.getTodaysPlan(), isNull);

    // Completed plan + session kept for Progress.
    expect(await workouts.getPlanById(donePlan.id), isNotNull);
    final sessions = await workouts.getAllSessions();
    expect(sessions.any((s) => s.id == session.id && s.completed), isTrue);

    // Unfinished plan and session gone.
    expect(await workouts.getPlanById(openPlan.id), isNull);
    expect(sessions.any((s) => s.id == unfinished.id), isFalse);
  });
}
