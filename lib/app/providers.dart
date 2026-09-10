import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/cloud_sync_port.dart';
import '../../data/repositories/metrics_repository.dart';
import '../../data/repositories/nutrition_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/routine_repository.dart';
import '../../data/repositories/seed_repository.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/services/backup_service.dart';
import '../../domain/engines/routine_engine.dart';
import '../../domain/models/models.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final cloudSyncProvider = Provider<CloudSyncPort>((ref) => NoOpCloudSync());

final seedRepositoryProvider = Provider<SeedRepository>((ref) {
  return SeedRepository();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    ref.watch(databaseProvider),
    ref.watch(cloudSyncProvider),
  );
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository(
    ref.watch(databaseProvider),
    ref.watch(cloudSyncProvider),
  );
});

final metricsRepositoryProvider = Provider<MetricsRepository>((ref) {
  return MetricsRepository(ref.watch(databaseProvider));
});

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return NutritionRepository(ref.watch(seedRepositoryProvider));
});

final routineEngineProvider = Provider<RoutineEngine>((ref) {
  return RoutineEngine();
});

final exercisesProvider = FutureProvider<List<Exercise>>((ref) {
  return ref.watch(seedRepositoryProvider).loadExercises();
});

final profileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(profileRepositoryProvider).watchProfile();
});

final todaysPlanProvider = FutureProvider<WorkoutPlan?>((ref) async {
  // Re-read when profile updates after onboarding
  ref.watch(profileProvider);
  return ref.watch(workoutRepositoryProvider).getTodaysPlan();
});

final todaysCheckInProvider = FutureProvider<DailyCheckIn?>((ref) async {
  ref.watch(profileProvider);
  return ref.watch(workoutRepositoryProvider).getTodaysCheckIn();
});

final completedSessionsProvider = StreamProvider<List<WorkoutSession>>((ref) {
  return ref.watch(workoutRepositoryProvider).watchCompletedSessions();
});

final workoutsThisWeekProvider = FutureProvider<int>((ref) async {
  ref.watch(completedSessionsProvider);
  return ref.watch(workoutRepositoryProvider).workoutsThisWeek();
});

final setsTodayProvider = FutureProvider<int>((ref) async {
  ref.watch(completedSessionsProvider);
  ref.watch(sessionProgressTickProvider);
  return ref.watch(workoutRepositoryProvider).setsLoggedToday();
});

final setsThisWeekProvider = FutureProvider<int>((ref) async {
  ref.watch(completedSessionsProvider);
  ref.watch(sessionProgressTickProvider);
  return ref.watch(workoutRepositoryProvider).setsLoggedThisWeek();
});

/// Bumped after each logged set so Progress/Home refresh mid-session.
final sessionProgressTickProvider = StateProvider<int>((ref) => 0);

final recentFuelHistoryProvider =
    FutureProvider<List<FuelHistoryEntry>>((ref) async {
  ref.watch(todaysPlanProvider);
  ref.watch(completedSessionsProvider);
  return ref.watch(workoutRepositoryProvider).getRecentFuelHistory();
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(ref.watch(databaseProvider));
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    profiles: ref.watch(profileRepositoryProvider),
    workouts: ref.watch(workoutRepositoryProvider),
    routines: ref.watch(routineRepositoryProvider),
    metrics: ref.watch(metricsRepositoryProvider),
  );
});

final weeklyRoutineProvider = StreamProvider<WeeklyRoutine>((ref) {
  return ref.watch(routineRepositoryProvider).watchWeeklyRoutine();
});

final todaysDayLogProvider = FutureProvider<DayLog>((ref) async {
  ref.watch(weeklyRoutineProvider);
  ref.watch(dayLogsTickProvider);
  return ref.watch(routineRepositoryProvider).ensureDayLog(DateTime.now());
});

final thisWeekDayLogsProvider = FutureProvider<List<DayLog>>((ref) async {
  ref.watch(weeklyRoutineProvider);
  ref.watch(dayLogsTickProvider);
  return ref.watch(routineRepositoryProvider).weekLogs(DateTime.now());
});

final recentDayLogsProvider = StreamProvider<List<DayLog>>((ref) {
  ref.watch(dayLogsTickProvider);
  return ref.watch(routineRepositoryProvider).watchRecentLogs();
});

final routineAnalysisProvider = FutureProvider<RoutineAnalysis>((ref) async {
  ref.watch(dayLogsTickProvider);
  ref.watch(weeklyRoutineProvider);
  return ref.watch(routineRepositoryProvider).analyzeLastWeeks();
});

/// Bumped when the user logs gym / rest / cheat days.
final dayLogsTickProvider = StateProvider<int>((ref) => 0);

/// Bumped when hydration / body metrics / photos change.
final metricsTickProvider = StateProvider<int>((ref) => 0);

final todaysHydrationProvider = FutureProvider<HydrationLog>((ref) async {
  ref.watch(metricsTickProvider);
  return ref
      .watch(metricsRepositoryProvider)
      .getOrCreateHydration(DateTime.now());
});

final recentHydrationProvider = FutureProvider<List<HydrationLog>>((ref) async {
  ref.watch(metricsTickProvider);
  return ref.watch(metricsRepositoryProvider).recentHydration();
});

final recentBodyMetricsProvider =
    FutureProvider<List<BodyMetricLog>>((ref) async {
  ref.watch(metricsTickProvider);
  return ref.watch(metricsRepositoryProvider).recentBodyMetrics();
});

final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

