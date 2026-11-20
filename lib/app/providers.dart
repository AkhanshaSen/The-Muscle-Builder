import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/cloud_sync_port.dart';
import '../../data/repositories/guides_repository.dart';
import '../../data/repositories/custom_food_repository.dart';
import '../../data/repositories/meal_log_repository.dart';
import '../../data/repositories/metrics_repository.dart';
import '../../data/repositories/nutrition_repository.dart';
import '../../data/repositories/custom_routine_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/routine_repository.dart';
import '../../data/repositories/seed_repository.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/services/backup_service.dart';
import '../../domain/engines/exercise_catalog.dart';
import '../../domain/engines/muscle_recovery.dart';
import '../../domain/engines/routine_engine.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final cloudSyncProvider = Provider<CloudSyncPort>((ref) => NoOpCloudSync());

/// Null when `SUPABASE_ANON_KEY` was not provided at build/run time.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (!AppConstants.hasSupabaseKey) return null;
  return Supabase.instance.client;
});

final seedRepositoryProvider = Provider<SeedRepository>((ref) {
  return SeedRepository(ref.watch(supabaseClientProvider));
});

final guidesRepositoryProvider = Provider<GuidesRepository>((ref) {
  return GuidesRepository(ref.watch(supabaseClientProvider));
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

final customRoutineRepositoryProvider = Provider<CustomRoutineRepository>((ref) {
  return CustomRoutineRepository(ref.watch(databaseProvider));
});

final mealLogRepositoryProvider = Provider<MealLogRepository>((ref) {
  return MealLogRepository(ref.watch(databaseProvider));
});

final customFoodRepositoryProvider = Provider<CustomFoodRepository>((ref) {
  return CustomFoodRepository(ref.watch(databaseProvider));
});

final userCustomFoodsProvider = StreamProvider.autoDispose<List<CustomFoodItem>>(
  (ref) => ref.watch(customFoodRepositoryProvider).watchUserFoods(),
);

final recentMealLogsProvider = StreamProvider.autoDispose<List<MealLogEntry>>(
  (ref) => ref.watch(mealLogRepositoryProvider).watchRecent(limit: 8),
);

final todayPreMealLogProvider = FutureProvider.autoDispose<MealLogEntry?>(
  (ref) => ref
      .watch(mealLogRepositoryProvider)
      .todayForTiming(MealLogTiming.preWorkout),
);

class WorkoutCategoryDraft {
  const WorkoutCategoryDraft({required this.categoryId});

  final String categoryId;
}

final workoutCategoryDraftProvider =
    StateProvider<WorkoutCategoryDraft?>((ref) => null);

/// Bumped when saved custom routines change.
final customRoutinesTickProvider = StateProvider<int>((ref) => 0);

final customRoutinesProvider = StreamProvider<List<CustomRoutine>>((ref) {
  ref.watch(customRoutinesTickProvider);
  return ref.watch(customRoutineRepositoryProvider).watchAll();
});

final exercisesProvider = FutureProvider<List<Exercise>>((ref) {
  return ref.watch(seedRepositoryProvider).loadExercises();
});

/// Exercise bank filtered by profile gender (plans and picker use this).
final exercisesForProfileProvider = FutureProvider<List<Exercise>>((ref) async {
  final bank = await ref.watch(exercisesProvider.future);
  final profile = ref.watch(profileProvider).asData?.value;
  return ExerciseCatalog.filterExercises(bank, gender: profile?.gender);
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

/// Per-muscle recovery state driving check-in suggestions.
final muscleRecoveryProvider =
    FutureProvider<Map<MuscleGroup, MuscleStatus>>((ref) async {
  ref.watch(completedSessionsProvider);
  final repo = ref.watch(workoutRepositoryProvider);
  final lastTrained = await repo.lastTrainedByMuscle();
  final sessionsThisWeek = await repo.sessionsThisWeekByMuscle();
  return MuscleRecoveryAdvisor.statuses(
    lastTrained: lastTrained,
    sessionsThisWeek: sessionsThisWeek,
  );
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
    customRoutines: ref.watch(customRoutineRepositoryProvider),
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

/// Combined view of today's plan + day log so screens agree on rest/cheat/skip.
class TodayStatus {
  const TodayStatus({required this.plan, required this.dayLog});

  final WorkoutPlan? plan;
  final DayLog dayLog;

  DayKind? get loggedKind => dayLog.actualKind;

  /// Explicitly logged as a non-training day. A merely *planned* rest day
  /// still shows the plan.
  bool get isRestLogged =>
      dayLog.actualKind != null && dayLog.actualKind != DayKind.gym;
}

final todayStatusProvider = FutureProvider<TodayStatus>((ref) async {
  final plan = await ref.watch(todaysPlanProvider.future);
  final dayLog = await ref.watch(todaysDayLogProvider.future);
  return TodayStatus(plan: plan, dayLog: dayLog);
});

/// "Show me the plan anyway" override, without changing the logged day.
final trainAnywayProvider = StateProvider<bool>((ref) => false);

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

/// Idle fox mascot overlay — off until enabled in Profile → Settings.
class IdleMascotEnabled extends Notifier<bool> {
  static const prefsKey = 'idle_mascot_enabled';

  @override
  bool build() {
    _hydrate();
    return false;
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(prefsKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsKey, value);
  }
}

final idleMascotEnabledProvider =
    NotifierProvider<IdleMascotEnabled, bool>(IdleMascotEnabled.new);

