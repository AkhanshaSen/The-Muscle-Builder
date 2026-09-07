import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../db/app_database.dart';

class RoutineRepository {
  RoutineRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();
  static const _routineId = 'default_weekly';

  DateTime dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime weekStart(DateTime d) {
    final key = dayKey(d);
    return key.subtract(Duration(days: key.weekday - DateTime.monday));
  }

  Future<WeeklyRoutine> getOrCreateWeeklyRoutine() async {
    final row = await (_db.select(_db.weeklyRoutines)
          ..where((t) => t.id.equals(_routineId)))
        .getSingleOrNull();
    if (row != null) return _mapRoutine(row);

    final now = DateTime.now();
    final days = WeeklyRoutine.defaultDays();
    await _db.into(_db.weeklyRoutines).insert(
          WeeklyRoutinesCompanion.insert(
            id: _routineId,
            daysJson: _encodeDays(days),
            updatedAt: now,
          ),
        );
    return WeeklyRoutine(id: _routineId, days: days, updatedAt: now);
  }

  Stream<WeeklyRoutine> watchWeeklyRoutine() async* {
    yield await getOrCreateWeeklyRoutine();
    yield* (_db.select(_db.weeklyRoutines)
          ..where((t) => t.id.equals(_routineId)))
        .watch()
        .map((rows) {
      if (rows.isEmpty) {
        return WeeklyRoutine(
          id: _routineId,
          days: WeeklyRoutine.defaultDays(),
          updatedAt: DateTime.now(),
        );
      }
      return _mapRoutine(rows.first);
    });
  }

  Future<WeeklyRoutine> saveWeeklyRoutine(
    Map<int, DayKind> days, {
    DateTime? deloadUntil,
    bool clearDeload = false,
  }) async {
    final existing = await getOrCreateWeeklyRoutine();
    final now = DateTime.now();
    final nextDeload = clearDeload
        ? null
        : (deloadUntil ?? existing.deloadUntil);
    await _db.into(_db.weeklyRoutines).insertOnConflictUpdate(
          WeeklyRoutinesCompanion(
            id: Value(_routineId),
            daysJson: Value(_encodeDays(days)),
            updatedAt: Value(now),
            deloadUntil: Value(nextDeload),
          ),
        );
    return WeeklyRoutine(
      id: _routineId,
      days: days,
      updatedAt: now,
      deloadUntil: nextDeload,
    );
  }

  Future<WeeklyRoutine> setDeload({required bool enabled}) async {
    final routine = await getOrCreateWeeklyRoutine();
    final until =
        enabled ? DateTime.now().add(const Duration(days: 7)) : null;
    return saveWeeklyRoutine(
      routine.days,
      deloadUntil: until,
      clearDeload: !enabled,
    );
  }

  Future<DayLog> ensureDayLog(DateTime date) async {
    final key = dayKey(date);
    final existing = await _findByDate(key);
    if (existing != null) return existing;

    final routine = await getOrCreateWeeklyRoutine();
    final planned = routine.kindFor(key);
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.into(_db.dayLogs).insert(
          DayLogsCompanion.insert(
            id: id,
            date: key,
            plannedKind: planned.name,
            updatedAt: now,
          ),
        );
    return DayLog(
      id: id,
      date: key,
      plannedKind: planned,
      updatedAt: now,
    );
  }

  Future<DayLog> logDay({
    required DateTime date,
    required DayKind actual,
    String note = '',
  }) async {
    final base = await ensureDayLog(date);
    final now = DateTime.now();
    await (_db.update(_db.dayLogs)..where((t) => t.id.equals(base.id))).write(
      DayLogsCompanion(
        actualKind: Value(actual.name),
        note: Value(note),
        updatedAt: Value(now),
      ),
    );
    return DayLog(
      id: base.id,
      date: base.date,
      plannedKind: base.plannedKind,
      actualKind: actual,
      note: note,
      updatedAt: now,
    );
  }

  /// Marks today as a gym day when a session is completed.
  Future<void> markGymCompletedToday() async {
    await logDay(date: DateTime.now(), actual: DayKind.gym, note: 'Session done');
  }

  Future<List<DayLog>> recentLogs({int days = 42}) async {
    final start = dayKey(DateTime.now()).subtract(Duration(days: days - 1));
    final rows = await (_db.select(_db.dayLogs)
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return rows.map(_mapLog).toList();
  }

  Stream<List<DayLog>> watchRecentLogs({int days = 42}) {
    final start = dayKey(DateTime.now()).subtract(Duration(days: days - 1));
    return (_db.select(_db.dayLogs)
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map(_mapLog).toList());
  }

  Future<List<DayLog>> weekLogs(DateTime anyDayInWeek) async {
    final start = weekStart(anyDayInWeek);
    final logs = <DayLog>[];
    for (var i = 0; i < 7; i++) {
      logs.add(await ensureDayLog(start.add(Duration(days: i))));
    }
    return logs;
  }

  Future<RoutineAnalysis> analyzeLastWeeks({int weeks = 4}) async {
    final today = dayKey(DateTime.now());
    final start = weekStart(today).subtract(Duration(days: 7 * (weeks - 1)));
    var gym = 0;
    var rest = 0;
    var cheat = 0;
    var plannedGym = 0;
    var hitGym = 0;
    final weeklyGym = List<int>.filled(weeks, 0);

    for (var i = 0; i < weeks * 7; i++) {
      final d = start.add(Duration(days: i));
      if (d.isAfter(today)) break;
      final log = await ensureDayLog(d);
      final effective = log.effectiveKind;
      switch (effective) {
        case DayKind.gym:
          gym++;
          break;
        case DayKind.rest:
          rest++;
          break;
        case DayKind.cheat:
          cheat++;
          break;
        case DayKind.skip:
          // Excused day — not counted in day-mix bars.
          break;
      }
      if (log.plannedKind == DayKind.gym) {
        // Skip / holiday excuses a planned gym day (doesn't hurt adherence).
        if (log.actualKind == DayKind.skip) {
          // no-op
        } else {
          plannedGym++;
          if (log.effectiveKind == DayKind.gym && log.isLogged) hitGym++;
        }
      }
      final weekIndex = d.difference(start).inDays ~/ 7;
      if (weekIndex >= 0 &&
          weekIndex < weeks &&
          effective == DayKind.gym &&
          log.isLogged) {
        weeklyGym[weekIndex]++;
      }
    }

    return RoutineAnalysis(
      gymCount: gym,
      restCount: rest,
      cheatCount: cheat,
      plannedGymDays: plannedGym,
      hitGymDays: hitGym,
      weeklyGymCounts: weeklyGym,
    );
  }

  WeeklyRoutine _mapRoutine(WeeklyRoutineRow row) {
    return WeeklyRoutine(
      id: row.id,
      days: _decodeDays(row.daysJson),
      updatedAt: row.updatedAt,
      deloadUntil: row.deloadUntil,
    );
  }

  Future<List<DayLog>> getAllDayLogs() async {
    final rows = await (_db.select(_db.dayLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return rows.map(_mapLog).toList();
  }

  Future<void> upsertDayLog(DayLog log) async {
    await _db.into(_db.dayLogs).insertOnConflictUpdate(
          DayLogsCompanion(
            id: Value(log.id),
            date: Value(dayKey(log.date)),
            plannedKind: Value(log.plannedKind.name),
            actualKind: Value(log.actualKind?.name),
            note: Value(log.note),
            updatedAt: Value(log.updatedAt),
          ),
        );
  }

  Future<void> upsertWeeklyRoutine(WeeklyRoutine routine) async {
    await _db.into(_db.weeklyRoutines).insertOnConflictUpdate(
          WeeklyRoutinesCompanion(
            id: Value(routine.id),
            daysJson: Value(_encodeDays(routine.days)),
            updatedAt: Value(routine.updatedAt),
            deloadUntil: Value(routine.deloadUntil),
          ),
        );
  }

  DayLog _mapLog(DayLogRow row) {
    return DayLog(
      id: row.id,
      date: row.date,
      plannedKind: DayKind.values.byName(row.plannedKind),
      actualKind: row.actualKind == null
          ? null
          : DayKind.values.byName(row.actualKind!),
      note: row.note,
      updatedAt: row.updatedAt,
    );
  }

  Future<DayLog?> _findByDate(DateTime key) async {
    final rows = await (_db.select(_db.dayLogs)
          ..where((t) => t.date.equals(key)))
        .get();
    if (rows.isEmpty) return null;
    return _mapLog(rows.first);
  }

  String _encodeDays(Map<int, DayKind> days) {
    final map = <String, String>{
      for (final e in days.entries) '${e.key}': e.value.name,
    };
    return jsonEncode(map);
  }

  Map<int, DayKind> _decodeDays(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return WeeklyRoutine.defaultDays();
    final out = <int, DayKind>{};
    decoded.forEach((k, v) {
      final day = int.tryParse(k.toString());
      if (day == null) return;
      out[day] = DayKind.values.byName(v.toString());
    });
    for (var d = 1; d <= 7; d++) {
      out.putIfAbsent(d, () => DayKind.rest);
    }
    return out;
  }
}
