import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/models.dart';
import '../db/app_database.dart';

class MetricsRepository {
  MetricsRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();
  final _inflightHydration = <DateTime, Future<HydrationLog>>{};

  DateTime dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<HydrationLog> getOrCreateHydration(DateTime date) {
    final key = dayKey(date);
    return _inflightHydration
        .putIfAbsent(key, () => _getOrCreateHydration(key))
        .whenComplete(() => _inflightHydration.remove(key));
  }

  Future<HydrationLog> _getOrCreateHydration(DateTime key) async {
    final existing = await (_db.select(_db.hydrationLogs)
          ..where((t) => t.date.equals(key))
          ..orderBy([
            (t) => OrderingTerm.desc(t.glasses),
            (t) => OrderingTerm.desc(t.updatedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return _mapHydration(existing);

    final id = _uuid.v4();
    final now = DateTime.now();
    try {
      await _db.into(_db.hydrationLogs).insert(
            HydrationLogsCompanion.insert(
              id: id,
              date: key,
              updatedAt: now,
            ),
          );
      return HydrationLog(
        id: id,
        date: key,
        glasses: 0,
        goalGlasses: 8,
        updatedAt: now,
      );
    } catch (_) {
      final again = await (_db.select(_db.hydrationLogs)
            ..where((t) => t.date.equals(key))
            ..orderBy([
              (t) => OrderingTerm.desc(t.glasses),
              (t) => OrderingTerm.desc(t.updatedAt),
            ])
            ..limit(1))
          .getSingleOrNull();
      if (again != null) return _mapHydration(again);
      rethrow;
    }
  }

  Future<HydrationLog> setGlasses(DateTime date, int glasses) async {
    final base = await getOrCreateHydration(date);
    final clamped = glasses.clamp(0, base.goalGlasses + 4);
    final now = DateTime.now();
    await (_db.update(_db.hydrationLogs)..where((t) => t.id.equals(base.id)))
        .write(
      HydrationLogsCompanion(
        glasses: Value(clamped),
        updatedAt: Value(now),
      ),
    );
    return HydrationLog(
      id: base.id,
      date: base.date,
      glasses: clamped,
      goalGlasses: base.goalGlasses,
      updatedAt: now,
    );
  }

  Future<List<HydrationLog>> recentHydration({int days = 7}) async {
    final start = dayKey(DateTime.now()).subtract(Duration(days: days - 1));
    final rows = await (_db.select(_db.hydrationLogs)
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
    return rows.map(_mapHydration).toList();
  }

  Future<BodyMetricLog> logBodyMetric({
    required double weightKg,
    double? waistCm,
    String note = '',
    DateTime? loggedAt,
  }) async {
    final id = _uuid.v4();
    final at = loggedAt ?? DateTime.now();
    await _db.into(_db.bodyMetricLogs).insert(
          BodyMetricLogsCompanion.insert(
            id: id,
            loggedAt: at,
            weightKg: weightKg,
            waistCm: Value(waistCm),
            note: Value(note),
          ),
        );
    return BodyMetricLog(
      id: id,
      loggedAt: at,
      weightKg: weightKg,
      waistCm: waistCm,
      note: note,
    );
  }

  Future<List<BodyMetricLog>> recentBodyMetrics({int limit = 48}) async {
    final rows = await (_db.select(_db.bodyMetricLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(limit))
        .get();
    return rows.map(_mapBody).toList();
  }

  Future<ProgressPhoto> addProgressPhoto({
    required String filePath,
    String note = '',
    DateTime? loggedAt,
  }) async {
    final id = _uuid.v4();
    final at = loggedAt ?? DateTime.now();
    await _db.into(_db.progressPhotos).insert(
          ProgressPhotosCompanion.insert(
            id: id,
            loggedAt: at,
            filePath: filePath,
            note: Value(note),
          ),
        );
    return ProgressPhoto(
      id: id,
      loggedAt: at,
      filePath: filePath,
      note: note,
    );
  }

  Future<List<ProgressPhoto>> recentPhotos({int limit = 40}) async {
    final rows = await (_db.select(_db.progressPhotos)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
          ..limit(limit))
        .get();
    return rows.map(_mapPhoto).toList();
  }

  Future<List<HydrationLog>> getAllHydration() async {
    final rows = await (_db.select(_db.hydrationLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return rows.map(_mapHydration).toList();
  }

  Future<List<BodyMetricLog>> getAllBodyMetrics() async {
    final rows = await (_db.select(_db.bodyMetricLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]))
        .get();
    return rows.map(_mapBody).toList();
  }

  Future<List<ProgressPhoto>> getAllPhotos() async {
    final rows = await (_db.select(_db.progressPhotos)
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]))
        .get();
    return rows.map(_mapPhoto).toList();
  }

  Future<void> upsertHydration(HydrationLog log) async {
    await _db.into(_db.hydrationLogs).insertOnConflictUpdate(
          HydrationLogsCompanion(
            id: Value(log.id),
            date: Value(dayKey(log.date)),
            glasses: Value(log.glasses),
            goalGlasses: Value(log.goalGlasses),
            updatedAt: Value(log.updatedAt),
          ),
        );
  }

  Future<void> upsertBodyMetric(BodyMetricLog log) async {
    await _db.into(_db.bodyMetricLogs).insertOnConflictUpdate(
          BodyMetricLogsCompanion(
            id: Value(log.id),
            loggedAt: Value(log.loggedAt),
            weightKg: Value(log.weightKg),
            waistCm: Value(log.waistCm),
            note: Value(log.note),
          ),
        );
  }

  Future<void> upsertPhoto(ProgressPhoto photo) async {
    await _db.into(_db.progressPhotos).insertOnConflictUpdate(
          ProgressPhotosCompanion(
            id: Value(photo.id),
            loggedAt: Value(photo.loggedAt),
            filePath: Value(photo.filePath),
            note: Value(photo.note),
          ),
        );
  }

  HydrationLog _mapHydration(HydrationLogRow row) => HydrationLog(
        id: row.id,
        date: row.date,
        glasses: row.glasses,
        goalGlasses: row.goalGlasses,
        updatedAt: row.updatedAt,
      );

  BodyMetricLog _mapBody(BodyMetricLogRow row) => BodyMetricLog(
        id: row.id,
        loggedAt: row.loggedAt,
        weightKg: row.weightKg,
        waistCm: row.waistCm,
        note: row.note,
      );

  ProgressPhoto _mapPhoto(ProgressPhotoRow row) => ProgressPhoto(
        id: row.id,
        loggedAt: row.loggedAt,
        filePath: row.filePath,
        note: row.note,
      );
}
