import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/data/db/app_database.dart';
import 'package:the_muscle_builder/data/repositories/metrics_repository.dart';
import 'package:the_muscle_builder/data/repositories/routine_repository.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('concurrent ensureDayLog inserts exactly one row for today', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final routines = RoutineRepository(db);
    final today = DateTime.now();

    final results = await Future.wait(
      List.generate(20, (_) => routines.ensureDayLog(today)),
    );

    expect(results.every((r) => r.id == results.first.id), isTrue);

    final rows = await (db.select(db.dayLogs)
          ..where((t) => t.date.equals(routines.dayKey(today))))
        .get();
    expect(rows.length, 1);
  });

  test('logDay Skip is visible via ensureDayLog, weekLogs and recentLogs',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final routines = RoutineRepository(db);
    final today = DateTime.now();

    await Future.wait([
      routines.ensureDayLog(today),
      routines.ensureDayLog(today),
      routines.ensureDayLog(today),
    ]);

    await routines.logDay(date: today, actual: DayKind.skip, note: 'Holiday');

    final again = await routines.ensureDayLog(today);
    expect(again.actualKind, DayKind.skip);

    final week = await routines.weekLogs(today);
    final todayLog = week.firstWhere(
      (d) => routines.dayKey(d.date) == routines.dayKey(today),
    );
    expect(todayLog.actualKind, DayKind.skip);

    final recent = await routines.recentLogs(days: 7);
    expect(
      recent.any(
        (d) =>
            routines.dayKey(d.date) == routines.dayKey(today) &&
            d.actualKind == DayKind.skip,
      ),
      isTrue,
    );

    final rows = await (db.select(db.dayLogs)
          ..where((t) => t.date.equals(routines.dayKey(today))))
        .get();
    expect(rows.length, 1);
  });

  test('concurrent getOrCreateHydration inserts exactly one row', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final metrics = MetricsRepository(db);
    final today = DateTime.now();

    final results = await Future.wait(
      List.generate(20, (_) => metrics.getOrCreateHydration(today)),
    );
    expect(results.every((r) => r.id == results.first.id), isTrue);

    await metrics.setGlasses(today, 3);
    final again = await metrics.getOrCreateHydration(today);
    expect(again.glasses, 3);

    final rows = await (db.select(db.hydrationLogs)
          ..where((t) => t.date.equals(metrics.dayKey(today))))
        .get();
    expect(rows.length, 1);
  });
}
