import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('UserProfileRow')
class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get journeyName => text()();
  RealColumn get weightKg => real()();
  RealColumn get heightCm => real()();
  IntColumn get age => integer()();
  TextColumn get gender => text()();
  TextColumn get activityLevel => text()();
  TextColumn get primaryGoal => text()();
  TextColumn get experience => text()();
  TextColumn get equipmentJson => text()();
  TextColumn get dietType => text()();
  TextColumn get allergiesJson => text()();
  TextColumn get themeColorHex => text()();
  TextColumn get coachTone => text()();
  TextColumn get themePreference => text()();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  TextColumn get cuisineRegion =>
      text().withDefault(const Constant('panIndian'))();
  BoolColumn get showMacros => boolean().withDefault(const Constant(false))();
  TextColumn get unlockedRecipesJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get preferredIngredientsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get fitnessWhy => text().withDefault(const Constant(''))();
  TextColumn get aspiration => text().withDefault(const Constant(''))();
  RealColumn get targetWeightKg => real().nullable()();
  IntColumn get weeklyTrainingDays =>
      integer().withDefault(const Constant(4))();
  DateTimeColumn get birthday => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DailyCheckInRow')
class DailyCheckIns extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get mood => text()();
  TextColumn get intensity => text()();
  TextColumn get selectedMusclesJson => text()();
  BoolColumn get surpriseMe => boolean().withDefault(const Constant(false))();
  TextColumn get focus => text().withDefault(const Constant('hypertrophy'))();
  TextColumn get soreness => text().withDefault(const Constant('none'))();
  TextColumn get avoidMusclesJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get equipmentOverrideJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutPlanRow')
class WorkoutPlans extends Table {
  TextColumn get id => text()();
  TextColumn get checkInId => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get exercisesJson => text()();
  TextColumn get encouragement => text()();
  TextColumn get preMealJson => text().nullable()();
  TextColumn get postMealJson => text().nullable()();
  IntColumn get gymMinutes => integer().withDefault(const Constant(45))();
  IntColumn get exerciseCountOverride => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutSessionRow')
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get muscleGroupsJson =>
      text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SetLogRow')
class SetLogs extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get exerciseId => text()();
  IntColumn get setNumber => integer()();
  IntColumn get repsCompleted => integer()();
  RealColumn get weightKg => real()();
  IntColumn get rpe => integer()();
  BoolColumn get completed => boolean().withDefault(const Constant(true))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WeeklyRoutineRow')
class WeeklyRoutines extends Table {
  TextColumn get id => text()();
  TextColumn get daysJson => text()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deloadUntil => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DayLogRow')
class DayLogs extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get plannedKind => text()();
  TextColumn get actualKind => text().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HydrationLogRow')
class HydrationLogs extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get glasses => integer().withDefault(const Constant(0))();
  IntColumn get goalGlasses => integer().withDefault(const Constant(8))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BodyMetricLogRow')
class BodyMetricLogs extends Table {
  TextColumn get id => text()();
  DateTimeColumn get loggedAt => dateTime()();
  RealColumn get weightKg => real()();
  RealColumn get waistCm => real().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProgressPhotoRow')
class ProgressPhotos extends Table {
  TextColumn get id => text()();
  DateTimeColumn get loggedAt => dateTime()();
  TextColumn get filePath => text()();
  TextColumn get note => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    UserProfiles,
    DailyCheckIns,
    WorkoutPlans,
    WorkoutSessions,
    SetLogs,
    WeeklyRoutines,
    DayLogs,
    HydrationLogs,
    BodyMetricLogs,
    ProgressPhotos,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await m.database.customStatement(
            'CREATE UNIQUE INDEX IF NOT EXISTS day_logs_date_unique ON day_logs(date)',
          );
          await m.database.customStatement(
            'CREATE UNIQUE INDEX IF NOT EXISTS hydration_logs_date_unique ON hydration_logs(date)',
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(userProfiles, userProfiles.unlockedRecipesJson);
          }
          if (from < 3) {
            await m.addColumn(setLogs, setLogs.durationSeconds);
          }
          if (from < 4) {
            await m.addColumn(dailyCheckIns, dailyCheckIns.focus);
          }
          if (from < 5) {
            await m.addColumn(workoutPlans, workoutPlans.preMealJson);
            await m.addColumn(workoutPlans, workoutPlans.postMealJson);
          }
          if (from < 6) {
            await m.addColumn(workoutPlans, workoutPlans.gymMinutes);
          }
          if (from < 7) {
            await m.addColumn(
              userProfiles,
              userProfiles.preferredIngredientsJson,
            );
          }
          if (from < 8) {
            await m.createTable(weeklyRoutines);
            await m.createTable(dayLogs);
          }
          if (from < 9) {
            await m.addColumn(dailyCheckIns, dailyCheckIns.soreness);
            await m.addColumn(dailyCheckIns, dailyCheckIns.avoidMusclesJson);
            await m.addColumn(
              dailyCheckIns,
              dailyCheckIns.equipmentOverrideJson,
            );
            await m.addColumn(weeklyRoutines, weeklyRoutines.deloadUntil);
            await m.createTable(hydrationLogs);
            await m.createTable(bodyMetricLogs);
            await m.createTable(progressPhotos);
          }
          if (from < 10) {
            await m.addColumn(userProfiles, userProfiles.fitnessWhy);
            await m.addColumn(userProfiles, userProfiles.aspiration);
            await m.addColumn(userProfiles, userProfiles.targetWeightKg);
            await m.addColumn(userProfiles, userProfiles.weeklyTrainingDays);
          }
          if (from < 11) {
            await m.addColumn(
              workoutPlans,
              workoutPlans.exerciseCountOverride,
            );
          }
          if (from < 12) {
            // Keep the logged (or latest) row per date, drop blank duplicates.
            await m.database.customStatement('''
DELETE FROM day_logs WHERE id NOT IN (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER (
      PARTITION BY date
      ORDER BY (actual_kind IS NOT NULL) DESC, updated_at DESC
    ) AS rn FROM day_logs
  ) WHERE rn = 1
)
''');
            await m.database.customStatement('''
DELETE FROM hydration_logs WHERE id NOT IN (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER (
      PARTITION BY date
      ORDER BY glasses DESC, updated_at DESC
    ) AS rn FROM hydration_logs
  ) WHERE rn = 1
)
''');
            await m.database.customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS day_logs_date_unique ON day_logs(date)',
            );
            await m.database.customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS hydration_logs_date_unique ON hydration_logs(date)',
            );
          }
          if (from < 13) {
            await m.addColumn(userProfiles, userProfiles.birthday);
          }
          if (from < 14) {
            // Self-heal installs that skipped v13 (hot restart / partial migrate).
            await _ensureBirthdayColumn(m.database);
          }
        },
        beforeOpen: (details) async {
          // Always verify — theme/settings saves fail hard without this column.
          await _ensureBirthdayColumn(this);
        },
      );

  /// Adds [user_profiles.birthday] if an older DB is missing it.
  static Future<void> _ensureBirthdayColumn(GeneratedDatabase db) async {
    final rows = await db.customSelect("PRAGMA table_info('user_profiles')").get();
    final cols = <String>{
      for (final row in rows) row.read<String>('name'),
    };
    if (!cols.contains('birthday')) {
      await db.customStatement(
        'ALTER TABLE user_profiles ADD COLUMN birthday INTEGER NULL',
      );
    }
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'the_muscle_builder');
  }
}

String encodeStringList(List<String> items) => jsonEncode(items);

List<String> decodeStringList(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is List) {
    return decoded.cast<String>();
  }
  return const [];
}
