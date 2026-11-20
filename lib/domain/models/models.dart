import 'enums.dart';

class ExerciseVariant {
  const ExerciseVariant({
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });

  final int sets;
  final int reps;
  final int restSeconds;

  factory ExerciseVariant.fromJson(Map<String, dynamic> json) {
    return ExerciseVariant(
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      restSeconds: json['restSeconds'] as int,
    );
  }
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroups,
    required this.equipment,
    required this.difficulty,
    required this.estimatedCalories,
    required this.formCues,
    required this.commonMistakes,
    required this.variants,
    this.demoUrl,
    this.demoImages = const [],
    this.isCompound = false,
    this.audiences = const [ExerciseAudience.all],
    this.quickSteps = const [],
    this.catalogTags = const [],
    this.demoFrames = const [],
    this.demoVideoUrl,
  });

  final String id;
  final String name;
  final List<MuscleGroup> muscleGroups;
  final List<Equipment> equipment;
  final ExperienceLevel difficulty;
  final int estimatedCalories;
  final List<String> formCues;
  final List<String> commonMistakes;
  final Map<ExperienceLevel, ExerciseVariant> variants;
  final String? demoUrl;
  final List<String> demoImages;
  final bool isCompound;
  final List<ExerciseAudience> audiences;
  final List<String> quickSteps;
  final List<String> catalogTags;
  final List<String> demoFrames;
  final String? demoVideoUrl;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final variantsJson = json['variants'] as Map<String, dynamic>;
    final images = (json['demoImages'] as List?)?.cast<String>() ?? const [];
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      muscleGroups: (json['muscleGroups'] as List)
          .map((e) => MuscleGroup.values.byName(e as String))
          .toList(),
      equipment: (json['equipment'] as List)
          .map((e) => Equipment.values.byName(e as String))
          .toList(),
      difficulty: ExperienceLevel.values.byName(json['difficulty'] as String),
      estimatedCalories: json['estimatedCalories'] as int,
      formCues: (json['formCues'] as List).cast<String>(),
      commonMistakes: (json['commonMistakes'] as List).cast<String>(),
      variants: {
        for (final entry in variantsJson.entries)
          ExperienceLevel.values.byName(entry.key):
              ExerciseVariant.fromJson(entry.value as Map<String, dynamic>),
      },
      demoUrl: json['demoUrl'] as String? ?? (images.isNotEmpty ? images.first : null),
      demoImages: images,
      isCompound: json['isCompound'] as bool? ?? false,
      audiences: (json['audiences'] as List?)
              ?.map((e) => ExerciseAudience.values.byName(e as String))
              .toList() ??
          const [ExerciseAudience.all],
      quickSteps: (json['quickSteps'] as List?)?.cast<String>() ?? const [],
      catalogTags: (json['catalogTags'] as List?)?.cast<String>() ?? const [],
      demoFrames: (json['demoFrames'] as List?)?.cast<String>() ?? const [],
      demoVideoUrl: json['demoVideoUrl'] as String?,
    );
  }
}

class MealRecipe {
  const MealRecipe({
    required this.prepMinutes,
    required this.ingredients,
    required this.steps,
  });

  final int prepMinutes;
  final List<String> ingredients;
  final List<String> steps;

  factory MealRecipe.fromJson(Map<String, dynamic> json) {
    return MealRecipe(
      prepMinutes: json['prepMinutes'] as int? ?? 10,
      ingredients: (json['ingredients'] as List).cast<String>(),
      steps: (json['steps'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'prepMinutes': prepMinutes,
        'ingredients': ingredients,
        'steps': steps,
      };
}

class MealSuggestion {
  const MealSuggestion({
    required this.id,
    required this.name,
    required this.description,
    required this.timing,
    required this.dietTypes,
    required this.regions,
    required this.allergens,
    required this.timingGuidance,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.portion,
    this.recipe,
    this.recipeAvailable = false,
    this.ingredientTags = const [],
    this.nutritionNotes = const [],
  });

  final String id;
  final String name;
  final String description;
  final MealTiming timing;
  final List<DietType> dietTypes;
  final List<CuisineRegion> regions;
  final List<Allergy> allergens;
  final String timingGuidance;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String portion;
  final MealRecipe? recipe;
  /// True when a real recipe exists; false = unlock is UI-only / coming soon.
  final bool recipeAvailable;
  /// Tags matching [MealIngredientChip.name] for Nutrition filters.
  final List<String> ingredientTags;
  /// Evidence-backed nutrient highlights (ICMR-NIN / USDA / EatRight style).
  final List<String> nutritionNotes;

  bool get hasUnlockableRecipe => recipeAvailable && recipe != null;

  factory MealSuggestion.fromJson(Map<String, dynamic> json) {
    final recipeJson = json['recipe'];
    return MealSuggestion(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      timing: MealTiming.values.byName(json['timing'] as String),
      dietTypes: (json['dietTypes'] as List)
          .map((e) => DietType.values.byName(e as String))
          .toList(),
      regions: (json['regions'] as List)
          .map((e) => CuisineRegion.values.byName(e as String))
          .toList(),
      allergens: (json['allergens'] as List)
          .map((e) => Allergy.values.byName(e as String))
          .toList(),
      timingGuidance: json['timingGuidance'] as String,
      calories: json['calories'] as int,
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
      portion: json['portion'] as String? ?? '1 serving',
      recipe: recipeJson is Map<String, dynamic>
          ? MealRecipe.fromJson(recipeJson)
          : null,
      recipeAvailable: json['recipeAvailable'] as bool? ?? false,
      ingredientTags:
          (json['ingredientTags'] as List?)?.cast<String>() ?? const [],
      nutritionNotes:
          (json['nutritionNotes'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'timing': timing.name,
        'dietTypes': dietTypes.map((e) => e.name).toList(),
        'regions': regions.map((e) => e.name).toList(),
        'allergens': allergens.map((e) => e.name).toList(),
        'timingGuidance': timingGuidance,
        'calories': calories,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        'portion': portion,
        if (recipe != null) 'recipe': recipe!.toJson(),
        'recipeAvailable': recipeAvailable,
        'ingredientTags': ingredientTags,
        if (nutritionNotes.isNotEmpty) 'nutritionNotes': nutritionNotes,
      };
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.journeyName,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.primaryGoal,
    required this.experience,
    required this.equipment,
    required this.dietType,
    required this.allergies,
    required this.themeColorHex,
    required this.coachTone,
    required this.themePreference,
    required this.onboardingComplete,
    this.cuisineRegion = CuisineRegion.panIndian,
    this.showMacros = false,
    this.unlockedRecipeIds = const [],
    this.preferredIngredients = const [],
    this.fitnessWhy = '',
    this.aspiration = '',
    this.targetWeightKg,
    this.weeklyTrainingDays = 4,
    this.birthday,
  });

  final String id;
  final String name;
  final String journeyName;
  final double weightKg;
  final double heightCm;
  final int age;
  final Gender gender;
  final ActivityLevel activityLevel;
  final PrimaryGoal primaryGoal;
  final ExperienceLevel experience;
  final List<Equipment> equipment;
  final DietType dietType;
  final List<Allergy> allergies;
  final String themeColorHex;
  final CoachTone coachTone;
  final ThemePreference themePreference;
  final bool onboardingComplete;
  final CuisineRegion cuisineRegion;
  final bool showMacros;
  final List<String> unlockedRecipeIds;
  /// [MealIngredientChip.name] values selected on Nutrition.
  final List<String> preferredIngredients;
  /// Personal “why” — motivation that keeps them training.
  final String fitnessWhy;
  /// Longer-term aspiration (physique, sport, lifestyle).
  final String aspiration;
  final double? targetWeightKg;
  /// Ideal gym / training days per week (1–7).
  final int weeklyTrainingDays;
  /// Optional date of birth — when set, [age] should match it.
  final DateTime? birthday;

  /// Age in whole years from a birthday (clamped 1–120).
  static int ageFromBirthday(DateTime birth, [DateTime? now]) {
    final n = now ?? DateTime.now();
    var years = n.year - birth.year;
    final hadBirthday =
        n.month > birth.month ||
        (n.month == birth.month && n.day >= birth.day);
    if (!hadBirthday) years--;
    if (years < 1) return 1;
    if (years > 120) return 120;
    return years;
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? journeyName,
    double? weightKg,
    double? heightCm,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
    PrimaryGoal? primaryGoal,
    ExperienceLevel? experience,
    List<Equipment>? equipment,
    DietType? dietType,
    List<Allergy>? allergies,
    String? themeColorHex,
    CoachTone? coachTone,
    ThemePreference? themePreference,
    bool? onboardingComplete,
    CuisineRegion? cuisineRegion,
    bool? showMacros,
    List<String>? unlockedRecipeIds,
    List<String>? preferredIngredients,
    String? fitnessWhy,
    String? aspiration,
    double? targetWeightKg,
    bool clearTargetWeight = false,
    int? weeklyTrainingDays,
    DateTime? birthday,
    bool clearBirthday = false,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      journeyName: journeyName ?? this.journeyName,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      experience: experience ?? this.experience,
      equipment: equipment ?? this.equipment,
      dietType: dietType ?? this.dietType,
      allergies: allergies ?? this.allergies,
      themeColorHex: themeColorHex ?? this.themeColorHex,
      coachTone: coachTone ?? this.coachTone,
      themePreference: themePreference ?? this.themePreference,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      cuisineRegion: cuisineRegion ?? this.cuisineRegion,
      showMacros: showMacros ?? this.showMacros,
      unlockedRecipeIds: unlockedRecipeIds ?? this.unlockedRecipeIds,
      preferredIngredients: preferredIngredients ?? this.preferredIngredients,
      fitnessWhy: fitnessWhy ?? this.fitnessWhy,
      aspiration: aspiration ?? this.aspiration,
      targetWeightKg:
          clearTargetWeight ? null : (targetWeightKg ?? this.targetWeightKg),
      weeklyTrainingDays: weeklyTrainingDays ?? this.weeklyTrainingDays,
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
    );
  }
}

class DailyCheckIn {
  const DailyCheckIn({
    required this.id,
    required this.date,
    required this.mood,
    required this.intensity,
    required this.selectedMuscles,
    required this.surpriseMe,
    this.focus = TrainingFocus.hypertrophy,
    this.soreness = SorenessLevel.none,
    this.avoidMuscles = const [],
    this.equipmentOverride,
  });

  final String id;
  final DateTime date;
  final Mood mood;
  final Intensity intensity;
  final List<MuscleGroup> selectedMuscles;
  final bool surpriseMe;
  final TrainingFocus focus;
  final SorenessLevel soreness;
  final List<MuscleGroup> avoidMuscles;
  /// Null = use profile equipment for this day.
  final List<Equipment>? equipmentOverride;
}

class PlannedExercise {
  const PlannedExercise({
    required this.exerciseId,
    required this.name,
    required this.muscleGroups,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.formCues,
    required this.commonMistakes,
    required this.includeDropSet,
    this.estimatedCalories = 0,
    this.demoImages = const [],
    this.isCompound = false,
    this.recommendedSets,
  });

  final String exerciseId;
  final String name;
  final List<MuscleGroup> muscleGroups;
  final int sets;
  final int reps;
  final int restSeconds;
  final List<String> formCues;
  final List<String> commonMistakes;
  final bool includeDropSet;
  final int estimatedCalories;
  final List<String> demoImages;
  final bool isCompound;
  /// Ideal set count from intensity/focus at generation time.
  final int? recommendedSets;

  PlannedExercise copyWith({
    String? exerciseId,
    String? name,
    List<MuscleGroup>? muscleGroups,
    int? sets,
    int? reps,
    int? restSeconds,
    List<String>? formCues,
    List<String>? commonMistakes,
    bool? includeDropSet,
    int? estimatedCalories,
    List<String>? demoImages,
    bool? isCompound,
    int? recommendedSets,
  }) {
    return PlannedExercise(
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      formCues: formCues ?? this.formCues,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      includeDropSet: includeDropSet ?? this.includeDropSet,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      demoImages: demoImages ?? this.demoImages,
      isCompound: isCompound ?? this.isCompound,
      recommendedSets: recommendedSets ?? this.recommendedSets,
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'name': name,
        'muscleGroups': muscleGroups.map((e) => e.name).toList(),
        'sets': sets,
        'reps': reps,
        'restSeconds': restSeconds,
        'formCues': formCues,
        'commonMistakes': commonMistakes,
        'includeDropSet': includeDropSet,
        'estimatedCalories': estimatedCalories,
        'demoImages': demoImages,
        'isCompound': isCompound,
        if (recommendedSets != null) 'recommendedSets': recommendedSets,
      };

  factory PlannedExercise.fromJson(Map<String, dynamic> json) {
    return PlannedExercise(
      exerciseId: json['exerciseId'] as String,
      name: json['name'] as String,
      muscleGroups: (json['muscleGroups'] as List)
          .map((e) => MuscleGroup.values.byName(e as String))
          .toList(),
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      restSeconds: json['restSeconds'] as int,
      formCues: (json['formCues'] as List).cast<String>(),
      commonMistakes: (json['commonMistakes'] as List).cast<String>(),
      includeDropSet: json['includeDropSet'] as bool? ?? false,
      estimatedCalories: json['estimatedCalories'] as int? ?? 0,
      demoImages: (json['demoImages'] as List?)?.cast<String>() ?? const [],
      isCompound: json['isCompound'] as bool? ?? false,
      recommendedSets: json['recommendedSets'] as int?,
    );
  }
}

class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.checkInId,
    required this.createdAt,
    required this.exercises,
    required this.encouragement,
    this.preMeal,
    this.postMeal,
    this.gymMinutes = 45,
    this.exerciseCountOverride,
  });

  final String id;
  final String checkInId;
  final DateTime createdAt;
  final List<PlannedExercise> exercises;
  final String encouragement;
  final MealSuggestion? preMeal;
  final MealSuggestion? postMeal;
  final int gymMinutes;

  /// When set, overrides the gym-time baseline exercise count.
  final int? exerciseCountOverride;

  int get estimatedBurnKcal =>
      exercises.fold(0, (sum, e) => sum + e.estimatedCalories);

  int get mealFuelKcal =>
      (preMeal?.calories ?? 0) + (postMeal?.calories ?? 0);

  double get mealProteinG =>
      (preMeal?.proteinG ?? 0) + (postMeal?.proteinG ?? 0);

  double get mealCarbsG => (preMeal?.carbsG ?? 0) + (postMeal?.carbsG ?? 0);

  double get mealFatG => (preMeal?.fatG ?? 0) + (postMeal?.fatG ?? 0);

  /// Positive = more fuel logged than estimated burn (recovery surplus).
  int get calorieBalanceKcal => mealFuelKcal - estimatedBurnKcal;

  WorkoutPlan copyWith({
    String? id,
    String? checkInId,
    DateTime? createdAt,
    List<PlannedExercise>? exercises,
    String? encouragement,
    MealSuggestion? preMeal,
    MealSuggestion? postMeal,
    int? gymMinutes,
    int? exerciseCountOverride,
    bool clearPreMeal = false,
    bool clearPostMeal = false,
    bool clearExerciseCountOverride = false,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      checkInId: checkInId ?? this.checkInId,
      createdAt: createdAt ?? this.createdAt,
      exercises: exercises ?? this.exercises,
      encouragement: encouragement ?? this.encouragement,
      preMeal: clearPreMeal ? null : (preMeal ?? this.preMeal),
      postMeal: clearPostMeal ? null : (postMeal ?? this.postMeal),
      gymMinutes: gymMinutes ?? this.gymMinutes,
      exerciseCountOverride: clearExerciseCountOverride
          ? null
          : (exerciseCountOverride ?? this.exerciseCountOverride),
    );
  }
}

/// Snapshot of meals chosen with a day's plan (for Progress history).
class FuelHistoryEntry {
  const FuelHistoryEntry({
    required this.date,
    required this.planId,
    this.preMealName,
    this.preMealCalories,
    this.postMealName,
    this.postMealCalories,
    this.gymMinutes = 45,
  });

  final DateTime date;
  final String planId;
  final String? preMealName;
  final int? preMealCalories;
  final String? postMealName;
  final int? postMealCalories;
  final int gymMinutes;
}

class SetLog {
  const SetLog({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.setNumber,
    required this.repsCompleted,
    required this.weightKg,
    required this.rpe,
    required this.completed,
    this.durationSeconds = 0,
  });

  final String id;
  final String sessionId;
  final String exerciseId;
  final int setNumber;
  final int repsCompleted;
  final double weightKg;
  final int rpe;
  final bool completed;
  final int durationSeconds;
}

class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.planId,
    required this.startedAt,
    this.endedAt,
    this.completed = false,
    this.muscleGroups = const [],
    this.setLogs = const [],
  });

  final String id;
  final String planId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool completed;
  final List<MuscleGroup> muscleGroups;
  final List<SetLog> setLogs;

  Duration? get duration {
    if (endedAt == null) return null;
    return endedAt!.difference(startedAt);
  }
}

/// Saved template: ordered exercise ids the user picked in the builder.
class CustomRoutine {
  const CustomRoutine({
    required this.id,
    required this.name,
    required this.exerciseIds,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final List<String> exerciseIds;
  final DateTime updatedAt;

  CustomRoutine copyWith({
    String? name,
    List<String>? exerciseIds,
    DateTime? updatedAt,
  }) {
    return CustomRoutine(
      id: id,
      name: name ?? this.name,
      exerciseIds: exerciseIds ?? this.exerciseIds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'exerciseIds': exerciseIds,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CustomRoutine.fromJson(Map<String, dynamic> json) {
    return CustomRoutine(
      id: json['id'] as String,
      name: json['name'] as String,
      exerciseIds: (json['exerciseIds'] as List).cast<String>(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// User-defined Mon–Sun template (DateTime.monday = 1 … sunday = 7).
class WeeklyRoutine {
  const WeeklyRoutine({
    required this.id,
    required this.days,
    required this.updatedAt,
    this.deloadUntil,
  });

  final String id;
  final Map<int, DayKind> days;
  final DateTime updatedAt;
  final DateTime? deloadUntil;

  bool get isDeloadActive {
    final until = deloadUntil;
    if (until == null) return false;
    return !DateTime.now().isAfter(until);
  }

  DayKind kindFor(DateTime date) {
    final weekday = date.weekday; // 1–7
    return days[weekday] ?? DayKind.rest;
  }

  WeeklyRoutine copyWith({
    Map<int, DayKind>? days,
    DateTime? updatedAt,
    DateTime? deloadUntil,
    bool clearDeload = false,
  }) {
    return WeeklyRoutine(
      id: id,
      days: days ?? this.days,
      updatedAt: updatedAt ?? this.updatedAt,
      deloadUntil: clearDeload ? null : (deloadUntil ?? this.deloadUntil),
    );
  }

  static Map<int, DayKind> defaultDays() => {
        DateTime.monday: DayKind.gym,
        DateTime.tuesday: DayKind.rest,
        DateTime.wednesday: DayKind.gym,
        DateTime.thursday: DayKind.rest,
        DateTime.friday: DayKind.gym,
        DateTime.saturday: DayKind.gym,
        DateTime.sunday: DayKind.cheat,
      };
}

class DayLog {
  const DayLog({
    required this.id,
    required this.date,
    required this.plannedKind,
    this.actualKind,
    this.note = '',
    required this.updatedAt,
  });

  final String id;
  final DateTime date;
  final DayKind plannedKind;
  final DayKind? actualKind;
  final String note;
  final DateTime updatedAt;

  DayKind get effectiveKind => actualKind ?? plannedKind;

  bool get isLogged => actualKind != null;
}

class RoutineWeekSnapshot {
  const RoutineWeekSnapshot({
    required this.weekStart,
    required this.days,
  });

  final DateTime weekStart;
  final List<DayLog> days;
}

class RoutineAnalysis {
  const RoutineAnalysis({
    required this.gymCount,
    required this.restCount,
    required this.cheatCount,
    required this.plannedGymDays,
    required this.hitGymDays,
    required this.weeklyGymCounts,
  });

  final int gymCount;
  final int restCount;
  final int cheatCount;
  final int plannedGymDays;
  final int hitGymDays;
  /// Oldest → newest, last 4 calendar weeks (Mon-start), gym day counts.
  final List<int> weeklyGymCounts;

  double get adherence {
    if (plannedGymDays == 0) return 0;
    return hitGymDays / plannedGymDays;
  }
}

/// Everything logged for a single calendar day (detail screen).
class DayActivitySnapshot {
  const DayActivitySnapshot({
    required this.date,
    required this.dayLog,
    required this.sessions,
    this.plan,
    this.hydration,
  });

  final DateTime date;
  final DayLog dayLog;
  final List<WorkoutSession> sessions;
  final WorkoutPlan? plan;
  final HydrationLog? hydration;

  int get setsCompleted =>
      sessions.fold(0, (n, s) => n + s.setLogs.where((l) => l.completed).length);

  int get totalSessionMinutes => sessions.fold(0, (n, s) {
        final d = s.duration;
        return n + (d?.inMinutes ?? 0);
      });
}

class HydrationLog {
  const HydrationLog({
    required this.id,
    required this.date,
    required this.glasses,
    this.goalGlasses = 8,
    required this.updatedAt,
  });

  final String id;
  final DateTime date;
  final int glasses;
  final int goalGlasses;
  final DateTime updatedAt;
}

class BodyMetricLog {
  const BodyMetricLog({
    required this.id,
    required this.loggedAt,
    required this.weightKg,
    this.waistCm,
    this.note = '',
  });

  final String id;
  final DateTime loggedAt;
  final double weightKg;
  final double? waistCm;
  final String note;
}

class ProgressPhoto {
  const ProgressPhoto({
    required this.id,
    required this.loggedAt,
    required this.filePath,
    this.note = '',
  });

  final String id;
  final DateTime loggedAt;
  final String filePath;
  final String note;
}

class OverloadSuggestion {
  const OverloadSuggestion({
    required this.exerciseId,
    required this.lastWeightKg,
    required this.lastReps,
    required this.averageRpe,
    required this.suggestedWeightKg,
    required this.suggestedReps,
    required this.message,
    required this.bumpWeight,
  });

  final String exerciseId;
  final double lastWeightKg;
  final int lastReps;
  final double averageRpe;
  final double suggestedWeightKg;
  final int suggestedReps;
  final String message;
  final bool bumpWeight;
}

enum MealFoodSource {
  userInputted,
  systemImported;

  String get stored => switch (this) {
        MealFoodSource.userInputted => 'user_inputted',
        MealFoodSource.systemImported => 'system_imported',
      };

  String get label => switch (this) {
        MealFoodSource.userInputted => 'Your food',
        MealFoodSource.systemImported => 'Catalog',
      };

  static MealFoodSource fromStored(String? raw, {String? foodId}) {
    if (raw == 'user_inputted') return MealFoodSource.userInputted;
    if (raw == 'system_imported') return MealFoodSource.systemImported;
    return foodId != null && foodId.isNotEmpty
        ? MealFoodSource.systemImported
        : MealFoodSource.userInputted;
  }
}

class CustomFoodItem {
  const CustomFoodItem({
    required this.id,
    required this.label,
    required this.source,
    this.systemFoodId,
    this.servingLabel = 'serving',
    this.kcal = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    required this.createdAt,
  });

  final String id;
  final String label;
  final MealFoodSource source;
  final String? systemFoodId;
  final String servingLabel;
  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final DateTime createdAt;

  MealLogLineItem toLineItem({double quantity = 1}) {
    final q = quantity <= 0 ? 1.0 : quantity;
    return MealLogLineItem(
      foodId: systemFoodId,
      label: label,
      quantity: q,
      unit: servingLabel,
      kcal: kcal * q,
      proteinG: proteinG * q,
      carbsG: carbsG * q,
      fatG: fatG * q,
      source: source,
    );
  }
}

enum MealLogTiming {
  preWorkout,
  postWorkout,
  general;

  String get label => switch (this) {
        MealLogTiming.preWorkout => 'Pre-workout',
        MealLogTiming.postWorkout => 'Post-workout',
        MealLogTiming.general => 'Any time',
      };

  static MealLogTiming fromStored(String raw) {
    return MealLogTiming.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => MealLogTiming.general,
    );
  }
}

class MealLogLineItem {
  const MealLogLineItem({
    this.foodId,
    required this.label,
    required this.quantity,
    required this.unit,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.source,
  });

  final String? foodId;
  final String label;
  final double quantity;
  final String unit;
  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final MealFoodSource? source;

  MealFoodSource get resolvedSource => source ??
      MealFoodSource.fromStored(null, foodId: foodId);

  Map<String, dynamic> toJson() => {
        if (foodId != null) 'foodId': foodId,
        'label': label,
        'quantity': quantity,
        'unit': unit,
        'kcal': kcal,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        'source': resolvedSource.stored,
      };

  factory MealLogLineItem.fromJson(Map<String, dynamic> json) {
    final foodId = json['foodId'] as String?;
    return MealLogLineItem(
      foodId: foodId,
      label: json['label'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'serving',
      kcal: (json['kcal'] as num).toDouble(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
      source: MealFoodSource.fromStored(json['source'] as String?, foodId: foodId),
    );
  }
}

class MealLogEntry {
  const MealLogEntry({
    required this.id,
    required this.eatenAt,
    required this.timing,
    required this.items,
    this.notes = '',
  });

  final String id;
  final DateTime eatenAt;
  final MealLogTiming timing;
  final List<MealLogLineItem> items;
  final String notes;

  double get totalKcal => items.fold(0, (s, i) => s + i.kcal);
  double get totalProtein => items.fold(0, (s, i) => s + i.proteinG);
  double get totalCarbs => items.fold(0, (s, i) => s + i.carbsG);
  double get totalFat => items.fold(0, (s, i) => s + i.fatG);
}

enum MealVerdictScore { good, okay, reconsider }

class MealLogVerdict {
  const MealLogVerdict({
    required this.score,
    required this.summary,
    required this.bullets,
    required this.suggestions,
  });

  final MealVerdictScore score;
  final String summary;
  final List<String> bullets;
  final List<String> suggestions;
}
