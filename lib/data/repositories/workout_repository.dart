import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../db/app_database.dart';
import 'cloud_sync_port.dart';

class WorkoutRepository {
  WorkoutRepository(this._db, this._sync);

  final AppDatabase _db;
  final CloudSyncPort _sync;
  final _uuid = const Uuid();

  Future<DailyCheckIn> saveCheckIn(DailyCheckIn checkIn) async {
    await _db.into(_db.dailyCheckIns).insertOnConflictUpdate(
          DailyCheckInsCompanion(
            id: Value(checkIn.id),
            date: Value(checkIn.date),
            mood: Value(checkIn.mood.name),
            intensity: Value(checkIn.intensity.name),
            selectedMusclesJson: Value(
              encodeStringList(
                checkIn.selectedMuscles.map((e) => e.name).toList(),
              ),
            ),
            surpriseMe: Value(checkIn.surpriseMe),
            focus: Value(checkIn.focus.name),
            soreness: Value(checkIn.soreness.name),
            avoidMusclesJson: Value(
              encodeStringList(
                checkIn.avoidMuscles.map((e) => e.name).toList(),
              ),
            ),
            equipmentOverrideJson: Value(
              checkIn.equipmentOverride == null
                  ? null
                  : encodeStringList(
                      checkIn.equipmentOverride!.map((e) => e.name).toList(),
                    ),
            ),
          ),
        );
    return checkIn;
  }

  DailyCheckIn _mapCheckIn(DailyCheckInRow row) {
    List<Equipment>? equipOverride;
    final rawEquip = row.equipmentOverrideJson;
    if (rawEquip != null && rawEquip.isNotEmpty) {
      equipOverride = decodeStringList(rawEquip)
          .map(Equipment.values.byName)
          .toList();
    }
    return DailyCheckIn(
      id: row.id,
      date: row.date,
      mood: Mood.values.byName(row.mood),
      intensity: Intensity.values.byName(row.intensity),
      selectedMuscles: decodeStringList(row.selectedMusclesJson)
          .map(MuscleGroup.values.byName)
          .toList(),
      surpriseMe: row.surpriseMe,
      focus: TrainingFocus.values.byName(row.focus),
      soreness: SorenessLevel.values.asNameMap()[row.soreness] ??
          SorenessLevel.none,
      avoidMuscles: decodeStringList(row.avoidMusclesJson)
          .map(MuscleGroup.values.byName)
          .toList(),
      equipmentOverride: equipOverride,
    );
  }

  Future<DailyCheckIn?> getTodaysCheckIn() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final row = await (_db.select(_db.dailyCheckIns)
          ..where((t) => t.date.isBiggerOrEqualValue(start) & t.date.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return _mapCheckIn(row);
  }

  /// Last completed working sets for an exercise (most recent completed session).
  Future<List<SetLog>> lastPerformanceForExercise(String exerciseId) async {
    final sessions = await (_db.select(_db.workoutSessions)
          ..where((t) => t.completed.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    for (final session in sessions) {
      final logs = await (_db.select(_db.setLogs)
            ..where(
              (t) =>
                  t.sessionId.equals(session.id) &
                  t.exerciseId.equals(exerciseId) &
                  t.completed.equals(true),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
          .get();
      if (logs.isEmpty) continue;
      return logs
          .map(
            (l) => SetLog(
              id: l.id,
              sessionId: l.sessionId,
              exerciseId: l.exerciseId,
              setNumber: l.setNumber,
              repsCompleted: l.repsCompleted,
              weightKg: l.weightKg,
              rpe: l.rpe,
              completed: l.completed,
              durationSeconds: l.durationSeconds,
            ),
          )
          .toList();
    }
    return const [];
  }

  Future<List<DailyCheckIn>> getAllCheckIns() async {
    final rows = await (_db.select(_db.dailyCheckIns)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return rows.map(_mapCheckIn).toList();
  }

  Future<List<WorkoutPlan>> getAllPlans() async {
    final rows = await (_db.select(_db.workoutPlans)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_mapPlan).toList();
  }

  Future<List<SetLog>> getAllSetLogs() async {
    final rows = await _db.select(_db.setLogs).get();
    return rows
        .map(
          (l) => SetLog(
            id: l.id,
            sessionId: l.sessionId,
            exerciseId: l.exerciseId,
            setNumber: l.setNumber,
            repsCompleted: l.repsCompleted,
            weightKg: l.weightKg,
            rpe: l.rpe,
            completed: l.completed,
            durationSeconds: l.durationSeconds,
          ),
        )
        .toList();
  }

  Future<List<WorkoutSession>> getAllSessions() async {
    final rows = await (_db.select(_db.workoutSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    final sessions = <WorkoutSession>[];
    for (final row in rows) {
      final logs = await (_db.select(_db.setLogs)
            ..where((t) => t.sessionId.equals(row.id)))
          .get();
      sessions.add(_mapSession(row, logs));
    }
    return sessions;
  }

  Future<void> upsertCheckInRaw(DailyCheckIn checkIn) => saveCheckIn(checkIn);

  Future<void> upsertPlanRaw(WorkoutPlan plan) => savePlan(plan);

  Future<void> upsertSessionRaw(WorkoutSession session) async {
    await _db.into(_db.workoutSessions).insertOnConflictUpdate(
          WorkoutSessionsCompanion(
            id: Value(session.id),
            planId: Value(session.planId),
            startedAt: Value(session.startedAt),
            endedAt: Value(session.endedAt),
            completed: Value(session.completed),
            muscleGroupsJson: Value(
              encodeStringList(
                session.muscleGroups.map((e) => e.name).toList(),
              ),
            ),
          ),
        );
    for (final log in session.setLogs) {
      await logSet(log);
    }
  }

  Future<WorkoutPlan> savePlan(WorkoutPlan plan) async {
    await _db.into(_db.workoutPlans).insertOnConflictUpdate(
          WorkoutPlansCompanion(
            id: Value(plan.id),
            checkInId: Value(plan.checkInId),
            createdAt: Value(plan.createdAt),
            exercisesJson: Value(
              jsonEncode(plan.exercises.map((e) => e.toJson()).toList()),
            ),
            encouragement: Value(plan.encouragement),
            preMealJson: Value(
              plan.preMeal == null ? null : jsonEncode(plan.preMeal!.toJson()),
            ),
            postMealJson: Value(
              plan.postMeal == null
                  ? null
                  : jsonEncode(plan.postMeal!.toJson()),
            ),
            gymMinutes: Value(plan.gymMinutes),
            exerciseCountOverride: Value(plan.exerciseCountOverride),
          ),
        );
    return plan;
  }

  Future<WorkoutPlan?> getTodaysPlan() async {
    final checkIn = await getTodaysCheckIn();
    if (checkIn == null) return null;
    final row = await (_db.select(_db.workoutPlans)
          ..where((t) => t.checkInId.equals(checkIn.id))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return _mapPlan(row);
  }

  /// Clears today's check-in(s) and any plans that have no completed session,
  /// so Home falls back to "Start check-in". Finished workouts (and their
  /// plans) stay for Progress history. Day logs are untouched.
  Future<void> resetToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final checkIns = await (_db.select(_db.dailyCheckIns)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          ))
        .get();
    if (checkIns.isEmpty) return;

    final checkInIds = checkIns.map((c) => c.id).toList();
    final plans = await (_db.select(_db.workoutPlans)
          ..where((t) => t.checkInId.isIn(checkInIds)))
        .get();

    for (final plan in plans) {
      final completed = await (_db.select(_db.workoutSessions)
            ..where(
              (t) => t.planId.equals(plan.id) & t.completed.equals(true),
            )
            ..limit(1))
          .getSingleOrNull();
      if (completed != null) continue;

      final sessions = await (_db.select(_db.workoutSessions)
            ..where((t) => t.planId.equals(plan.id)))
          .get();
      for (final session in sessions) {
        await (_db.delete(_db.setLogs)
              ..where((t) => t.sessionId.equals(session.id)))
            .go();
      }
      await (_db.delete(_db.workoutSessions)
            ..where((t) => t.planId.equals(plan.id)))
          .go();
      await (_db.delete(_db.workoutPlans)..where((t) => t.id.equals(plan.id)))
          .go();
    }

    await (_db.delete(_db.dailyCheckIns)
          ..where((t) => t.id.isIn(checkInIds)))
        .go();
  }

  Future<WorkoutPlan?> getPlanById(String id) async {
    final row = await (_db.select(_db.workoutPlans)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapPlan(row);
  }

  Future<WorkoutPlan> updatePlanExercises(
    String planId,
    List<PlannedExercise> exercises, {
    int? gymMinutes,
  }) async {
    await (_db.update(_db.workoutPlans)..where((t) => t.id.equals(planId)))
        .write(
      WorkoutPlansCompanion(
        exercisesJson: Value(
          jsonEncode(exercises.map((e) => e.toJson()).toList()),
        ),
        gymMinutes: gymMinutes == null
            ? const Value.absent()
            : Value(gymMinutes),
      ),
    );
    final plan = await getPlanById(planId);
    return plan!;
  }

  /// Sets or clears the user override for how many exercises to run today.
  /// Pass `null` to fall back to the gym-time baseline.
  Future<WorkoutPlan> updatePlanExerciseCount(
    String planId,
    int? count,
  ) async {
    await (_db.update(_db.workoutPlans)..where((t) => t.id.equals(planId)))
        .write(
      WorkoutPlansCompanion(
        exerciseCountOverride: Value(count),
      ),
    );
    final plan = await getPlanById(planId);
    return plan!;
  }

  Future<WorkoutPlan> updatePlanMeals({
    required String planId,
    MealSuggestion? preMeal,
    MealSuggestion? postMeal,
  }) async {
    await (_db.update(_db.workoutPlans)..where((t) => t.id.equals(planId)))
        .write(
      WorkoutPlansCompanion(
        preMealJson: Value(
          preMeal == null ? null : jsonEncode(preMeal.toJson()),
        ),
        postMealJson: Value(
          postMeal == null ? null : jsonEncode(postMeal.toJson()),
        ),
      ),
    );
    final plan = await getPlanById(planId);
    return plan!;
  }

  Future<WorkoutSession> startSession(WorkoutPlan plan) async {
    final session = WorkoutSession(
      id: _uuid.v4(),
      planId: plan.id,
      startedAt: DateTime.now(),
      muscleGroups: plan.exercises
          .expand((e) => e.muscleGroups)
          .toSet()
          .toList(),
    );
    await _db.into(_db.workoutSessions).insert(
          WorkoutSessionsCompanion(
            id: Value(session.id),
            planId: Value(session.planId),
            startedAt: Value(session.startedAt),
            muscleGroupsJson: Value(
              encodeStringList(
                session.muscleGroups.map((e) => e.name).toList(),
              ),
            ),
          ),
        );
    return session;
  }

  Future<void> logSet(SetLog setLog) async {
    await _db.into(_db.setLogs).insertOnConflictUpdate(
          SetLogsCompanion(
            id: Value(setLog.id),
            sessionId: Value(setLog.sessionId),
            exerciseId: Value(setLog.exerciseId),
            setNumber: Value(setLog.setNumber),
            repsCompleted: Value(setLog.repsCompleted),
            weightKg: Value(setLog.weightKg),
            rpe: Value(setLog.rpe),
            completed: Value(setLog.completed),
            durationSeconds: Value(setLog.durationSeconds),
          ),
        );
  }

  Future<WorkoutSession> completeSession(String sessionId) async {
    final ended = DateTime.now();
    await (_db.update(_db.workoutSessions)
          ..where((t) => t.id.equals(sessionId)))
        .write(
      WorkoutSessionsCompanion(
        endedAt: Value(ended),
        completed: const Value(true),
      ),
    );
    final session = await getSessionById(sessionId);
    await _sync.syncSession({'id': sessionId, 'completed': true});
    return session!;
  }

  Future<WorkoutSession?> getSessionById(String id) async {
    final row = await (_db.select(_db.workoutSessions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    final logs = await (_db.select(_db.setLogs)
          ..where((t) => t.sessionId.equals(id)))
        .get();
    return _mapSession(row, logs);
  }

  Future<WorkoutSession?> getActiveSession() async {
    final row = await (_db.select(_db.workoutSessions)
          ..where((t) => t.completed.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    final logs = await (_db.select(_db.setLogs)
          ..where((t) => t.sessionId.equals(row.id)))
        .get();
    return _mapSession(row, logs);
  }

  Stream<List<WorkoutSession>> watchCompletedSessions() {
    return (_db.select(_db.workoutSessions)
          ..where((t) => t.completed.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .watch()
        .asyncMap((rows) async {
      final sessions = <WorkoutSession>[];
      for (final row in rows) {
        final logs = await (_db.select(_db.setLogs)
              ..where((t) => t.sessionId.equals(row.id)))
            .get();
        sessions.add(_mapSession(row, logs));
      }
      return sessions;
    });
  }

  Future<List<WorkoutSession>> getCompletedSessions() async {
    final rows = await (_db.select(_db.workoutSessions)
          ..where((t) => t.completed.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    final sessions = <WorkoutSession>[];
    for (final row in rows) {
      final logs = await (_db.select(_db.setLogs)
            ..where((t) => t.sessionId.equals(row.id)))
          .get();
      sessions.add(_mapSession(row, logs));
    }
    return sessions;
  }

  /// Recent plans with pre/post meal choices for Progress “fuel log”.
  Future<List<FuelHistoryEntry>> getRecentFuelHistory({int limit = 20}) async {
    final rows = await (_db.select(_db.workoutPlans)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
    return rows.map((row) {
      final plan = _mapPlan(row);
      return FuelHistoryEntry(
        date: plan.createdAt,
        planId: plan.id,
        preMealName: plan.preMeal?.name,
        preMealCalories: plan.preMeal?.calories,
        postMealName: plan.postMeal?.name,
        postMealCalories: plan.postMeal?.calories,
        gymMinutes: plan.gymMinutes,
      );
    }).toList();
  }

  Future<Map<String, WorkoutPlan>> getPlansByIds(Iterable<String> ids) async {
    final unique = ids.toSet().toList();
    if (unique.isEmpty) return {};
    final map = <String, WorkoutPlan>{};
    for (final id in unique) {
      final plan = await getPlanById(id);
      if (plan != null) map[id] = plan;
    }
    return map;
  }

  Future<List<WorkoutSession>> getSessionsOnDay(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final rows = await (_db.select(_db.workoutSessions)
          ..where(
            (t) =>
                t.startedAt.isBiggerOrEqualValue(start) &
                t.startedAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    final sessions = <WorkoutSession>[];
    for (final row in rows) {
      final logs = await (_db.select(_db.setLogs)
            ..where((t) => t.sessionId.equals(row.id)))
          .get();
      sessions.add(_mapSession(row, logs));
    }
    return sessions;
  }

  Future<WorkoutPlan?> getPlanCreatedOnDay(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final row = await (_db.select(_db.workoutPlans)
          ..where(
            (t) =>
                t.createdAt.isBiggerOrEqualValue(start) &
                t.createdAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _mapPlan(row);
  }

  Future<DayActivitySnapshot> getDayActivity(
    DateTime date,
    Future<DayLog> Function(DateTime) ensureDayLog,
  ) async {
    final key = DateTime(date.year, date.month, date.day);
    final dayLog = await ensureDayLog(key);
    final sessions = await getSessionsOnDay(key);
    WorkoutPlan? plan;
    if (sessions.isNotEmpty) {
      plan = await getPlanById(sessions.first.planId);
    }
    plan ??= await getPlanCreatedOnDay(key);
    return DayActivitySnapshot(
      date: key,
      dayLog: dayLog,
      sessions: sessions,
      plan: plan,
    );
  }

  Future<int> workoutsThisWeek() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(start.year, start.month, start.day);
    final rows = await (_db.select(_db.workoutSessions)
          ..where(
            (t) =>
                t.completed.equals(true) &
                t.startedAt.isBiggerOrEqualValue(weekStart),
          ))
        .get();
    return rows.length;
  }

  Future<int> setsLoggedToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final sessions = await (_db.select(_db.workoutSessions)
          ..where((t) => t.startedAt.isBiggerOrEqualValue(start)))
        .get();
    if (sessions.isEmpty) return 0;
    var total = 0;
    for (final s in sessions) {
      final logs = await (_db.select(_db.setLogs)
            ..where((t) => t.sessionId.equals(s.id) & t.completed.equals(true)))
          .get();
      total += logs.length;
    }
    return total;
  }

  Future<int> setsLoggedThisWeek() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(start.year, start.month, start.day);
    final sessions = await (_db.select(_db.workoutSessions)
          ..where((t) => t.startedAt.isBiggerOrEqualValue(weekStart)))
        .get();
    if (sessions.isEmpty) return 0;
    var total = 0;
    for (final s in sessions) {
      final logs = await (_db.select(_db.setLogs)
            ..where((t) => t.sessionId.equals(s.id) & t.completed.equals(true)))
          .get();
      total += logs.length;
    }
    return total;
  }

  /// Most recent completed session per muscle group, for recovery advice.
  Future<Map<MuscleGroup, DateTime>> lastTrainedByMuscle({int days = 21}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final rows = await (_db.select(_db.workoutSessions)
          ..where(
            (t) =>
                t.completed.equals(true) &
                t.startedAt.isBiggerOrEqualValue(since),
          ))
        .get();
    final map = <MuscleGroup, DateTime>{};
    for (final row in rows) {
      final at = row.endedAt ?? row.startedAt;
      for (final muscle
          in decodeStringList(row.muscleGroupsJson).map(MuscleGroup.values.byName)) {
        final current = map[muscle];
        if (current == null || at.isAfter(current)) map[muscle] = at;
      }
    }
    return map;
  }

  /// Completed sessions per muscle group since Monday.
  Future<Map<MuscleGroup, int>> sessionsThisWeekByMuscle() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(start.year, start.month, start.day);
    final rows = await (_db.select(_db.workoutSessions)
          ..where(
            (t) =>
                t.completed.equals(true) &
                t.startedAt.isBiggerOrEqualValue(weekStart),
          ))
        .get();
    final counts = <MuscleGroup, int>{};
    for (final row in rows) {
      for (final muscle
          in decodeStringList(row.muscleGroupsJson).map(MuscleGroup.values.byName)) {
        counts[muscle] = (counts[muscle] ?? 0) + 1;
      }
    }
    return counts;
  }

  WorkoutPlan _mapPlan(WorkoutPlanRow row) {
    final list = jsonDecode(row.exercisesJson) as List<dynamic>;
    MealSuggestion? parseMeal(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      try {
        return MealSuggestion.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {
        return null;
      }
    }

    return WorkoutPlan(
      id: row.id,
      checkInId: row.checkInId,
      createdAt: row.createdAt,
      exercises: list
          .map((e) => PlannedExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      encouragement: row.encouragement,
      preMeal: parseMeal(row.preMealJson),
      postMeal: parseMeal(row.postMealJson),
      gymMinutes: row.gymMinutes,
      exerciseCountOverride: row.exerciseCountOverride,
    );
  }

  WorkoutSession _mapSession(
    WorkoutSessionRow row,
    List<SetLogRow> logs,
  ) {
    return WorkoutSession(
      id: row.id,
      planId: row.planId,
      startedAt: row.startedAt,
      endedAt: row.endedAt,
      completed: row.completed,
      muscleGroups: decodeStringList(row.muscleGroupsJson)
          .map(MuscleGroup.values.byName)
          .toList(),
      setLogs: logs
          .map(
            (l) => SetLog(
              id: l.id,
              sessionId: l.sessionId,
              exerciseId: l.exerciseId,
              setNumber: l.setNumber,
              repsCompleted: l.repsCompleted,
              weightKg: l.weightKg,
              rpe: l.rpe,
              completed: l.completed,
              durationSeconds: l.durationSeconds,
            ),
          )
          .toList(),
    );
  }
}
