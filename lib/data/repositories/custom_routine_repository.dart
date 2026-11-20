import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/models.dart';
import '../db/app_database.dart';

class CustomRoutineRepository {
  CustomRoutineRepository(this._db);

  final AppDatabase _db;

  Stream<List<CustomRoutine>> watchAll() {
    return (_db.select(_db.customRoutines)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  Future<List<CustomRoutine>> getAll() async {
    final rows = await (_db.select(_db.customRoutines)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_map).toList();
  }

  Future<CustomRoutine?> getById(String id) async {
    final row = await (_db.select(_db.customRoutines)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<CustomRoutine> upsert(CustomRoutine routine) async {
    await _db.into(_db.customRoutines).insertOnConflictUpdate(
          CustomRoutinesCompanion(
            id: Value(routine.id),
            name: Value(routine.name),
            exerciseIdsJson: Value(jsonEncode(routine.exerciseIds)),
            updatedAt: Value(routine.updatedAt),
          ),
        );
    return routine;
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.customRoutines)..where((t) => t.id.equals(id))).go();
  }

  Future<void> upsertAll(List<CustomRoutine> routines) async {
    await _db.batch((batch) {
      for (final r in routines) {
        batch.insert(
          _db.customRoutines,
          CustomRoutinesCompanion(
            id: Value(r.id),
            name: Value(r.name),
            exerciseIdsJson: Value(jsonEncode(r.exerciseIds)),
            updatedAt: Value(r.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  CustomRoutine _map(CustomRoutineRow row) {
    final ids = jsonDecode(row.exerciseIdsJson) as List;
    return CustomRoutine(
      id: row.id,
      name: row.name,
      exerciseIds: ids.cast<String>(),
      updatedAt: row.updatedAt,
    );
  }
}