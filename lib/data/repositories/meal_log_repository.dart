import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/models.dart';
import '../db/app_database.dart';

class MealLogRepository {
  MealLogRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  Stream<List<MealLogEntry>> watchRecent({int limit = 30}) {
    final q = _db.select(_db.mealLogEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.eatenAt)])
      ..limit(limit);
    return q.watch().map((rows) => rows.map(_map).toList());
  }

  Future<MealLogEntry?> todayForTiming(MealLogTiming timing) async {
    final start = DateTime.now();
    final dayStart = DateTime(start.year, start.month, start.day);
    final rows = await (_db.select(_db.mealLogEntries)
          ..where((t) => t.mealTiming.equals(timing.name))
          ..where((t) => t.eatenAt.isBiggerOrEqualValue(dayStart))
          ..orderBy([(t) => OrderingTerm.desc(t.eatenAt)])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : _map(rows.first);
  }

  Future<MealLogEntry> insert({
    required DateTime eatenAt,
    required MealLogTiming timing,
    required List<MealLogLineItem> items,
    String notes = '',
  }) async {
    final entry = MealLogEntry(
      id: _uuid.v4(),
      eatenAt: eatenAt,
      timing: timing,
      items: items,
      notes: notes,
    );
    await _db.into(_db.mealLogEntries).insert(
          MealLogEntriesCompanion.insert(
            id: entry.id,
            eatenAt: entry.eatenAt,
            mealTiming: entry.timing.name,
            itemsJson: jsonEncode(items.map((e) => e.toJson()).toList()),
            notes: Value(entry.notes),
          ),
        );
    return entry;
  }

  MealLogEntry _map(MealLogEntryRow row) {
    final raw = jsonDecode(row.itemsJson) as List<dynamic>;
    return MealLogEntry(
      id: row.id,
      eatenAt: row.eatenAt,
      timing: MealLogTiming.fromStored(row.mealTiming),
      items: raw
          .map((e) => MealLogLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: row.notes,
    );
  }
}