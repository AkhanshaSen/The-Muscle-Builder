import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../repositories/metrics_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/routine_repository.dart';
import '../repositories/workout_repository.dart';

/// Full local JSON backup / restore (offline safety). Not multi-device sync.
class BackupService {
  BackupService({
    required ProfileRepository profiles,
    required WorkoutRepository workouts,
    required RoutineRepository routines,
    required MetricsRepository metrics,
  })  : _profiles = profiles,
        _workouts = workouts,
        _routines = routines,
        _metrics = metrics;

  final ProfileRepository _profiles;
  final WorkoutRepository _workouts;
  final RoutineRepository _routines;
  final MetricsRepository _metrics;

  static const schemaVersion = 9;
  static const formatVersion = 1;

  Future<Map<String, dynamic>> buildExportMap() async {
    final profile = await _profiles.getProfile();
    final checkIns = await _workouts.getAllCheckIns();
    final plans = await _workouts.getAllPlans();
    final sessions = await _workouts.getAllSessions();
    final setLogs = await _workouts.getAllSetLogs();
    final routine = await _routines.getOrCreateWeeklyRoutine();
    final dayLogs = await _routines.getAllDayLogs();
    final hydration = await _metrics.getAllHydration();
    final bodyMetrics = await _metrics.getAllBodyMetrics();
    final photos = await _metrics.getAllPhotos();

    return {
      'formatVersion': formatVersion,
      'schemaVersion': schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'note':
          'Photo files are not embedded — only paths. Re-add photos after import if needed. This is not live multi-device sync.',
      'profile': profile == null ? null : _profileToJson(profile),
      'checkIns': checkIns.map(_checkInToJson).toList(),
      'plans': plans.map(_planToJson).toList(),
      'sessions': sessions.map(_sessionToJson).toList(),
      'setLogs': setLogs.map(_setLogToJson).toList(),
      'weeklyRoutine': _routineToJson(routine),
      'dayLogs': dayLogs.map(_dayLogToJson).toList(),
      'hydration': hydration.map(_hydrationToJson).toList(),
      'bodyMetrics': bodyMetrics.map(_bodyToJson).toList(),
      'progressPhotos': photos.map(_photoToJson).toList(),
    };
  }

  Future<String> exportToFile() async {
    final data = await buildExportMap();
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(dir.path, 'muscle_builder_backup_$stamp.json'));
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    return file.path;
  }

  Future<void> shareExport() async {
    final path = await exportToFile();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path)],
        text: 'The Muscle Builder backup',
      ),
    );
  }

  Future<String?> pickImportFile() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (files.isEmpty) return null;
    final bytes = await files.first.readAsBytes();
    return utf8.decode(bytes);
  }

  /// Merge by id; prefer incoming when timestamps are newer (or missing).
  Future<int> importFromJsonString(String raw) async {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup must be a JSON object');
    }
    var count = 0;

    final profileJson = decoded['profile'];
    if (profileJson is Map<String, dynamic>) {
      await _profiles.saveProfile(_profileFromJson(profileJson));
      count++;
    }

    final routineJson = decoded['weeklyRoutine'];
    if (routineJson is Map<String, dynamic>) {
      await _routines.upsertWeeklyRoutine(_routineFromJson(routineJson));
      count++;
    }

    for (final item in _asList(decoded['checkIns'])) {
      await _workouts.upsertCheckInRaw(_checkInFromJson(item));
      count++;
    }
    for (final item in _asList(decoded['plans'])) {
      await _workouts.upsertPlanRaw(_planFromJson(item));
      count++;
    }
    for (final item in _asList(decoded['sessions'])) {
      await _workouts.upsertSessionRaw(_sessionFromJson(item));
      count++;
    }
    // Standalone set logs (sessions already include nested logs when present)
    for (final item in _asList(decoded['setLogs'])) {
      await _workouts.logSet(_setLogFromJson(item));
      count++;
    }
    for (final item in _asList(decoded['dayLogs'])) {
      await _routines.upsertDayLog(_dayLogFromJson(item));
      count++;
    }
    for (final item in _asList(decoded['hydration'])) {
      await _metrics.upsertHydration(_hydrationFromJson(item));
      count++;
    }
    for (final item in _asList(decoded['bodyMetrics'])) {
      await _metrics.upsertBodyMetric(_bodyFromJson(item));
      count++;
    }
    for (final item in _asList(decoded['progressPhotos'])) {
      await _metrics.upsertPhoto(_photoFromJson(item));
      count++;
    }
    return count;
  }

  List<Map<String, dynamic>> _asList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Map<String, dynamic> _profileToJson(UserProfile p) => {
        'id': p.id,
        'name': p.name,
        'journeyName': p.journeyName,
        'weightKg': p.weightKg,
        'heightCm': p.heightCm,
        'age': p.age,
        'gender': p.gender.name,
        'activityLevel': p.activityLevel.name,
        'primaryGoal': p.primaryGoal.name,
        'experience': p.experience.name,
        'equipment': p.equipment.map((e) => e.name).toList(),
        'dietType': p.dietType.name,
        'allergies': p.allergies.map((e) => e.name).toList(),
        'themeColorHex': p.themeColorHex,
        'coachTone': p.coachTone.name,
        'themePreference': p.themePreference.name,
        'onboardingComplete': p.onboardingComplete,
        'cuisineRegion': p.cuisineRegion.name,
        'showMacros': p.showMacros,
        'unlockedRecipeIds': p.unlockedRecipeIds,
        'preferredIngredients': p.preferredIngredients,
        'fitnessWhy': p.fitnessWhy,
        'aspiration': p.aspiration,
        'targetWeightKg': p.targetWeightKg,
        'weeklyTrainingDays': p.weeklyTrainingDays,
      };

  UserProfile _profileFromJson(Map<String, dynamic> j) => UserProfile(
        id: j['id'] as String,
        name: j['name'] as String? ?? '',
        journeyName: j['journeyName'] as String? ?? 'My Journey',
        weightKg: (j['weightKg'] as num?)?.toDouble() ?? 70,
        heightCm: (j['heightCm'] as num?)?.toDouble() ?? 170,
        age: j['age'] as int? ?? 25,
        gender: Gender.values.byName(j['gender'] as String? ?? 'preferNotToSay'),
        activityLevel: ActivityLevel.values
            .byName(j['activityLevel'] as String? ?? 'moderatelyActive'),
        primaryGoal:
            PrimaryGoal.values.byName(j['primaryGoal'] as String? ?? 'consistency'),
        experience:
            ExperienceLevel.values.byName(j['experience'] as String? ?? 'beginner'),
        equipment: ((j['equipment'] as List?) ?? const [])
            .map((e) => Equipment.values.byName('$e'))
            .toList(),
        dietType: DietType.values.byName(j['dietType'] as String? ?? 'vegetarian'),
        allergies: ((j['allergies'] as List?) ?? const [])
            .map((e) => Allergy.values.byName('$e'))
            .toList(),
        themeColorHex: j['themeColorHex'] as String? ?? '#FF6B35',
        coachTone: CoachTone.values.byName(j['coachTone'] as String? ?? 'friendly'),
        themePreference: ThemePreference.values
            .byName(j['themePreference'] as String? ?? 'dark'),
        onboardingComplete: j['onboardingComplete'] as bool? ?? true,
        cuisineRegion:
            CuisineRegion.values.byName(j['cuisineRegion'] as String? ?? 'panIndian'),
        showMacros: j['showMacros'] as bool? ?? false,
        unlockedRecipeIds:
            ((j['unlockedRecipeIds'] as List?) ?? const []).map((e) => '$e').toList(),
        preferredIngredients: ((j['preferredIngredients'] as List?) ?? const [])
            .map((e) => '$e')
            .toList(),
        fitnessWhy: j['fitnessWhy'] as String? ?? '',
        aspiration: j['aspiration'] as String? ?? '',
        targetWeightKg: (j['targetWeightKg'] as num?)?.toDouble(),
        weeklyTrainingDays: j['weeklyTrainingDays'] as int? ?? 4,
      );

  Map<String, dynamic> _checkInToJson(DailyCheckIn c) => {
        'id': c.id,
        'date': c.date.toIso8601String(),
        'mood': c.mood.name,
        'intensity': c.intensity.name,
        'selectedMuscles': c.selectedMuscles.map((e) => e.name).toList(),
        'surpriseMe': c.surpriseMe,
        'focus': c.focus.name,
        'soreness': c.soreness.name,
        'avoidMuscles': c.avoidMuscles.map((e) => e.name).toList(),
        'equipmentOverride':
            c.equipmentOverride?.map((e) => e.name).toList(),
      };

  DailyCheckIn _checkInFromJson(Map<String, dynamic> j) => DailyCheckIn(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        mood: Mood.values.byName(j['mood'] as String),
        intensity: Intensity.values.byName(j['intensity'] as String),
        selectedMuscles: ((j['selectedMuscles'] as List?) ?? const [])
            .map((e) => MuscleGroup.values.byName('$e'))
            .toList(),
        surpriseMe: j['surpriseMe'] as bool? ?? false,
        focus: TrainingFocus.values.byName(j['focus'] as String? ?? 'hypertrophy'),
        soreness:
            SorenessLevel.values.byName(j['soreness'] as String? ?? 'none'),
        avoidMuscles: ((j['avoidMuscles'] as List?) ?? const [])
            .map((e) => MuscleGroup.values.byName('$e'))
            .toList(),
        equipmentOverride: j['equipmentOverride'] == null
            ? null
            : ((j['equipmentOverride'] as List?) ?? const [])
                .map((e) => Equipment.values.byName('$e'))
                .toList(),
      );

  Map<String, dynamic> _planToJson(WorkoutPlan p) => {
        'id': p.id,
        'checkInId': p.checkInId,
        'createdAt': p.createdAt.toIso8601String(),
        'exercises': p.exercises.map((e) => e.toJson()).toList(),
        'encouragement': p.encouragement,
        'preMeal': p.preMeal?.toJson(),
        'postMeal': p.postMeal?.toJson(),
        'gymMinutes': p.gymMinutes,
      };

  WorkoutPlan _planFromJson(Map<String, dynamic> j) => WorkoutPlan(
        id: j['id'] as String,
        checkInId: j['checkInId'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        exercises: ((j['exercises'] as List?) ?? const [])
            .map((e) => PlannedExercise.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        encouragement: j['encouragement'] as String? ?? '',
        preMeal: j['preMeal'] is Map
            ? MealSuggestion.fromJson(Map<String, dynamic>.from(j['preMeal'] as Map))
            : null,
        postMeal: j['postMeal'] is Map
            ? MealSuggestion.fromJson(Map<String, dynamic>.from(j['postMeal'] as Map))
            : null,
        gymMinutes: j['gymMinutes'] as int? ?? 45,
      );

  Map<String, dynamic> _sessionToJson(WorkoutSession s) => {
        'id': s.id,
        'planId': s.planId,
        'startedAt': s.startedAt.toIso8601String(),
        'endedAt': s.endedAt?.toIso8601String(),
        'completed': s.completed,
        'muscleGroups': s.muscleGroups.map((e) => e.name).toList(),
        'setLogs': s.setLogs.map(_setLogToJson).toList(),
      };

  WorkoutSession _sessionFromJson(Map<String, dynamic> j) => WorkoutSession(
        id: j['id'] as String,
        planId: j['planId'] as String,
        startedAt: DateTime.parse(j['startedAt'] as String),
        endedAt: j['endedAt'] == null
            ? null
            : DateTime.parse(j['endedAt'] as String),
        completed: j['completed'] as bool? ?? false,
        muscleGroups: ((j['muscleGroups'] as List?) ?? const [])
            .map((e) => MuscleGroup.values.byName('$e'))
            .toList(),
        setLogs: ((j['setLogs'] as List?) ?? const [])
            .map((e) => _setLogFromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  Map<String, dynamic> _setLogToJson(SetLog l) => {
        'id': l.id,
        'sessionId': l.sessionId,
        'exerciseId': l.exerciseId,
        'setNumber': l.setNumber,
        'repsCompleted': l.repsCompleted,
        'weightKg': l.weightKg,
        'rpe': l.rpe,
        'completed': l.completed,
        'durationSeconds': l.durationSeconds,
      };

  SetLog _setLogFromJson(Map<String, dynamic> j) => SetLog(
        id: j['id'] as String,
        sessionId: j['sessionId'] as String,
        exerciseId: j['exerciseId'] as String,
        setNumber: j['setNumber'] as int,
        repsCompleted: j['repsCompleted'] as int,
        weightKg: (j['weightKg'] as num).toDouble(),
        rpe: j['rpe'] as int,
        completed: j['completed'] as bool? ?? true,
        durationSeconds: j['durationSeconds'] as int? ?? 0,
      );

  Map<String, dynamic> _routineToJson(WeeklyRoutine r) => {
        'id': r.id,
        'days': {
          for (final e in r.days.entries) '${e.key}': e.value.name,
        },
        'updatedAt': r.updatedAt.toIso8601String(),
        'deloadUntil': r.deloadUntil?.toIso8601String(),
      };

  WeeklyRoutine _routineFromJson(Map<String, dynamic> j) {
    final daysRaw = j['days'];
    final days = <int, DayKind>{};
    if (daysRaw is Map) {
      for (final e in daysRaw.entries) {
        days[int.parse('${e.key}')] = DayKind.values.byName('${e.value}');
      }
    }
    return WeeklyRoutine(
      id: j['id'] as String? ?? 'default_weekly',
      days: days.isEmpty ? WeeklyRoutine.defaultDays() : days,
      updatedAt: DateTime.parse(
        j['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      deloadUntil: j['deloadUntil'] == null
          ? null
          : DateTime.parse(j['deloadUntil'] as String),
    );
  }

  Map<String, dynamic> _dayLogToJson(DayLog d) => {
        'id': d.id,
        'date': d.date.toIso8601String(),
        'plannedKind': d.plannedKind.name,
        'actualKind': d.actualKind?.name,
        'note': d.note,
        'updatedAt': d.updatedAt.toIso8601String(),
      };

  DayLog _dayLogFromJson(Map<String, dynamic> j) => DayLog(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        plannedKind: DayKind.values.byName(j['plannedKind'] as String),
        actualKind: j['actualKind'] == null
            ? null
            : DayKind.values.byName(j['actualKind'] as String),
        note: j['note'] as String? ?? '',
        updatedAt: DateTime.parse(j['updatedAt'] as String),
      );

  Map<String, dynamic> _hydrationToJson(HydrationLog h) => {
        'id': h.id,
        'date': h.date.toIso8601String(),
        'glasses': h.glasses,
        'goalGlasses': h.goalGlasses,
        'updatedAt': h.updatedAt.toIso8601String(),
      };

  HydrationLog _hydrationFromJson(Map<String, dynamic> j) => HydrationLog(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        glasses: j['glasses'] as int? ?? 0,
        goalGlasses: j['goalGlasses'] as int? ?? 8,
        updatedAt: DateTime.parse(j['updatedAt'] as String),
      );

  Map<String, dynamic> _bodyToJson(BodyMetricLog b) => {
        'id': b.id,
        'loggedAt': b.loggedAt.toIso8601String(),
        'weightKg': b.weightKg,
        'waistCm': b.waistCm,
        'note': b.note,
      };

  BodyMetricLog _bodyFromJson(Map<String, dynamic> j) => BodyMetricLog(
        id: j['id'] as String,
        loggedAt: DateTime.parse(j['loggedAt'] as String),
        weightKg: (j['weightKg'] as num).toDouble(),
        waistCm: (j['waistCm'] as num?)?.toDouble(),
        note: j['note'] as String? ?? '',
      );

  Map<String, dynamic> _photoToJson(ProgressPhoto p) => {
        'id': p.id,
        'loggedAt': p.loggedAt.toIso8601String(),
        'filePath': p.filePath,
        'note': p.note,
      };

  ProgressPhoto _photoFromJson(Map<String, dynamic> j) => ProgressPhoto(
        id: j['id'] as String,
        loggedAt: DateTime.parse(j['loggedAt'] as String),
        filePath: j['filePath'] as String,
        note: j['note'] as String? ?? '',
      );
}
