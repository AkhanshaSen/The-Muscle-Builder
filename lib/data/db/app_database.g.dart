// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _journeyNameMeta = const VerificationMeta(
    'journeyName',
  );
  @override
  late final GeneratedColumn<String> journeyName = GeneratedColumn<String>(
    'journey_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryGoalMeta = const VerificationMeta(
    'primaryGoal',
  );
  @override
  late final GeneratedColumn<String> primaryGoal = GeneratedColumn<String>(
    'primary_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experienceMeta = const VerificationMeta(
    'experience',
  );
  @override
  late final GeneratedColumn<String> experience = GeneratedColumn<String>(
    'experience',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentJsonMeta = const VerificationMeta(
    'equipmentJson',
  );
  @override
  late final GeneratedColumn<String> equipmentJson = GeneratedColumn<String>(
    'equipment_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietTypeMeta = const VerificationMeta(
    'dietType',
  );
  @override
  late final GeneratedColumn<String> dietType = GeneratedColumn<String>(
    'diet_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allergiesJsonMeta = const VerificationMeta(
    'allergiesJson',
  );
  @override
  late final GeneratedColumn<String> allergiesJson = GeneratedColumn<String>(
    'allergies_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeColorHexMeta = const VerificationMeta(
    'themeColorHex',
  );
  @override
  late final GeneratedColumn<String> themeColorHex = GeneratedColumn<String>(
    'theme_color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coachToneMeta = const VerificationMeta(
    'coachTone',
  );
  @override
  late final GeneratedColumn<String> coachTone = GeneratedColumn<String>(
    'coach_tone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themePreferenceMeta = const VerificationMeta(
    'themePreference',
  );
  @override
  late final GeneratedColumn<String> themePreference = GeneratedColumn<String>(
    'theme_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cuisineRegionMeta = const VerificationMeta(
    'cuisineRegion',
  );
  @override
  late final GeneratedColumn<String> cuisineRegion = GeneratedColumn<String>(
    'cuisine_region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('panIndian'),
  );
  static const VerificationMeta _showMacrosMeta = const VerificationMeta(
    'showMacros',
  );
  @override
  late final GeneratedColumn<bool> showMacros = GeneratedColumn<bool>(
    'show_macros',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_macros" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _unlockedRecipesJsonMeta =
      const VerificationMeta('unlockedRecipesJson');
  @override
  late final GeneratedColumn<String> unlockedRecipesJson =
      GeneratedColumn<String>(
        'unlocked_recipes_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _preferredIngredientsJsonMeta =
      const VerificationMeta('preferredIngredientsJson');
  @override
  late final GeneratedColumn<String> preferredIngredientsJson =
      GeneratedColumn<String>(
        'preferred_ingredients_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _fitnessWhyMeta = const VerificationMeta(
    'fitnessWhy',
  );
  @override
  late final GeneratedColumn<String> fitnessWhy = GeneratedColumn<String>(
    'fitness_why',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _aspirationMeta = const VerificationMeta(
    'aspiration',
  );
  @override
  late final GeneratedColumn<String> aspiration = GeneratedColumn<String>(
    'aspiration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyTrainingDaysMeta =
      const VerificationMeta('weeklyTrainingDays');
  @override
  late final GeneratedColumn<int> weeklyTrainingDays = GeneratedColumn<int>(
    'weekly_training_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _birthdayMeta = const VerificationMeta(
    'birthday',
  );
  @override
  late final GeneratedColumn<DateTime> birthday = GeneratedColumn<DateTime>(
    'birthday',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    journeyName,
    weightKg,
    heightCm,
    age,
    gender,
    activityLevel,
    primaryGoal,
    experience,
    equipmentJson,
    dietType,
    allergiesJson,
    themeColorHex,
    coachTone,
    themePreference,
    onboardingComplete,
    cuisineRegion,
    showMacros,
    unlockedRecipesJson,
    preferredIngredientsJson,
    fitnessWhy,
    aspiration,
    targetWeightKg,
    weeklyTrainingDays,
    birthday,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('journey_name')) {
      context.handle(
        _journeyNameMeta,
        journeyName.isAcceptableOrUnknown(
          data['journey_name']!,
          _journeyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_journeyNameMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('primary_goal')) {
      context.handle(
        _primaryGoalMeta,
        primaryGoal.isAcceptableOrUnknown(
          data['primary_goal']!,
          _primaryGoalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryGoalMeta);
    }
    if (data.containsKey('experience')) {
      context.handle(
        _experienceMeta,
        experience.isAcceptableOrUnknown(data['experience']!, _experienceMeta),
      );
    } else if (isInserting) {
      context.missing(_experienceMeta);
    }
    if (data.containsKey('equipment_json')) {
      context.handle(
        _equipmentJsonMeta,
        equipmentJson.isAcceptableOrUnknown(
          data['equipment_json']!,
          _equipmentJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentJsonMeta);
    }
    if (data.containsKey('diet_type')) {
      context.handle(
        _dietTypeMeta,
        dietType.isAcceptableOrUnknown(data['diet_type']!, _dietTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_dietTypeMeta);
    }
    if (data.containsKey('allergies_json')) {
      context.handle(
        _allergiesJsonMeta,
        allergiesJson.isAcceptableOrUnknown(
          data['allergies_json']!,
          _allergiesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allergiesJsonMeta);
    }
    if (data.containsKey('theme_color_hex')) {
      context.handle(
        _themeColorHexMeta,
        themeColorHex.isAcceptableOrUnknown(
          data['theme_color_hex']!,
          _themeColorHexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_themeColorHexMeta);
    }
    if (data.containsKey('coach_tone')) {
      context.handle(
        _coachToneMeta,
        coachTone.isAcceptableOrUnknown(data['coach_tone']!, _coachToneMeta),
      );
    } else if (isInserting) {
      context.missing(_coachToneMeta);
    }
    if (data.containsKey('theme_preference')) {
      context.handle(
        _themePreferenceMeta,
        themePreference.isAcceptableOrUnknown(
          data['theme_preference']!,
          _themePreferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_themePreferenceMeta);
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('cuisine_region')) {
      context.handle(
        _cuisineRegionMeta,
        cuisineRegion.isAcceptableOrUnknown(
          data['cuisine_region']!,
          _cuisineRegionMeta,
        ),
      );
    }
    if (data.containsKey('show_macros')) {
      context.handle(
        _showMacrosMeta,
        showMacros.isAcceptableOrUnknown(data['show_macros']!, _showMacrosMeta),
      );
    }
    if (data.containsKey('unlocked_recipes_json')) {
      context.handle(
        _unlockedRecipesJsonMeta,
        unlockedRecipesJson.isAcceptableOrUnknown(
          data['unlocked_recipes_json']!,
          _unlockedRecipesJsonMeta,
        ),
      );
    }
    if (data.containsKey('preferred_ingredients_json')) {
      context.handle(
        _preferredIngredientsJsonMeta,
        preferredIngredientsJson.isAcceptableOrUnknown(
          data['preferred_ingredients_json']!,
          _preferredIngredientsJsonMeta,
        ),
      );
    }
    if (data.containsKey('fitness_why')) {
      context.handle(
        _fitnessWhyMeta,
        fitnessWhy.isAcceptableOrUnknown(data['fitness_why']!, _fitnessWhyMeta),
      );
    }
    if (data.containsKey('aspiration')) {
      context.handle(
        _aspirationMeta,
        aspiration.isAcceptableOrUnknown(data['aspiration']!, _aspirationMeta),
      );
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('weekly_training_days')) {
      context.handle(
        _weeklyTrainingDaysMeta,
        weeklyTrainingDays.isAcceptableOrUnknown(
          data['weekly_training_days']!,
          _weeklyTrainingDaysMeta,
        ),
      );
    }
    if (data.containsKey('birthday')) {
      context.handle(
        _birthdayMeta,
        birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      journeyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journey_name'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
      primaryGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_goal'],
      )!,
      experience: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experience'],
      )!,
      equipmentJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_json'],
      )!,
      dietType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_type'],
      )!,
      allergiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies_json'],
      )!,
      themeColorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_color_hex'],
      )!,
      coachTone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coach_tone'],
      )!,
      themePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_preference'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      cuisineRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuisine_region'],
      )!,
      showMacros: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_macros'],
      )!,
      unlockedRecipesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unlocked_recipes_json'],
      )!,
      preferredIngredientsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_ingredients_json'],
      )!,
      fitnessWhy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fitness_why'],
      )!,
      aspiration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aspiration'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      ),
      weeklyTrainingDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_training_days'],
      )!,
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birthday'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfileRow extends DataClass implements Insertable<UserProfileRow> {
  final String id;
  final String name;
  final String journeyName;
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;
  final String activityLevel;
  final String primaryGoal;
  final String experience;
  final String equipmentJson;
  final String dietType;
  final String allergiesJson;
  final String themeColorHex;
  final String coachTone;
  final String themePreference;
  final bool onboardingComplete;
  final String cuisineRegion;
  final bool showMacros;
  final String unlockedRecipesJson;
  final String preferredIngredientsJson;
  final String fitnessWhy;
  final String aspiration;
  final double? targetWeightKg;
  final int weeklyTrainingDays;
  final DateTime? birthday;
  const UserProfileRow({
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
    required this.equipmentJson,
    required this.dietType,
    required this.allergiesJson,
    required this.themeColorHex,
    required this.coachTone,
    required this.themePreference,
    required this.onboardingComplete,
    required this.cuisineRegion,
    required this.showMacros,
    required this.unlockedRecipesJson,
    required this.preferredIngredientsJson,
    required this.fitnessWhy,
    required this.aspiration,
    this.targetWeightKg,
    required this.weeklyTrainingDays,
    this.birthday,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['journey_name'] = Variable<String>(journeyName);
    map['weight_kg'] = Variable<double>(weightKg);
    map['height_cm'] = Variable<double>(heightCm);
    map['age'] = Variable<int>(age);
    map['gender'] = Variable<String>(gender);
    map['activity_level'] = Variable<String>(activityLevel);
    map['primary_goal'] = Variable<String>(primaryGoal);
    map['experience'] = Variable<String>(experience);
    map['equipment_json'] = Variable<String>(equipmentJson);
    map['diet_type'] = Variable<String>(dietType);
    map['allergies_json'] = Variable<String>(allergiesJson);
    map['theme_color_hex'] = Variable<String>(themeColorHex);
    map['coach_tone'] = Variable<String>(coachTone);
    map['theme_preference'] = Variable<String>(themePreference);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['cuisine_region'] = Variable<String>(cuisineRegion);
    map['show_macros'] = Variable<bool>(showMacros);
    map['unlocked_recipes_json'] = Variable<String>(unlockedRecipesJson);
    map['preferred_ingredients_json'] = Variable<String>(
      preferredIngredientsJson,
    );
    map['fitness_why'] = Variable<String>(fitnessWhy);
    map['aspiration'] = Variable<String>(aspiration);
    if (!nullToAbsent || targetWeightKg != null) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg);
    }
    map['weekly_training_days'] = Variable<int>(weeklyTrainingDays);
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      journeyName: Value(journeyName),
      weightKg: Value(weightKg),
      heightCm: Value(heightCm),
      age: Value(age),
      gender: Value(gender),
      activityLevel: Value(activityLevel),
      primaryGoal: Value(primaryGoal),
      experience: Value(experience),
      equipmentJson: Value(equipmentJson),
      dietType: Value(dietType),
      allergiesJson: Value(allergiesJson),
      themeColorHex: Value(themeColorHex),
      coachTone: Value(coachTone),
      themePreference: Value(themePreference),
      onboardingComplete: Value(onboardingComplete),
      cuisineRegion: Value(cuisineRegion),
      showMacros: Value(showMacros),
      unlockedRecipesJson: Value(unlockedRecipesJson),
      preferredIngredientsJson: Value(preferredIngredientsJson),
      fitnessWhy: Value(fitnessWhy),
      aspiration: Value(aspiration),
      targetWeightKg: targetWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeightKg),
      weeklyTrainingDays: Value(weeklyTrainingDays),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
    );
  }

  factory UserProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      journeyName: serializer.fromJson<String>(json['journeyName']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<String>(json['gender']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
      primaryGoal: serializer.fromJson<String>(json['primaryGoal']),
      experience: serializer.fromJson<String>(json['experience']),
      equipmentJson: serializer.fromJson<String>(json['equipmentJson']),
      dietType: serializer.fromJson<String>(json['dietType']),
      allergiesJson: serializer.fromJson<String>(json['allergiesJson']),
      themeColorHex: serializer.fromJson<String>(json['themeColorHex']),
      coachTone: serializer.fromJson<String>(json['coachTone']),
      themePreference: serializer.fromJson<String>(json['themePreference']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      cuisineRegion: serializer.fromJson<String>(json['cuisineRegion']),
      showMacros: serializer.fromJson<bool>(json['showMacros']),
      unlockedRecipesJson: serializer.fromJson<String>(
        json['unlockedRecipesJson'],
      ),
      preferredIngredientsJson: serializer.fromJson<String>(
        json['preferredIngredientsJson'],
      ),
      fitnessWhy: serializer.fromJson<String>(json['fitnessWhy']),
      aspiration: serializer.fromJson<String>(json['aspiration']),
      targetWeightKg: serializer.fromJson<double?>(json['targetWeightKg']),
      weeklyTrainingDays: serializer.fromJson<int>(json['weeklyTrainingDays']),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'journeyName': serializer.toJson<String>(journeyName),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double>(heightCm),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<String>(gender),
      'activityLevel': serializer.toJson<String>(activityLevel),
      'primaryGoal': serializer.toJson<String>(primaryGoal),
      'experience': serializer.toJson<String>(experience),
      'equipmentJson': serializer.toJson<String>(equipmentJson),
      'dietType': serializer.toJson<String>(dietType),
      'allergiesJson': serializer.toJson<String>(allergiesJson),
      'themeColorHex': serializer.toJson<String>(themeColorHex),
      'coachTone': serializer.toJson<String>(coachTone),
      'themePreference': serializer.toJson<String>(themePreference),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'cuisineRegion': serializer.toJson<String>(cuisineRegion),
      'showMacros': serializer.toJson<bool>(showMacros),
      'unlockedRecipesJson': serializer.toJson<String>(unlockedRecipesJson),
      'preferredIngredientsJson': serializer.toJson<String>(
        preferredIngredientsJson,
      ),
      'fitnessWhy': serializer.toJson<String>(fitnessWhy),
      'aspiration': serializer.toJson<String>(aspiration),
      'targetWeightKg': serializer.toJson<double?>(targetWeightKg),
      'weeklyTrainingDays': serializer.toJson<int>(weeklyTrainingDays),
      'birthday': serializer.toJson<DateTime?>(birthday),
    };
  }

  UserProfileRow copyWith({
    String? id,
    String? name,
    String? journeyName,
    double? weightKg,
    double? heightCm,
    int? age,
    String? gender,
    String? activityLevel,
    String? primaryGoal,
    String? experience,
    String? equipmentJson,
    String? dietType,
    String? allergiesJson,
    String? themeColorHex,
    String? coachTone,
    String? themePreference,
    bool? onboardingComplete,
    String? cuisineRegion,
    bool? showMacros,
    String? unlockedRecipesJson,
    String? preferredIngredientsJson,
    String? fitnessWhy,
    String? aspiration,
    Value<double?> targetWeightKg = const Value.absent(),
    int? weeklyTrainingDays,
    Value<DateTime?> birthday = const Value.absent(),
  }) => UserProfileRow(
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
    equipmentJson: equipmentJson ?? this.equipmentJson,
    dietType: dietType ?? this.dietType,
    allergiesJson: allergiesJson ?? this.allergiesJson,
    themeColorHex: themeColorHex ?? this.themeColorHex,
    coachTone: coachTone ?? this.coachTone,
    themePreference: themePreference ?? this.themePreference,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    cuisineRegion: cuisineRegion ?? this.cuisineRegion,
    showMacros: showMacros ?? this.showMacros,
    unlockedRecipesJson: unlockedRecipesJson ?? this.unlockedRecipesJson,
    preferredIngredientsJson:
        preferredIngredientsJson ?? this.preferredIngredientsJson,
    fitnessWhy: fitnessWhy ?? this.fitnessWhy,
    aspiration: aspiration ?? this.aspiration,
    targetWeightKg: targetWeightKg.present
        ? targetWeightKg.value
        : this.targetWeightKg,
    weeklyTrainingDays: weeklyTrainingDays ?? this.weeklyTrainingDays,
    birthday: birthday.present ? birthday.value : this.birthday,
  );
  UserProfileRow copyWithCompanion(UserProfilesCompanion data) {
    return UserProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      journeyName: data.journeyName.present
          ? data.journeyName.value
          : this.journeyName,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      primaryGoal: data.primaryGoal.present
          ? data.primaryGoal.value
          : this.primaryGoal,
      experience: data.experience.present
          ? data.experience.value
          : this.experience,
      equipmentJson: data.equipmentJson.present
          ? data.equipmentJson.value
          : this.equipmentJson,
      dietType: data.dietType.present ? data.dietType.value : this.dietType,
      allergiesJson: data.allergiesJson.present
          ? data.allergiesJson.value
          : this.allergiesJson,
      themeColorHex: data.themeColorHex.present
          ? data.themeColorHex.value
          : this.themeColorHex,
      coachTone: data.coachTone.present ? data.coachTone.value : this.coachTone,
      themePreference: data.themePreference.present
          ? data.themePreference.value
          : this.themePreference,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      cuisineRegion: data.cuisineRegion.present
          ? data.cuisineRegion.value
          : this.cuisineRegion,
      showMacros: data.showMacros.present
          ? data.showMacros.value
          : this.showMacros,
      unlockedRecipesJson: data.unlockedRecipesJson.present
          ? data.unlockedRecipesJson.value
          : this.unlockedRecipesJson,
      preferredIngredientsJson: data.preferredIngredientsJson.present
          ? data.preferredIngredientsJson.value
          : this.preferredIngredientsJson,
      fitnessWhy: data.fitnessWhy.present
          ? data.fitnessWhy.value
          : this.fitnessWhy,
      aspiration: data.aspiration.present
          ? data.aspiration.value
          : this.aspiration,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      weeklyTrainingDays: data.weeklyTrainingDays.present
          ? data.weeklyTrainingDays.value
          : this.weeklyTrainingDays,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('journeyName: $journeyName, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('experience: $experience, ')
          ..write('equipmentJson: $equipmentJson, ')
          ..write('dietType: $dietType, ')
          ..write('allergiesJson: $allergiesJson, ')
          ..write('themeColorHex: $themeColorHex, ')
          ..write('coachTone: $coachTone, ')
          ..write('themePreference: $themePreference, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('cuisineRegion: $cuisineRegion, ')
          ..write('showMacros: $showMacros, ')
          ..write('unlockedRecipesJson: $unlockedRecipesJson, ')
          ..write('preferredIngredientsJson: $preferredIngredientsJson, ')
          ..write('fitnessWhy: $fitnessWhy, ')
          ..write('aspiration: $aspiration, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('weeklyTrainingDays: $weeklyTrainingDays, ')
          ..write('birthday: $birthday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    journeyName,
    weightKg,
    heightCm,
    age,
    gender,
    activityLevel,
    primaryGoal,
    experience,
    equipmentJson,
    dietType,
    allergiesJson,
    themeColorHex,
    coachTone,
    themePreference,
    onboardingComplete,
    cuisineRegion,
    showMacros,
    unlockedRecipesJson,
    preferredIngredientsJson,
    fitnessWhy,
    aspiration,
    targetWeightKg,
    weeklyTrainingDays,
    birthday,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.journeyName == this.journeyName &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.activityLevel == this.activityLevel &&
          other.primaryGoal == this.primaryGoal &&
          other.experience == this.experience &&
          other.equipmentJson == this.equipmentJson &&
          other.dietType == this.dietType &&
          other.allergiesJson == this.allergiesJson &&
          other.themeColorHex == this.themeColorHex &&
          other.coachTone == this.coachTone &&
          other.themePreference == this.themePreference &&
          other.onboardingComplete == this.onboardingComplete &&
          other.cuisineRegion == this.cuisineRegion &&
          other.showMacros == this.showMacros &&
          other.unlockedRecipesJson == this.unlockedRecipesJson &&
          other.preferredIngredientsJson == this.preferredIngredientsJson &&
          other.fitnessWhy == this.fitnessWhy &&
          other.aspiration == this.aspiration &&
          other.targetWeightKg == this.targetWeightKg &&
          other.weeklyTrainingDays == this.weeklyTrainingDays &&
          other.birthday == this.birthday);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfileRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> journeyName;
  final Value<double> weightKg;
  final Value<double> heightCm;
  final Value<int> age;
  final Value<String> gender;
  final Value<String> activityLevel;
  final Value<String> primaryGoal;
  final Value<String> experience;
  final Value<String> equipmentJson;
  final Value<String> dietType;
  final Value<String> allergiesJson;
  final Value<String> themeColorHex;
  final Value<String> coachTone;
  final Value<String> themePreference;
  final Value<bool> onboardingComplete;
  final Value<String> cuisineRegion;
  final Value<bool> showMacros;
  final Value<String> unlockedRecipesJson;
  final Value<String> preferredIngredientsJson;
  final Value<String> fitnessWhy;
  final Value<String> aspiration;
  final Value<double?> targetWeightKg;
  final Value<int> weeklyTrainingDays;
  final Value<DateTime?> birthday;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.journeyName = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.experience = const Value.absent(),
    this.equipmentJson = const Value.absent(),
    this.dietType = const Value.absent(),
    this.allergiesJson = const Value.absent(),
    this.themeColorHex = const Value.absent(),
    this.coachTone = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.cuisineRegion = const Value.absent(),
    this.showMacros = const Value.absent(),
    this.unlockedRecipesJson = const Value.absent(),
    this.preferredIngredientsJson = const Value.absent(),
    this.fitnessWhy = const Value.absent(),
    this.aspiration = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.weeklyTrainingDays = const Value.absent(),
    this.birthday = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required String name,
    required String journeyName,
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
    required String primaryGoal,
    required String experience,
    required String equipmentJson,
    required String dietType,
    required String allergiesJson,
    required String themeColorHex,
    required String coachTone,
    required String themePreference,
    this.onboardingComplete = const Value.absent(),
    this.cuisineRegion = const Value.absent(),
    this.showMacros = const Value.absent(),
    this.unlockedRecipesJson = const Value.absent(),
    this.preferredIngredientsJson = const Value.absent(),
    this.fitnessWhy = const Value.absent(),
    this.aspiration = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.weeklyTrainingDays = const Value.absent(),
    this.birthday = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       journeyName = Value(journeyName),
       weightKg = Value(weightKg),
       heightCm = Value(heightCm),
       age = Value(age),
       gender = Value(gender),
       activityLevel = Value(activityLevel),
       primaryGoal = Value(primaryGoal),
       experience = Value(experience),
       equipmentJson = Value(equipmentJson),
       dietType = Value(dietType),
       allergiesJson = Value(allergiesJson),
       themeColorHex = Value(themeColorHex),
       coachTone = Value(coachTone),
       themePreference = Value(themePreference);
  static Insertable<UserProfileRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? journeyName,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? activityLevel,
    Expression<String>? primaryGoal,
    Expression<String>? experience,
    Expression<String>? equipmentJson,
    Expression<String>? dietType,
    Expression<String>? allergiesJson,
    Expression<String>? themeColorHex,
    Expression<String>? coachTone,
    Expression<String>? themePreference,
    Expression<bool>? onboardingComplete,
    Expression<String>? cuisineRegion,
    Expression<bool>? showMacros,
    Expression<String>? unlockedRecipesJson,
    Expression<String>? preferredIngredientsJson,
    Expression<String>? fitnessWhy,
    Expression<String>? aspiration,
    Expression<double>? targetWeightKg,
    Expression<int>? weeklyTrainingDays,
    Expression<DateTime>? birthday,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (journeyName != null) 'journey_name': journeyName,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (primaryGoal != null) 'primary_goal': primaryGoal,
      if (experience != null) 'experience': experience,
      if (equipmentJson != null) 'equipment_json': equipmentJson,
      if (dietType != null) 'diet_type': dietType,
      if (allergiesJson != null) 'allergies_json': allergiesJson,
      if (themeColorHex != null) 'theme_color_hex': themeColorHex,
      if (coachTone != null) 'coach_tone': coachTone,
      if (themePreference != null) 'theme_preference': themePreference,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (cuisineRegion != null) 'cuisine_region': cuisineRegion,
      if (showMacros != null) 'show_macros': showMacros,
      if (unlockedRecipesJson != null)
        'unlocked_recipes_json': unlockedRecipesJson,
      if (preferredIngredientsJson != null)
        'preferred_ingredients_json': preferredIngredientsJson,
      if (fitnessWhy != null) 'fitness_why': fitnessWhy,
      if (aspiration != null) 'aspiration': aspiration,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (weeklyTrainingDays != null)
        'weekly_training_days': weeklyTrainingDays,
      if (birthday != null) 'birthday': birthday,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? journeyName,
    Value<double>? weightKg,
    Value<double>? heightCm,
    Value<int>? age,
    Value<String>? gender,
    Value<String>? activityLevel,
    Value<String>? primaryGoal,
    Value<String>? experience,
    Value<String>? equipmentJson,
    Value<String>? dietType,
    Value<String>? allergiesJson,
    Value<String>? themeColorHex,
    Value<String>? coachTone,
    Value<String>? themePreference,
    Value<bool>? onboardingComplete,
    Value<String>? cuisineRegion,
    Value<bool>? showMacros,
    Value<String>? unlockedRecipesJson,
    Value<String>? preferredIngredientsJson,
    Value<String>? fitnessWhy,
    Value<String>? aspiration,
    Value<double?>? targetWeightKg,
    Value<int>? weeklyTrainingDays,
    Value<DateTime?>? birthday,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
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
      equipmentJson: equipmentJson ?? this.equipmentJson,
      dietType: dietType ?? this.dietType,
      allergiesJson: allergiesJson ?? this.allergiesJson,
      themeColorHex: themeColorHex ?? this.themeColorHex,
      coachTone: coachTone ?? this.coachTone,
      themePreference: themePreference ?? this.themePreference,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      cuisineRegion: cuisineRegion ?? this.cuisineRegion,
      showMacros: showMacros ?? this.showMacros,
      unlockedRecipesJson: unlockedRecipesJson ?? this.unlockedRecipesJson,
      preferredIngredientsJson:
          preferredIngredientsJson ?? this.preferredIngredientsJson,
      fitnessWhy: fitnessWhy ?? this.fitnessWhy,
      aspiration: aspiration ?? this.aspiration,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      weeklyTrainingDays: weeklyTrainingDays ?? this.weeklyTrainingDays,
      birthday: birthday ?? this.birthday,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (journeyName.present) {
      map['journey_name'] = Variable<String>(journeyName.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (primaryGoal.present) {
      map['primary_goal'] = Variable<String>(primaryGoal.value);
    }
    if (experience.present) {
      map['experience'] = Variable<String>(experience.value);
    }
    if (equipmentJson.present) {
      map['equipment_json'] = Variable<String>(equipmentJson.value);
    }
    if (dietType.present) {
      map['diet_type'] = Variable<String>(dietType.value);
    }
    if (allergiesJson.present) {
      map['allergies_json'] = Variable<String>(allergiesJson.value);
    }
    if (themeColorHex.present) {
      map['theme_color_hex'] = Variable<String>(themeColorHex.value);
    }
    if (coachTone.present) {
      map['coach_tone'] = Variable<String>(coachTone.value);
    }
    if (themePreference.present) {
      map['theme_preference'] = Variable<String>(themePreference.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (cuisineRegion.present) {
      map['cuisine_region'] = Variable<String>(cuisineRegion.value);
    }
    if (showMacros.present) {
      map['show_macros'] = Variable<bool>(showMacros.value);
    }
    if (unlockedRecipesJson.present) {
      map['unlocked_recipes_json'] = Variable<String>(
        unlockedRecipesJson.value,
      );
    }
    if (preferredIngredientsJson.present) {
      map['preferred_ingredients_json'] = Variable<String>(
        preferredIngredientsJson.value,
      );
    }
    if (fitnessWhy.present) {
      map['fitness_why'] = Variable<String>(fitnessWhy.value);
    }
    if (aspiration.present) {
      map['aspiration'] = Variable<String>(aspiration.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (weeklyTrainingDays.present) {
      map['weekly_training_days'] = Variable<int>(weeklyTrainingDays.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('journeyName: $journeyName, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('experience: $experience, ')
          ..write('equipmentJson: $equipmentJson, ')
          ..write('dietType: $dietType, ')
          ..write('allergiesJson: $allergiesJson, ')
          ..write('themeColorHex: $themeColorHex, ')
          ..write('coachTone: $coachTone, ')
          ..write('themePreference: $themePreference, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('cuisineRegion: $cuisineRegion, ')
          ..write('showMacros: $showMacros, ')
          ..write('unlockedRecipesJson: $unlockedRecipesJson, ')
          ..write('preferredIngredientsJson: $preferredIngredientsJson, ')
          ..write('fitnessWhy: $fitnessWhy, ')
          ..write('aspiration: $aspiration, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('weeklyTrainingDays: $weeklyTrainingDays, ')
          ..write('birthday: $birthday, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyCheckInsTable extends DailyCheckIns
    with TableInfo<$DailyCheckInsTable, DailyCheckInRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyCheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<String> intensity = GeneratedColumn<String>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedMusclesJsonMeta =
      const VerificationMeta('selectedMusclesJson');
  @override
  late final GeneratedColumn<String> selectedMusclesJson =
      GeneratedColumn<String>(
        'selected_muscles_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _surpriseMeMeta = const VerificationMeta(
    'surpriseMe',
  );
  @override
  late final GeneratedColumn<bool> surpriseMe = GeneratedColumn<bool>(
    'surprise_me',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("surprise_me" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hypertrophy'),
  );
  static const VerificationMeta _sorenessMeta = const VerificationMeta(
    'soreness',
  );
  @override
  late final GeneratedColumn<String> soreness = GeneratedColumn<String>(
    'soreness',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _avoidMusclesJsonMeta = const VerificationMeta(
    'avoidMusclesJson',
  );
  @override
  late final GeneratedColumn<String> avoidMusclesJson = GeneratedColumn<String>(
    'avoid_muscles_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _equipmentOverrideJsonMeta =
      const VerificationMeta('equipmentOverrideJson');
  @override
  late final GeneratedColumn<String> equipmentOverrideJson =
      GeneratedColumn<String>(
        'equipment_override_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    mood,
    intensity,
    selectedMusclesJson,
    surpriseMe,
    focus,
    soreness,
    avoidMusclesJson,
    equipmentOverrideJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyCheckInRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('selected_muscles_json')) {
      context.handle(
        _selectedMusclesJsonMeta,
        selectedMusclesJson.isAcceptableOrUnknown(
          data['selected_muscles_json']!,
          _selectedMusclesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedMusclesJsonMeta);
    }
    if (data.containsKey('surprise_me')) {
      context.handle(
        _surpriseMeMeta,
        surpriseMe.isAcceptableOrUnknown(data['surprise_me']!, _surpriseMeMeta),
      );
    }
    if (data.containsKey('focus')) {
      context.handle(
        _focusMeta,
        focus.isAcceptableOrUnknown(data['focus']!, _focusMeta),
      );
    }
    if (data.containsKey('soreness')) {
      context.handle(
        _sorenessMeta,
        soreness.isAcceptableOrUnknown(data['soreness']!, _sorenessMeta),
      );
    }
    if (data.containsKey('avoid_muscles_json')) {
      context.handle(
        _avoidMusclesJsonMeta,
        avoidMusclesJson.isAcceptableOrUnknown(
          data['avoid_muscles_json']!,
          _avoidMusclesJsonMeta,
        ),
      );
    }
    if (data.containsKey('equipment_override_json')) {
      context.handle(
        _equipmentOverrideJsonMeta,
        equipmentOverrideJson.isAcceptableOrUnknown(
          data['equipment_override_json']!,
          _equipmentOverrideJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyCheckInRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCheckInRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intensity'],
      )!,
      selectedMusclesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_muscles_json'],
      )!,
      surpriseMe: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}surprise_me'],
      )!,
      focus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus'],
      )!,
      soreness: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}soreness'],
      )!,
      avoidMusclesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avoid_muscles_json'],
      )!,
      equipmentOverrideJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_override_json'],
      ),
    );
  }

  @override
  $DailyCheckInsTable createAlias(String alias) {
    return $DailyCheckInsTable(attachedDatabase, alias);
  }
}

class DailyCheckInRow extends DataClass implements Insertable<DailyCheckInRow> {
  final String id;
  final DateTime date;
  final String mood;
  final String intensity;
  final String selectedMusclesJson;
  final bool surpriseMe;
  final String focus;
  final String soreness;
  final String avoidMusclesJson;
  final String? equipmentOverrideJson;
  const DailyCheckInRow({
    required this.id,
    required this.date,
    required this.mood,
    required this.intensity,
    required this.selectedMusclesJson,
    required this.surpriseMe,
    required this.focus,
    required this.soreness,
    required this.avoidMusclesJson,
    this.equipmentOverrideJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['mood'] = Variable<String>(mood);
    map['intensity'] = Variable<String>(intensity);
    map['selected_muscles_json'] = Variable<String>(selectedMusclesJson);
    map['surprise_me'] = Variable<bool>(surpriseMe);
    map['focus'] = Variable<String>(focus);
    map['soreness'] = Variable<String>(soreness);
    map['avoid_muscles_json'] = Variable<String>(avoidMusclesJson);
    if (!nullToAbsent || equipmentOverrideJson != null) {
      map['equipment_override_json'] = Variable<String>(equipmentOverrideJson);
    }
    return map;
  }

  DailyCheckInsCompanion toCompanion(bool nullToAbsent) {
    return DailyCheckInsCompanion(
      id: Value(id),
      date: Value(date),
      mood: Value(mood),
      intensity: Value(intensity),
      selectedMusclesJson: Value(selectedMusclesJson),
      surpriseMe: Value(surpriseMe),
      focus: Value(focus),
      soreness: Value(soreness),
      avoidMusclesJson: Value(avoidMusclesJson),
      equipmentOverrideJson: equipmentOverrideJson == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentOverrideJson),
    );
  }

  factory DailyCheckInRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCheckInRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      mood: serializer.fromJson<String>(json['mood']),
      intensity: serializer.fromJson<String>(json['intensity']),
      selectedMusclesJson: serializer.fromJson<String>(
        json['selectedMusclesJson'],
      ),
      surpriseMe: serializer.fromJson<bool>(json['surpriseMe']),
      focus: serializer.fromJson<String>(json['focus']),
      soreness: serializer.fromJson<String>(json['soreness']),
      avoidMusclesJson: serializer.fromJson<String>(json['avoidMusclesJson']),
      equipmentOverrideJson: serializer.fromJson<String?>(
        json['equipmentOverrideJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'mood': serializer.toJson<String>(mood),
      'intensity': serializer.toJson<String>(intensity),
      'selectedMusclesJson': serializer.toJson<String>(selectedMusclesJson),
      'surpriseMe': serializer.toJson<bool>(surpriseMe),
      'focus': serializer.toJson<String>(focus),
      'soreness': serializer.toJson<String>(soreness),
      'avoidMusclesJson': serializer.toJson<String>(avoidMusclesJson),
      'equipmentOverrideJson': serializer.toJson<String?>(
        equipmentOverrideJson,
      ),
    };
  }

  DailyCheckInRow copyWith({
    String? id,
    DateTime? date,
    String? mood,
    String? intensity,
    String? selectedMusclesJson,
    bool? surpriseMe,
    String? focus,
    String? soreness,
    String? avoidMusclesJson,
    Value<String?> equipmentOverrideJson = const Value.absent(),
  }) => DailyCheckInRow(
    id: id ?? this.id,
    date: date ?? this.date,
    mood: mood ?? this.mood,
    intensity: intensity ?? this.intensity,
    selectedMusclesJson: selectedMusclesJson ?? this.selectedMusclesJson,
    surpriseMe: surpriseMe ?? this.surpriseMe,
    focus: focus ?? this.focus,
    soreness: soreness ?? this.soreness,
    avoidMusclesJson: avoidMusclesJson ?? this.avoidMusclesJson,
    equipmentOverrideJson: equipmentOverrideJson.present
        ? equipmentOverrideJson.value
        : this.equipmentOverrideJson,
  );
  DailyCheckInRow copyWithCompanion(DailyCheckInsCompanion data) {
    return DailyCheckInRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      mood: data.mood.present ? data.mood.value : this.mood,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      selectedMusclesJson: data.selectedMusclesJson.present
          ? data.selectedMusclesJson.value
          : this.selectedMusclesJson,
      surpriseMe: data.surpriseMe.present
          ? data.surpriseMe.value
          : this.surpriseMe,
      focus: data.focus.present ? data.focus.value : this.focus,
      soreness: data.soreness.present ? data.soreness.value : this.soreness,
      avoidMusclesJson: data.avoidMusclesJson.present
          ? data.avoidMusclesJson.value
          : this.avoidMusclesJson,
      equipmentOverrideJson: data.equipmentOverrideJson.present
          ? data.equipmentOverrideJson.value
          : this.equipmentOverrideJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckInRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('intensity: $intensity, ')
          ..write('selectedMusclesJson: $selectedMusclesJson, ')
          ..write('surpriseMe: $surpriseMe, ')
          ..write('focus: $focus, ')
          ..write('soreness: $soreness, ')
          ..write('avoidMusclesJson: $avoidMusclesJson, ')
          ..write('equipmentOverrideJson: $equipmentOverrideJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    mood,
    intensity,
    selectedMusclesJson,
    surpriseMe,
    focus,
    soreness,
    avoidMusclesJson,
    equipmentOverrideJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCheckInRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.mood == this.mood &&
          other.intensity == this.intensity &&
          other.selectedMusclesJson == this.selectedMusclesJson &&
          other.surpriseMe == this.surpriseMe &&
          other.focus == this.focus &&
          other.soreness == this.soreness &&
          other.avoidMusclesJson == this.avoidMusclesJson &&
          other.equipmentOverrideJson == this.equipmentOverrideJson);
}

class DailyCheckInsCompanion extends UpdateCompanion<DailyCheckInRow> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> mood;
  final Value<String> intensity;
  final Value<String> selectedMusclesJson;
  final Value<bool> surpriseMe;
  final Value<String> focus;
  final Value<String> soreness;
  final Value<String> avoidMusclesJson;
  final Value<String?> equipmentOverrideJson;
  final Value<int> rowid;
  const DailyCheckInsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.mood = const Value.absent(),
    this.intensity = const Value.absent(),
    this.selectedMusclesJson = const Value.absent(),
    this.surpriseMe = const Value.absent(),
    this.focus = const Value.absent(),
    this.soreness = const Value.absent(),
    this.avoidMusclesJson = const Value.absent(),
    this.equipmentOverrideJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyCheckInsCompanion.insert({
    required String id,
    required DateTime date,
    required String mood,
    required String intensity,
    required String selectedMusclesJson,
    this.surpriseMe = const Value.absent(),
    this.focus = const Value.absent(),
    this.soreness = const Value.absent(),
    this.avoidMusclesJson = const Value.absent(),
    this.equipmentOverrideJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       mood = Value(mood),
       intensity = Value(intensity),
       selectedMusclesJson = Value(selectedMusclesJson);
  static Insertable<DailyCheckInRow> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? mood,
    Expression<String>? intensity,
    Expression<String>? selectedMusclesJson,
    Expression<bool>? surpriseMe,
    Expression<String>? focus,
    Expression<String>? soreness,
    Expression<String>? avoidMusclesJson,
    Expression<String>? equipmentOverrideJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (mood != null) 'mood': mood,
      if (intensity != null) 'intensity': intensity,
      if (selectedMusclesJson != null)
        'selected_muscles_json': selectedMusclesJson,
      if (surpriseMe != null) 'surprise_me': surpriseMe,
      if (focus != null) 'focus': focus,
      if (soreness != null) 'soreness': soreness,
      if (avoidMusclesJson != null) 'avoid_muscles_json': avoidMusclesJson,
      if (equipmentOverrideJson != null)
        'equipment_override_json': equipmentOverrideJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyCheckInsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? mood,
    Value<String>? intensity,
    Value<String>? selectedMusclesJson,
    Value<bool>? surpriseMe,
    Value<String>? focus,
    Value<String>? soreness,
    Value<String>? avoidMusclesJson,
    Value<String?>? equipmentOverrideJson,
    Value<int>? rowid,
  }) {
    return DailyCheckInsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      intensity: intensity ?? this.intensity,
      selectedMusclesJson: selectedMusclesJson ?? this.selectedMusclesJson,
      surpriseMe: surpriseMe ?? this.surpriseMe,
      focus: focus ?? this.focus,
      soreness: soreness ?? this.soreness,
      avoidMusclesJson: avoidMusclesJson ?? this.avoidMusclesJson,
      equipmentOverrideJson:
          equipmentOverrideJson ?? this.equipmentOverrideJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<String>(intensity.value);
    }
    if (selectedMusclesJson.present) {
      map['selected_muscles_json'] = Variable<String>(
        selectedMusclesJson.value,
      );
    }
    if (surpriseMe.present) {
      map['surprise_me'] = Variable<bool>(surpriseMe.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (soreness.present) {
      map['soreness'] = Variable<String>(soreness.value);
    }
    if (avoidMusclesJson.present) {
      map['avoid_muscles_json'] = Variable<String>(avoidMusclesJson.value);
    }
    if (equipmentOverrideJson.present) {
      map['equipment_override_json'] = Variable<String>(
        equipmentOverrideJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckInsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('intensity: $intensity, ')
          ..write('selectedMusclesJson: $selectedMusclesJson, ')
          ..write('surpriseMe: $surpriseMe, ')
          ..write('focus: $focus, ')
          ..write('soreness: $soreness, ')
          ..write('avoidMusclesJson: $avoidMusclesJson, ')
          ..write('equipmentOverrideJson: $equipmentOverrideJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlansTable extends WorkoutPlans
    with TableInfo<$WorkoutPlansTable, WorkoutPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInIdMeta = const VerificationMeta(
    'checkInId',
  );
  @override
  late final GeneratedColumn<String> checkInId = GeneratedColumn<String>(
    'check_in_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exercisesJsonMeta = const VerificationMeta(
    'exercisesJson',
  );
  @override
  late final GeneratedColumn<String> exercisesJson = GeneratedColumn<String>(
    'exercises_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encouragementMeta = const VerificationMeta(
    'encouragement',
  );
  @override
  late final GeneratedColumn<String> encouragement = GeneratedColumn<String>(
    'encouragement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preMealJsonMeta = const VerificationMeta(
    'preMealJson',
  );
  @override
  late final GeneratedColumn<String> preMealJson = GeneratedColumn<String>(
    'pre_meal_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postMealJsonMeta = const VerificationMeta(
    'postMealJson',
  );
  @override
  late final GeneratedColumn<String> postMealJson = GeneratedColumn<String>(
    'post_meal_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gymMinutesMeta = const VerificationMeta(
    'gymMinutes',
  );
  @override
  late final GeneratedColumn<int> gymMinutes = GeneratedColumn<int>(
    'gym_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(45),
  );
  static const VerificationMeta _exerciseCountOverrideMeta =
      const VerificationMeta('exerciseCountOverride');
  @override
  late final GeneratedColumn<int> exerciseCountOverride = GeneratedColumn<int>(
    'exercise_count_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checkInId,
    createdAt,
    exercisesJson,
    encouragement,
    preMealJson,
    postMealJson,
    gymMinutes,
    exerciseCountOverride,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('check_in_id')) {
      context.handle(
        _checkInIdMeta,
        checkInId.isAcceptableOrUnknown(data['check_in_id']!, _checkInIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkInIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('exercises_json')) {
      context.handle(
        _exercisesJsonMeta,
        exercisesJson.isAcceptableOrUnknown(
          data['exercises_json']!,
          _exercisesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercisesJsonMeta);
    }
    if (data.containsKey('encouragement')) {
      context.handle(
        _encouragementMeta,
        encouragement.isAcceptableOrUnknown(
          data['encouragement']!,
          _encouragementMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encouragementMeta);
    }
    if (data.containsKey('pre_meal_json')) {
      context.handle(
        _preMealJsonMeta,
        preMealJson.isAcceptableOrUnknown(
          data['pre_meal_json']!,
          _preMealJsonMeta,
        ),
      );
    }
    if (data.containsKey('post_meal_json')) {
      context.handle(
        _postMealJsonMeta,
        postMealJson.isAcceptableOrUnknown(
          data['post_meal_json']!,
          _postMealJsonMeta,
        ),
      );
    }
    if (data.containsKey('gym_minutes')) {
      context.handle(
        _gymMinutesMeta,
        gymMinutes.isAcceptableOrUnknown(data['gym_minutes']!, _gymMinutesMeta),
      );
    }
    if (data.containsKey('exercise_count_override')) {
      context.handle(
        _exerciseCountOverrideMeta,
        exerciseCountOverride.isAcceptableOrUnknown(
          data['exercise_count_override']!,
          _exerciseCountOverrideMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checkInId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      exercisesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercises_json'],
      )!,
      encouragement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encouragement'],
      )!,
      preMealJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pre_meal_json'],
      ),
      postMealJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_meal_json'],
      ),
      gymMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gym_minutes'],
      )!,
      exerciseCountOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_count_override'],
      ),
    );
  }

  @override
  $WorkoutPlansTable createAlias(String alias) {
    return $WorkoutPlansTable(attachedDatabase, alias);
  }
}

class WorkoutPlanRow extends DataClass implements Insertable<WorkoutPlanRow> {
  final String id;
  final String checkInId;
  final DateTime createdAt;
  final String exercisesJson;
  final String encouragement;
  final String? preMealJson;
  final String? postMealJson;
  final int gymMinutes;
  final int? exerciseCountOverride;
  const WorkoutPlanRow({
    required this.id,
    required this.checkInId,
    required this.createdAt,
    required this.exercisesJson,
    required this.encouragement,
    this.preMealJson,
    this.postMealJson,
    required this.gymMinutes,
    this.exerciseCountOverride,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['check_in_id'] = Variable<String>(checkInId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['exercises_json'] = Variable<String>(exercisesJson);
    map['encouragement'] = Variable<String>(encouragement);
    if (!nullToAbsent || preMealJson != null) {
      map['pre_meal_json'] = Variable<String>(preMealJson);
    }
    if (!nullToAbsent || postMealJson != null) {
      map['post_meal_json'] = Variable<String>(postMealJson);
    }
    map['gym_minutes'] = Variable<int>(gymMinutes);
    if (!nullToAbsent || exerciseCountOverride != null) {
      map['exercise_count_override'] = Variable<int>(exerciseCountOverride);
    }
    return map;
  }

  WorkoutPlansCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlansCompanion(
      id: Value(id),
      checkInId: Value(checkInId),
      createdAt: Value(createdAt),
      exercisesJson: Value(exercisesJson),
      encouragement: Value(encouragement),
      preMealJson: preMealJson == null && nullToAbsent
          ? const Value.absent()
          : Value(preMealJson),
      postMealJson: postMealJson == null && nullToAbsent
          ? const Value.absent()
          : Value(postMealJson),
      gymMinutes: Value(gymMinutes),
      exerciseCountOverride: exerciseCountOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseCountOverride),
    );
  }

  factory WorkoutPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlanRow(
      id: serializer.fromJson<String>(json['id']),
      checkInId: serializer.fromJson<String>(json['checkInId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      exercisesJson: serializer.fromJson<String>(json['exercisesJson']),
      encouragement: serializer.fromJson<String>(json['encouragement']),
      preMealJson: serializer.fromJson<String?>(json['preMealJson']),
      postMealJson: serializer.fromJson<String?>(json['postMealJson']),
      gymMinutes: serializer.fromJson<int>(json['gymMinutes']),
      exerciseCountOverride: serializer.fromJson<int?>(
        json['exerciseCountOverride'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkInId': serializer.toJson<String>(checkInId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'exercisesJson': serializer.toJson<String>(exercisesJson),
      'encouragement': serializer.toJson<String>(encouragement),
      'preMealJson': serializer.toJson<String?>(preMealJson),
      'postMealJson': serializer.toJson<String?>(postMealJson),
      'gymMinutes': serializer.toJson<int>(gymMinutes),
      'exerciseCountOverride': serializer.toJson<int?>(exerciseCountOverride),
    };
  }

  WorkoutPlanRow copyWith({
    String? id,
    String? checkInId,
    DateTime? createdAt,
    String? exercisesJson,
    String? encouragement,
    Value<String?> preMealJson = const Value.absent(),
    Value<String?> postMealJson = const Value.absent(),
    int? gymMinutes,
    Value<int?> exerciseCountOverride = const Value.absent(),
  }) => WorkoutPlanRow(
    id: id ?? this.id,
    checkInId: checkInId ?? this.checkInId,
    createdAt: createdAt ?? this.createdAt,
    exercisesJson: exercisesJson ?? this.exercisesJson,
    encouragement: encouragement ?? this.encouragement,
    preMealJson: preMealJson.present ? preMealJson.value : this.preMealJson,
    postMealJson: postMealJson.present ? postMealJson.value : this.postMealJson,
    gymMinutes: gymMinutes ?? this.gymMinutes,
    exerciseCountOverride: exerciseCountOverride.present
        ? exerciseCountOverride.value
        : this.exerciseCountOverride,
  );
  WorkoutPlanRow copyWithCompanion(WorkoutPlansCompanion data) {
    return WorkoutPlanRow(
      id: data.id.present ? data.id.value : this.id,
      checkInId: data.checkInId.present ? data.checkInId.value : this.checkInId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      exercisesJson: data.exercisesJson.present
          ? data.exercisesJson.value
          : this.exercisesJson,
      encouragement: data.encouragement.present
          ? data.encouragement.value
          : this.encouragement,
      preMealJson: data.preMealJson.present
          ? data.preMealJson.value
          : this.preMealJson,
      postMealJson: data.postMealJson.present
          ? data.postMealJson.value
          : this.postMealJson,
      gymMinutes: data.gymMinutes.present
          ? data.gymMinutes.value
          : this.gymMinutes,
      exerciseCountOverride: data.exerciseCountOverride.present
          ? data.exerciseCountOverride.value
          : this.exerciseCountOverride,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanRow(')
          ..write('id: $id, ')
          ..write('checkInId: $checkInId, ')
          ..write('createdAt: $createdAt, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('encouragement: $encouragement, ')
          ..write('preMealJson: $preMealJson, ')
          ..write('postMealJson: $postMealJson, ')
          ..write('gymMinutes: $gymMinutes, ')
          ..write('exerciseCountOverride: $exerciseCountOverride')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    checkInId,
    createdAt,
    exercisesJson,
    encouragement,
    preMealJson,
    postMealJson,
    gymMinutes,
    exerciseCountOverride,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlanRow &&
          other.id == this.id &&
          other.checkInId == this.checkInId &&
          other.createdAt == this.createdAt &&
          other.exercisesJson == this.exercisesJson &&
          other.encouragement == this.encouragement &&
          other.preMealJson == this.preMealJson &&
          other.postMealJson == this.postMealJson &&
          other.gymMinutes == this.gymMinutes &&
          other.exerciseCountOverride == this.exerciseCountOverride);
}

class WorkoutPlansCompanion extends UpdateCompanion<WorkoutPlanRow> {
  final Value<String> id;
  final Value<String> checkInId;
  final Value<DateTime> createdAt;
  final Value<String> exercisesJson;
  final Value<String> encouragement;
  final Value<String?> preMealJson;
  final Value<String?> postMealJson;
  final Value<int> gymMinutes;
  final Value<int?> exerciseCountOverride;
  final Value<int> rowid;
  const WorkoutPlansCompanion({
    this.id = const Value.absent(),
    this.checkInId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.encouragement = const Value.absent(),
    this.preMealJson = const Value.absent(),
    this.postMealJson = const Value.absent(),
    this.gymMinutes = const Value.absent(),
    this.exerciseCountOverride = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPlansCompanion.insert({
    required String id,
    required String checkInId,
    required DateTime createdAt,
    required String exercisesJson,
    required String encouragement,
    this.preMealJson = const Value.absent(),
    this.postMealJson = const Value.absent(),
    this.gymMinutes = const Value.absent(),
    this.exerciseCountOverride = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checkInId = Value(checkInId),
       createdAt = Value(createdAt),
       exercisesJson = Value(exercisesJson),
       encouragement = Value(encouragement);
  static Insertable<WorkoutPlanRow> custom({
    Expression<String>? id,
    Expression<String>? checkInId,
    Expression<DateTime>? createdAt,
    Expression<String>? exercisesJson,
    Expression<String>? encouragement,
    Expression<String>? preMealJson,
    Expression<String>? postMealJson,
    Expression<int>? gymMinutes,
    Expression<int>? exerciseCountOverride,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkInId != null) 'check_in_id': checkInId,
      if (createdAt != null) 'created_at': createdAt,
      if (exercisesJson != null) 'exercises_json': exercisesJson,
      if (encouragement != null) 'encouragement': encouragement,
      if (preMealJson != null) 'pre_meal_json': preMealJson,
      if (postMealJson != null) 'post_meal_json': postMealJson,
      if (gymMinutes != null) 'gym_minutes': gymMinutes,
      if (exerciseCountOverride != null)
        'exercise_count_override': exerciseCountOverride,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? checkInId,
    Value<DateTime>? createdAt,
    Value<String>? exercisesJson,
    Value<String>? encouragement,
    Value<String?>? preMealJson,
    Value<String?>? postMealJson,
    Value<int>? gymMinutes,
    Value<int?>? exerciseCountOverride,
    Value<int>? rowid,
  }) {
    return WorkoutPlansCompanion(
      id: id ?? this.id,
      checkInId: checkInId ?? this.checkInId,
      createdAt: createdAt ?? this.createdAt,
      exercisesJson: exercisesJson ?? this.exercisesJson,
      encouragement: encouragement ?? this.encouragement,
      preMealJson: preMealJson ?? this.preMealJson,
      postMealJson: postMealJson ?? this.postMealJson,
      gymMinutes: gymMinutes ?? this.gymMinutes,
      exerciseCountOverride:
          exerciseCountOverride ?? this.exerciseCountOverride,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkInId.present) {
      map['check_in_id'] = Variable<String>(checkInId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (exercisesJson.present) {
      map['exercises_json'] = Variable<String>(exercisesJson.value);
    }
    if (encouragement.present) {
      map['encouragement'] = Variable<String>(encouragement.value);
    }
    if (preMealJson.present) {
      map['pre_meal_json'] = Variable<String>(preMealJson.value);
    }
    if (postMealJson.present) {
      map['post_meal_json'] = Variable<String>(postMealJson.value);
    }
    if (gymMinutes.present) {
      map['gym_minutes'] = Variable<int>(gymMinutes.value);
    }
    if (exerciseCountOverride.present) {
      map['exercise_count_override'] = Variable<int>(
        exerciseCountOverride.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlansCompanion(')
          ..write('id: $id, ')
          ..write('checkInId: $checkInId, ')
          ..write('createdAt: $createdAt, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('encouragement: $encouragement, ')
          ..write('preMealJson: $preMealJson, ')
          ..write('postMealJson: $postMealJson, ')
          ..write('gymMinutes: $gymMinutes, ')
          ..write('exerciseCountOverride: $exerciseCountOverride, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _muscleGroupsJsonMeta = const VerificationMeta(
    'muscleGroupsJson',
  );
  @override
  late final GeneratedColumn<String> muscleGroupsJson = GeneratedColumn<String>(
    'muscle_groups_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    startedAt,
    endedAt,
    completed,
    muscleGroupsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('muscle_groups_json')) {
      context.handle(
        _muscleGroupsJsonMeta,
        muscleGroupsJson.isAcceptableOrUnknown(
          data['muscle_groups_json']!,
          _muscleGroupsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      muscleGroupsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_groups_json'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSessionRow extends DataClass
    implements Insertable<WorkoutSessionRow> {
  final String id;
  final String planId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool completed;
  final String muscleGroupsJson;
  const WorkoutSessionRow({
    required this.id,
    required this.planId,
    required this.startedAt,
    this.endedAt,
    required this.completed,
    required this.muscleGroupsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['completed'] = Variable<bool>(completed);
    map['muscle_groups_json'] = Variable<String>(muscleGroupsJson);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      planId: Value(planId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      completed: Value(completed),
      muscleGroupsJson: Value(muscleGroupsJson),
    );
  }

  factory WorkoutSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionRow(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      completed: serializer.fromJson<bool>(json['completed']),
      muscleGroupsJson: serializer.fromJson<String>(json['muscleGroupsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'completed': serializer.toJson<bool>(completed),
      'muscleGroupsJson': serializer.toJson<String>(muscleGroupsJson),
    };
  }

  WorkoutSessionRow copyWith({
    String? id,
    String? planId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    bool? completed,
    String? muscleGroupsJson,
  }) => WorkoutSessionRow(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    completed: completed ?? this.completed,
    muscleGroupsJson: muscleGroupsJson ?? this.muscleGroupsJson,
  );
  WorkoutSessionRow copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSessionRow(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      completed: data.completed.present ? data.completed.value : this.completed,
      muscleGroupsJson: data.muscleGroupsJson.present
          ? data.muscleGroupsJson.value
          : this.muscleGroupsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionRow(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('completed: $completed, ')
          ..write('muscleGroupsJson: $muscleGroupsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planId, startedAt, endedAt, completed, muscleGroupsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionRow &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.completed == this.completed &&
          other.muscleGroupsJson == this.muscleGroupsJson);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSessionRow> {
  final Value<String> id;
  final Value<String> planId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<bool> completed;
  final Value<String> muscleGroupsJson;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.completed = const Value.absent(),
    this.muscleGroupsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String planId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.completed = const Value.absent(),
    this.muscleGroupsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       startedAt = Value(startedAt);
  static Insertable<WorkoutSessionRow> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<bool>? completed,
    Expression<String>? muscleGroupsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (completed != null) 'completed': completed,
      if (muscleGroupsJson != null) 'muscle_groups_json': muscleGroupsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<bool>? completed,
    Value<String>? muscleGroupsJson,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      completed: completed ?? this.completed,
      muscleGroupsJson: muscleGroupsJson ?? this.muscleGroupsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (muscleGroupsJson.present) {
      map['muscle_groups_json'] = Variable<String>(muscleGroupsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('completed: $completed, ')
          ..write('muscleGroupsJson: $muscleGroupsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsCompletedMeta = const VerificationMeta(
    'repsCompleted',
  );
  @override
  late final GeneratedColumn<int> repsCompleted = GeneratedColumn<int>(
    'reps_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<int> rpe = GeneratedColumn<int>(
    'rpe',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    setNumber,
    repsCompleted,
    weightKg,
    rpe,
    completed,
    durationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps_completed')) {
      context.handle(
        _repsCompletedMeta,
        repsCompleted.isAcceptableOrUnknown(
          data['reps_completed']!,
          _repsCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repsCompletedMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    } else if (isInserting) {
      context.missing(_rpeMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      repsCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_completed'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rpe'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLogRow extends DataClass implements Insertable<SetLogRow> {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int setNumber;
  final int repsCompleted;
  final double weightKg;
  final int rpe;
  final bool completed;
  final int durationSeconds;
  const SetLogRow({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.setNumber,
    required this.repsCompleted,
    required this.weightKg,
    required this.rpe,
    required this.completed,
    required this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['reps_completed'] = Variable<int>(repsCompleted);
    map['weight_kg'] = Variable<double>(weightKg);
    map['rpe'] = Variable<int>(rpe);
    map['completed'] = Variable<bool>(completed);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      repsCompleted: Value(repsCompleted),
      weightKg: Value(weightKg),
      rpe: Value(rpe),
      completed: Value(completed),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory SetLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLogRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      repsCompleted: serializer.fromJson<int>(json['repsCompleted']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      rpe: serializer.fromJson<int>(json['rpe']),
      completed: serializer.fromJson<bool>(json['completed']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'repsCompleted': serializer.toJson<int>(repsCompleted),
      'weightKg': serializer.toJson<double>(weightKg),
      'rpe': serializer.toJson<int>(rpe),
      'completed': serializer.toJson<bool>(completed),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  SetLogRow copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    int? setNumber,
    int? repsCompleted,
    double? weightKg,
    int? rpe,
    bool? completed,
    int? durationSeconds,
  }) => SetLogRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    setNumber: setNumber ?? this.setNumber,
    repsCompleted: repsCompleted ?? this.repsCompleted,
    weightKg: weightKg ?? this.weightKg,
    rpe: rpe ?? this.rpe,
    completed: completed ?? this.completed,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );
  SetLogRow copyWithCompanion(SetLogsCompanion data) {
    return SetLogRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      repsCompleted: data.repsCompleted.present
          ? data.repsCompleted.value
          : this.repsCompleted,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      completed: data.completed.present ? data.completed.value : this.completed,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLogRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('repsCompleted: $repsCompleted, ')
          ..write('weightKg: $weightKg, ')
          ..write('rpe: $rpe, ')
          ..write('completed: $completed, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    setNumber,
    repsCompleted,
    weightKg,
    rpe,
    completed,
    durationSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLogRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.repsCompleted == this.repsCompleted &&
          other.weightKg == this.weightKg &&
          other.rpe == this.rpe &&
          other.completed == this.completed &&
          other.durationSeconds == this.durationSeconds);
}

class SetLogsCompanion extends UpdateCompanion<SetLogRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> setNumber;
  final Value<int> repsCompleted;
  final Value<double> weightKg;
  final Value<int> rpe;
  final Value<bool> completed;
  final Value<int> durationSeconds;
  final Value<int> rowid;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.repsCompleted = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.rpe = const Value.absent(),
    this.completed = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetLogsCompanion.insert({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int setNumber,
    required int repsCompleted,
    required double weightKg,
    required int rpe,
    this.completed = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       setNumber = Value(setNumber),
       repsCompleted = Value(repsCompleted),
       weightKg = Value(weightKg),
       rpe = Value(rpe);
  static Insertable<SetLogRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? setNumber,
    Expression<int>? repsCompleted,
    Expression<double>? weightKg,
    Expression<int>? rpe,
    Expression<bool>? completed,
    Expression<int>? durationSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (repsCompleted != null) 'reps_completed': repsCompleted,
      if (weightKg != null) 'weight_kg': weightKg,
      if (rpe != null) 'rpe': rpe,
      if (completed != null) 'completed': completed,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? exerciseId,
    Value<int>? setNumber,
    Value<int>? repsCompleted,
    Value<double>? weightKg,
    Value<int>? rpe,
    Value<bool>? completed,
    Value<int>? durationSeconds,
    Value<int>? rowid,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      repsCompleted: repsCompleted ?? this.repsCompleted,
      weightKg: weightKg ?? this.weightKg,
      rpe: rpe ?? this.rpe,
      completed: completed ?? this.completed,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (repsCompleted.present) {
      map['reps_completed'] = Variable<int>(repsCompleted.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<int>(rpe.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('repsCompleted: $repsCompleted, ')
          ..write('weightKg: $weightKg, ')
          ..write('rpe: $rpe, ')
          ..write('completed: $completed, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyRoutinesTable extends WeeklyRoutines
    with TableInfo<$WeeklyRoutinesTable, WeeklyRoutineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyRoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysJsonMeta = const VerificationMeta(
    'daysJson',
  );
  @override
  late final GeneratedColumn<String> daysJson = GeneratedColumn<String>(
    'days_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deloadUntilMeta = const VerificationMeta(
    'deloadUntil',
  );
  @override
  late final GeneratedColumn<DateTime> deloadUntil = GeneratedColumn<DateTime>(
    'deload_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, daysJson, updatedAt, deloadUntil];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyRoutineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('days_json')) {
      context.handle(
        _daysJsonMeta,
        daysJson.isAcceptableOrUnknown(data['days_json']!, _daysJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_daysJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deload_until')) {
      context.handle(
        _deloadUntilMeta,
        deloadUntil.isAcceptableOrUnknown(
          data['deload_until']!,
          _deloadUntilMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyRoutineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyRoutineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      daysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deloadUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deload_until'],
      ),
    );
  }

  @override
  $WeeklyRoutinesTable createAlias(String alias) {
    return $WeeklyRoutinesTable(attachedDatabase, alias);
  }
}

class WeeklyRoutineRow extends DataClass
    implements Insertable<WeeklyRoutineRow> {
  final String id;
  final String daysJson;
  final DateTime updatedAt;
  final DateTime? deloadUntil;
  const WeeklyRoutineRow({
    required this.id,
    required this.daysJson,
    required this.updatedAt,
    this.deloadUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['days_json'] = Variable<String>(daysJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deloadUntil != null) {
      map['deload_until'] = Variable<DateTime>(deloadUntil);
    }
    return map;
  }

  WeeklyRoutinesCompanion toCompanion(bool nullToAbsent) {
    return WeeklyRoutinesCompanion(
      id: Value(id),
      daysJson: Value(daysJson),
      updatedAt: Value(updatedAt),
      deloadUntil: deloadUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(deloadUntil),
    );
  }

  factory WeeklyRoutineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyRoutineRow(
      id: serializer.fromJson<String>(json['id']),
      daysJson: serializer.fromJson<String>(json['daysJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deloadUntil: serializer.fromJson<DateTime?>(json['deloadUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'daysJson': serializer.toJson<String>(daysJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deloadUntil': serializer.toJson<DateTime?>(deloadUntil),
    };
  }

  WeeklyRoutineRow copyWith({
    String? id,
    String? daysJson,
    DateTime? updatedAt,
    Value<DateTime?> deloadUntil = const Value.absent(),
  }) => WeeklyRoutineRow(
    id: id ?? this.id,
    daysJson: daysJson ?? this.daysJson,
    updatedAt: updatedAt ?? this.updatedAt,
    deloadUntil: deloadUntil.present ? deloadUntil.value : this.deloadUntil,
  );
  WeeklyRoutineRow copyWithCompanion(WeeklyRoutinesCompanion data) {
    return WeeklyRoutineRow(
      id: data.id.present ? data.id.value : this.id,
      daysJson: data.daysJson.present ? data.daysJson.value : this.daysJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deloadUntil: data.deloadUntil.present
          ? data.deloadUntil.value
          : this.deloadUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyRoutineRow(')
          ..write('id: $id, ')
          ..write('daysJson: $daysJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deloadUntil: $deloadUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, daysJson, updatedAt, deloadUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyRoutineRow &&
          other.id == this.id &&
          other.daysJson == this.daysJson &&
          other.updatedAt == this.updatedAt &&
          other.deloadUntil == this.deloadUntil);
}

class WeeklyRoutinesCompanion extends UpdateCompanion<WeeklyRoutineRow> {
  final Value<String> id;
  final Value<String> daysJson;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deloadUntil;
  final Value<int> rowid;
  const WeeklyRoutinesCompanion({
    this.id = const Value.absent(),
    this.daysJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deloadUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyRoutinesCompanion.insert({
    required String id,
    required String daysJson,
    required DateTime updatedAt,
    this.deloadUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       daysJson = Value(daysJson),
       updatedAt = Value(updatedAt);
  static Insertable<WeeklyRoutineRow> custom({
    Expression<String>? id,
    Expression<String>? daysJson,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deloadUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (daysJson != null) 'days_json': daysJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deloadUntil != null) 'deload_until': deloadUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyRoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? daysJson,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deloadUntil,
    Value<int>? rowid,
  }) {
    return WeeklyRoutinesCompanion(
      id: id ?? this.id,
      daysJson: daysJson ?? this.daysJson,
      updatedAt: updatedAt ?? this.updatedAt,
      deloadUntil: deloadUntil ?? this.deloadUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (daysJson.present) {
      map['days_json'] = Variable<String>(daysJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deloadUntil.present) {
      map['deload_until'] = Variable<DateTime>(deloadUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyRoutinesCompanion(')
          ..write('id: $id, ')
          ..write('daysJson: $daysJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deloadUntil: $deloadUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DayLogsTable extends DayLogs with TableInfo<$DayLogsTable, DayLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedKindMeta = const VerificationMeta(
    'plannedKind',
  );
  @override
  late final GeneratedColumn<String> plannedKind = GeneratedColumn<String>(
    'planned_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualKindMeta = const VerificationMeta(
    'actualKind',
  );
  @override
  late final GeneratedColumn<String> actualKind = GeneratedColumn<String>(
    'actual_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    plannedKind,
    actualKind,
    note,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('planned_kind')) {
      context.handle(
        _plannedKindMeta,
        plannedKind.isAcceptableOrUnknown(
          data['planned_kind']!,
          _plannedKindMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedKindMeta);
    }
    if (data.containsKey('actual_kind')) {
      context.handle(
        _actualKindMeta,
        actualKind.isAcceptableOrUnknown(data['actual_kind']!, _actualKindMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      plannedKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_kind'],
      )!,
      actualKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actual_kind'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DayLogsTable createAlias(String alias) {
    return $DayLogsTable(attachedDatabase, alias);
  }
}

class DayLogRow extends DataClass implements Insertable<DayLogRow> {
  final String id;
  final DateTime date;
  final String plannedKind;
  final String? actualKind;
  final String note;
  final DateTime updatedAt;
  const DayLogRow({
    required this.id,
    required this.date,
    required this.plannedKind,
    this.actualKind,
    required this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['planned_kind'] = Variable<String>(plannedKind);
    if (!nullToAbsent || actualKind != null) {
      map['actual_kind'] = Variable<String>(actualKind);
    }
    map['note'] = Variable<String>(note);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DayLogsCompanion toCompanion(bool nullToAbsent) {
    return DayLogsCompanion(
      id: Value(id),
      date: Value(date),
      plannedKind: Value(plannedKind),
      actualKind: actualKind == null && nullToAbsent
          ? const Value.absent()
          : Value(actualKind),
      note: Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory DayLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayLogRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      plannedKind: serializer.fromJson<String>(json['plannedKind']),
      actualKind: serializer.fromJson<String?>(json['actualKind']),
      note: serializer.fromJson<String>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'plannedKind': serializer.toJson<String>(plannedKind),
      'actualKind': serializer.toJson<String?>(actualKind),
      'note': serializer.toJson<String>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DayLogRow copyWith({
    String? id,
    DateTime? date,
    String? plannedKind,
    Value<String?> actualKind = const Value.absent(),
    String? note,
    DateTime? updatedAt,
  }) => DayLogRow(
    id: id ?? this.id,
    date: date ?? this.date,
    plannedKind: plannedKind ?? this.plannedKind,
    actualKind: actualKind.present ? actualKind.value : this.actualKind,
    note: note ?? this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DayLogRow copyWithCompanion(DayLogsCompanion data) {
    return DayLogRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      plannedKind: data.plannedKind.present
          ? data.plannedKind.value
          : this.plannedKind,
      actualKind: data.actualKind.present
          ? data.actualKind.value
          : this.actualKind,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayLogRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('plannedKind: $plannedKind, ')
          ..write('actualKind: $actualKind, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, plannedKind, actualKind, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayLogRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.plannedKind == this.plannedKind &&
          other.actualKind == this.actualKind &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class DayLogsCompanion extends UpdateCompanion<DayLogRow> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> plannedKind;
  final Value<String?> actualKind;
  final Value<String> note;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DayLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.plannedKind = const Value.absent(),
    this.actualKind = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayLogsCompanion.insert({
    required String id,
    required DateTime date,
    required String plannedKind,
    this.actualKind = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       plannedKind = Value(plannedKind),
       updatedAt = Value(updatedAt);
  static Insertable<DayLogRow> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? plannedKind,
    Expression<String>? actualKind,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (plannedKind != null) 'planned_kind': plannedKind,
      if (actualKind != null) 'actual_kind': actualKind,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? plannedKind,
    Value<String?>? actualKind,
    Value<String>? note,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DayLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      plannedKind: plannedKind ?? this.plannedKind,
      actualKind: actualKind ?? this.actualKind,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (plannedKind.present) {
      map['planned_kind'] = Variable<String>(plannedKind.value);
    }
    if (actualKind.present) {
      map['actual_kind'] = Variable<String>(actualKind.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('plannedKind: $plannedKind, ')
          ..write('actualKind: $actualKind, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HydrationLogsTable extends HydrationLogs
    with TableInfo<$HydrationLogsTable, HydrationLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HydrationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _glassesMeta = const VerificationMeta(
    'glasses',
  );
  @override
  late final GeneratedColumn<int> glasses = GeneratedColumn<int>(
    'glasses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _goalGlassesMeta = const VerificationMeta(
    'goalGlasses',
  );
  @override
  late final GeneratedColumn<int> goalGlasses = GeneratedColumn<int>(
    'goal_glasses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    glasses,
    goalGlasses,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hydration_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HydrationLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('glasses')) {
      context.handle(
        _glassesMeta,
        glasses.isAcceptableOrUnknown(data['glasses']!, _glassesMeta),
      );
    }
    if (data.containsKey('goal_glasses')) {
      context.handle(
        _goalGlassesMeta,
        goalGlasses.isAcceptableOrUnknown(
          data['goal_glasses']!,
          _goalGlassesMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HydrationLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HydrationLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      glasses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}glasses'],
      )!,
      goalGlasses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_glasses'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HydrationLogsTable createAlias(String alias) {
    return $HydrationLogsTable(attachedDatabase, alias);
  }
}

class HydrationLogRow extends DataClass implements Insertable<HydrationLogRow> {
  final String id;
  final DateTime date;
  final int glasses;
  final int goalGlasses;
  final DateTime updatedAt;
  const HydrationLogRow({
    required this.id,
    required this.date,
    required this.glasses,
    required this.goalGlasses,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['glasses'] = Variable<int>(glasses);
    map['goal_glasses'] = Variable<int>(goalGlasses);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HydrationLogsCompanion toCompanion(bool nullToAbsent) {
    return HydrationLogsCompanion(
      id: Value(id),
      date: Value(date),
      glasses: Value(glasses),
      goalGlasses: Value(goalGlasses),
      updatedAt: Value(updatedAt),
    );
  }

  factory HydrationLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HydrationLogRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      glasses: serializer.fromJson<int>(json['glasses']),
      goalGlasses: serializer.fromJson<int>(json['goalGlasses']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'glasses': serializer.toJson<int>(glasses),
      'goalGlasses': serializer.toJson<int>(goalGlasses),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HydrationLogRow copyWith({
    String? id,
    DateTime? date,
    int? glasses,
    int? goalGlasses,
    DateTime? updatedAt,
  }) => HydrationLogRow(
    id: id ?? this.id,
    date: date ?? this.date,
    glasses: glasses ?? this.glasses,
    goalGlasses: goalGlasses ?? this.goalGlasses,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HydrationLogRow copyWithCompanion(HydrationLogsCompanion data) {
    return HydrationLogRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      glasses: data.glasses.present ? data.glasses.value : this.glasses,
      goalGlasses: data.goalGlasses.present
          ? data.goalGlasses.value
          : this.goalGlasses,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HydrationLogRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('glasses: $glasses, ')
          ..write('goalGlasses: $goalGlasses, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, glasses, goalGlasses, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HydrationLogRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.glasses == this.glasses &&
          other.goalGlasses == this.goalGlasses &&
          other.updatedAt == this.updatedAt);
}

class HydrationLogsCompanion extends UpdateCompanion<HydrationLogRow> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<int> glasses;
  final Value<int> goalGlasses;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HydrationLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.glasses = const Value.absent(),
    this.goalGlasses = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HydrationLogsCompanion.insert({
    required String id,
    required DateTime date,
    this.glasses = const Value.absent(),
    this.goalGlasses = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<HydrationLogRow> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<int>? glasses,
    Expression<int>? goalGlasses,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (glasses != null) 'glasses': glasses,
      if (goalGlasses != null) 'goal_glasses': goalGlasses,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HydrationLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<int>? glasses,
    Value<int>? goalGlasses,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HydrationLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      glasses: glasses ?? this.glasses,
      goalGlasses: goalGlasses ?? this.goalGlasses,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (glasses.present) {
      map['glasses'] = Variable<int>(glasses.value);
    }
    if (goalGlasses.present) {
      map['goal_glasses'] = Variable<int>(goalGlasses.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HydrationLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('glasses: $glasses, ')
          ..write('goalGlasses: $goalGlasses, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyMetricLogsTable extends BodyMetricLogs
    with TableInfo<$BodyMetricLogsTable, BodyMetricLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMetricLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waistCmMeta = const VerificationMeta(
    'waistCm',
  );
  @override
  late final GeneratedColumn<double> waistCm = GeneratedColumn<double>(
    'waist_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, loggedAt, weightKg, waistCm, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_metric_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMetricLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('waist_cm')) {
      context.handle(
        _waistCmMeta,
        waistCm.isAcceptableOrUnknown(data['waist_cm']!, _waistCmMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMetricLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMetricLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      waistCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waist_cm'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $BodyMetricLogsTable createAlias(String alias) {
    return $BodyMetricLogsTable(attachedDatabase, alias);
  }
}

class BodyMetricLogRow extends DataClass
    implements Insertable<BodyMetricLogRow> {
  final String id;
  final DateTime loggedAt;
  final double weightKg;
  final double? waistCm;
  final String note;
  const BodyMetricLogRow({
    required this.id,
    required this.loggedAt,
    required this.weightKg,
    this.waistCm,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || waistCm != null) {
      map['waist_cm'] = Variable<double>(waistCm);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  BodyMetricLogsCompanion toCompanion(bool nullToAbsent) {
    return BodyMetricLogsCompanion(
      id: Value(id),
      loggedAt: Value(loggedAt),
      weightKg: Value(weightKg),
      waistCm: waistCm == null && nullToAbsent
          ? const Value.absent()
          : Value(waistCm),
      note: Value(note),
    );
  }

  factory BodyMetricLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMetricLogRow(
      id: serializer.fromJson<String>(json['id']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      waistCm: serializer.fromJson<double?>(json['waistCm']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'weightKg': serializer.toJson<double>(weightKg),
      'waistCm': serializer.toJson<double?>(waistCm),
      'note': serializer.toJson<String>(note),
    };
  }

  BodyMetricLogRow copyWith({
    String? id,
    DateTime? loggedAt,
    double? weightKg,
    Value<double?> waistCm = const Value.absent(),
    String? note,
  }) => BodyMetricLogRow(
    id: id ?? this.id,
    loggedAt: loggedAt ?? this.loggedAt,
    weightKg: weightKg ?? this.weightKg,
    waistCm: waistCm.present ? waistCm.value : this.waistCm,
    note: note ?? this.note,
  );
  BodyMetricLogRow copyWithCompanion(BodyMetricLogsCompanion data) {
    return BodyMetricLogRow(
      id: data.id.present ? data.id.value : this.id,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      waistCm: data.waistCm.present ? data.waistCm.value : this.waistCm,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetricLogRow(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('waistCm: $waistCm, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loggedAt, weightKg, waistCm, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMetricLogRow &&
          other.id == this.id &&
          other.loggedAt == this.loggedAt &&
          other.weightKg == this.weightKg &&
          other.waistCm == this.waistCm &&
          other.note == this.note);
}

class BodyMetricLogsCompanion extends UpdateCompanion<BodyMetricLogRow> {
  final Value<String> id;
  final Value<DateTime> loggedAt;
  final Value<double> weightKg;
  final Value<double?> waistCm;
  final Value<String> note;
  final Value<int> rowid;
  const BodyMetricLogsCompanion({
    this.id = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyMetricLogsCompanion.insert({
    required String id,
    required DateTime loggedAt,
    required double weightKg,
    this.waistCm = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       loggedAt = Value(loggedAt),
       weightKg = Value(weightKg);
  static Insertable<BodyMetricLogRow> custom({
    Expression<String>? id,
    Expression<DateTime>? loggedAt,
    Expression<double>? weightKg,
    Expression<double>? waistCm,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (weightKg != null) 'weight_kg': weightKg,
      if (waistCm != null) 'waist_cm': waistCm,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyMetricLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? loggedAt,
    Value<double>? weightKg,
    Value<double?>? waistCm,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return BodyMetricLogsCompanion(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      weightKg: weightKg ?? this.weightKg,
      waistCm: waistCm ?? this.waistCm,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (waistCm.present) {
      map['waist_cm'] = Variable<double>(waistCm.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetricLogsCompanion(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('waistCm: $waistCm, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressPhotosTable extends ProgressPhotos
    with TableInfo<$ProgressPhotosTable, ProgressPhotoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, loggedAt, filePath, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressPhotoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressPhotoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressPhotoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $ProgressPhotosTable createAlias(String alias) {
    return $ProgressPhotosTable(attachedDatabase, alias);
  }
}

class ProgressPhotoRow extends DataClass
    implements Insertable<ProgressPhotoRow> {
  final String id;
  final DateTime loggedAt;
  final String filePath;
  final String note;
  const ProgressPhotoRow({
    required this.id,
    required this.loggedAt,
    required this.filePath,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['file_path'] = Variable<String>(filePath);
    map['note'] = Variable<String>(note);
    return map;
  }

  ProgressPhotosCompanion toCompanion(bool nullToAbsent) {
    return ProgressPhotosCompanion(
      id: Value(id),
      loggedAt: Value(loggedAt),
      filePath: Value(filePath),
      note: Value(note),
    );
  }

  factory ProgressPhotoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressPhotoRow(
      id: serializer.fromJson<String>(json['id']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      filePath: serializer.fromJson<String>(json['filePath']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'filePath': serializer.toJson<String>(filePath),
      'note': serializer.toJson<String>(note),
    };
  }

  ProgressPhotoRow copyWith({
    String? id,
    DateTime? loggedAt,
    String? filePath,
    String? note,
  }) => ProgressPhotoRow(
    id: id ?? this.id,
    loggedAt: loggedAt ?? this.loggedAt,
    filePath: filePath ?? this.filePath,
    note: note ?? this.note,
  );
  ProgressPhotoRow copyWithCompanion(ProgressPhotosCompanion data) {
    return ProgressPhotoRow(
      id: data.id.present ? data.id.value : this.id,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressPhotoRow(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('filePath: $filePath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loggedAt, filePath, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressPhotoRow &&
          other.id == this.id &&
          other.loggedAt == this.loggedAt &&
          other.filePath == this.filePath &&
          other.note == this.note);
}

class ProgressPhotosCompanion extends UpdateCompanion<ProgressPhotoRow> {
  final Value<String> id;
  final Value<DateTime> loggedAt;
  final Value<String> filePath;
  final Value<String> note;
  final Value<int> rowid;
  const ProgressPhotosCompanion({
    this.id = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.filePath = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressPhotosCompanion.insert({
    required String id,
    required DateTime loggedAt,
    required String filePath,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       loggedAt = Value(loggedAt),
       filePath = Value(filePath);
  static Insertable<ProgressPhotoRow> custom({
    Expression<String>? id,
    Expression<DateTime>? loggedAt,
    Expression<String>? filePath,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (filePath != null) 'file_path': filePath,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressPhotosCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? loggedAt,
    Value<String>? filePath,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return ProgressPhotosCompanion(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      filePath: filePath ?? this.filePath,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressPhotosCompanion(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('filePath: $filePath, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $DailyCheckInsTable dailyCheckIns = $DailyCheckInsTable(this);
  late final $WorkoutPlansTable workoutPlans = $WorkoutPlansTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $WeeklyRoutinesTable weeklyRoutines = $WeeklyRoutinesTable(this);
  late final $DayLogsTable dayLogs = $DayLogsTable(this);
  late final $HydrationLogsTable hydrationLogs = $HydrationLogsTable(this);
  late final $BodyMetricLogsTable bodyMetricLogs = $BodyMetricLogsTable(this);
  late final $ProgressPhotosTable progressPhotos = $ProgressPhotosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    dailyCheckIns,
    workoutPlans,
    workoutSessions,
    setLogs,
    weeklyRoutines,
    dayLogs,
    hydrationLogs,
    bodyMetricLogs,
    progressPhotos,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      required String name,
      required String journeyName,
      required double weightKg,
      required double heightCm,
      required int age,
      required String gender,
      required String activityLevel,
      required String primaryGoal,
      required String experience,
      required String equipmentJson,
      required String dietType,
      required String allergiesJson,
      required String themeColorHex,
      required String coachTone,
      required String themePreference,
      Value<bool> onboardingComplete,
      Value<String> cuisineRegion,
      Value<bool> showMacros,
      Value<String> unlockedRecipesJson,
      Value<String> preferredIngredientsJson,
      Value<String> fitnessWhy,
      Value<String> aspiration,
      Value<double?> targetWeightKg,
      Value<int> weeklyTrainingDays,
      Value<DateTime?> birthday,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> journeyName,
      Value<double> weightKg,
      Value<double> heightCm,
      Value<int> age,
      Value<String> gender,
      Value<String> activityLevel,
      Value<String> primaryGoal,
      Value<String> experience,
      Value<String> equipmentJson,
      Value<String> dietType,
      Value<String> allergiesJson,
      Value<String> themeColorHex,
      Value<String> coachTone,
      Value<String> themePreference,
      Value<bool> onboardingComplete,
      Value<String> cuisineRegion,
      Value<bool> showMacros,
      Value<String> unlockedRecipesJson,
      Value<String> preferredIngredientsJson,
      Value<String> fitnessWhy,
      Value<String> aspiration,
      Value<double?> targetWeightKg,
      Value<int> weeklyTrainingDays,
      Value<DateTime?> birthday,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get journeyName => $composableBuilder(
    column: $table.journeyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentJson => $composableBuilder(
    column: $table.equipmentJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietType => $composableBuilder(
    column: $table.dietType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergiesJson => $composableBuilder(
    column: $table.allergiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeColorHex => $composableBuilder(
    column: $table.themeColorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coachTone => $composableBuilder(
    column: $table.coachTone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuisineRegion => $composableBuilder(
    column: $table.cuisineRegion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showMacros => $composableBuilder(
    column: $table.showMacros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unlockedRecipesJson => $composableBuilder(
    column: $table.unlockedRecipesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredIngredientsJson => $composableBuilder(
    column: $table.preferredIngredientsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fitnessWhy => $composableBuilder(
    column: $table.fitnessWhy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aspiration => $composableBuilder(
    column: $table.aspiration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyTrainingDays => $composableBuilder(
    column: $table.weeklyTrainingDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journeyName => $composableBuilder(
    column: $table.journeyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentJson => $composableBuilder(
    column: $table.equipmentJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietType => $composableBuilder(
    column: $table.dietType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergiesJson => $composableBuilder(
    column: $table.allergiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeColorHex => $composableBuilder(
    column: $table.themeColorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coachTone => $composableBuilder(
    column: $table.coachTone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisineRegion => $composableBuilder(
    column: $table.cuisineRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showMacros => $composableBuilder(
    column: $table.showMacros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unlockedRecipesJson => $composableBuilder(
    column: $table.unlockedRecipesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredIngredientsJson => $composableBuilder(
    column: $table.preferredIngredientsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fitnessWhy => $composableBuilder(
    column: $table.fitnessWhy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aspiration => $composableBuilder(
    column: $table.aspiration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyTrainingDays => $composableBuilder(
    column: $table.weeklyTrainingDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get journeyName => $composableBuilder(
    column: $table.journeyName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentJson => $composableBuilder(
    column: $table.equipmentJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietType =>
      $composableBuilder(column: $table.dietType, builder: (column) => column);

  GeneratedColumn<String> get allergiesJson => $composableBuilder(
    column: $table.allergiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeColorHex => $composableBuilder(
    column: $table.themeColorHex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coachTone =>
      $composableBuilder(column: $table.coachTone, builder: (column) => column);

  GeneratedColumn<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cuisineRegion => $composableBuilder(
    column: $table.cuisineRegion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showMacros => $composableBuilder(
    column: $table.showMacros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unlockedRecipesJson => $composableBuilder(
    column: $table.unlockedRecipesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredIngredientsJson => $composableBuilder(
    column: $table.preferredIngredientsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fitnessWhy => $composableBuilder(
    column: $table.fitnessWhy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aspiration => $composableBuilder(
    column: $table.aspiration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyTrainingDays => $composableBuilder(
    column: $table.weeklyTrainingDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfileRow,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfileRow,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileRow>,
          ),
          UserProfileRow,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> journeyName = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<String> primaryGoal = const Value.absent(),
                Value<String> experience = const Value.absent(),
                Value<String> equipmentJson = const Value.absent(),
                Value<String> dietType = const Value.absent(),
                Value<String> allergiesJson = const Value.absent(),
                Value<String> themeColorHex = const Value.absent(),
                Value<String> coachTone = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> cuisineRegion = const Value.absent(),
                Value<bool> showMacros = const Value.absent(),
                Value<String> unlockedRecipesJson = const Value.absent(),
                Value<String> preferredIngredientsJson = const Value.absent(),
                Value<String> fitnessWhy = const Value.absent(),
                Value<String> aspiration = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int> weeklyTrainingDays = const Value.absent(),
                Value<DateTime?> birthday = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                name: name,
                journeyName: journeyName,
                weightKg: weightKg,
                heightCm: heightCm,
                age: age,
                gender: gender,
                activityLevel: activityLevel,
                primaryGoal: primaryGoal,
                experience: experience,
                equipmentJson: equipmentJson,
                dietType: dietType,
                allergiesJson: allergiesJson,
                themeColorHex: themeColorHex,
                coachTone: coachTone,
                themePreference: themePreference,
                onboardingComplete: onboardingComplete,
                cuisineRegion: cuisineRegion,
                showMacros: showMacros,
                unlockedRecipesJson: unlockedRecipesJson,
                preferredIngredientsJson: preferredIngredientsJson,
                fitnessWhy: fitnessWhy,
                aspiration: aspiration,
                targetWeightKg: targetWeightKg,
                weeklyTrainingDays: weeklyTrainingDays,
                birthday: birthday,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String journeyName,
                required double weightKg,
                required double heightCm,
                required int age,
                required String gender,
                required String activityLevel,
                required String primaryGoal,
                required String experience,
                required String equipmentJson,
                required String dietType,
                required String allergiesJson,
                required String themeColorHex,
                required String coachTone,
                required String themePreference,
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> cuisineRegion = const Value.absent(),
                Value<bool> showMacros = const Value.absent(),
                Value<String> unlockedRecipesJson = const Value.absent(),
                Value<String> preferredIngredientsJson = const Value.absent(),
                Value<String> fitnessWhy = const Value.absent(),
                Value<String> aspiration = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int> weeklyTrainingDays = const Value.absent(),
                Value<DateTime?> birthday = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                name: name,
                journeyName: journeyName,
                weightKg: weightKg,
                heightCm: heightCm,
                age: age,
                gender: gender,
                activityLevel: activityLevel,
                primaryGoal: primaryGoal,
                experience: experience,
                equipmentJson: equipmentJson,
                dietType: dietType,
                allergiesJson: allergiesJson,
                themeColorHex: themeColorHex,
                coachTone: coachTone,
                themePreference: themePreference,
                onboardingComplete: onboardingComplete,
                cuisineRegion: cuisineRegion,
                showMacros: showMacros,
                unlockedRecipesJson: unlockedRecipesJson,
                preferredIngredientsJson: preferredIngredientsJson,
                fitnessWhy: fitnessWhy,
                aspiration: aspiration,
                targetWeightKg: targetWeightKg,
                weeklyTrainingDays: weeklyTrainingDays,
                birthday: birthday,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfileRow,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfileRow,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileRow>,
      ),
      UserProfileRow,
      PrefetchHooks Function()
    >;
typedef $$DailyCheckInsTableCreateCompanionBuilder =
    DailyCheckInsCompanion Function({
      required String id,
      required DateTime date,
      required String mood,
      required String intensity,
      required String selectedMusclesJson,
      Value<bool> surpriseMe,
      Value<String> focus,
      Value<String> soreness,
      Value<String> avoidMusclesJson,
      Value<String?> equipmentOverrideJson,
      Value<int> rowid,
    });
typedef $$DailyCheckInsTableUpdateCompanionBuilder =
    DailyCheckInsCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> mood,
      Value<String> intensity,
      Value<String> selectedMusclesJson,
      Value<bool> surpriseMe,
      Value<String> focus,
      Value<String> soreness,
      Value<String> avoidMusclesJson,
      Value<String?> equipmentOverrideJson,
      Value<int> rowid,
    });

class $$DailyCheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyCheckInsTable> {
  $$DailyCheckInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedMusclesJson => $composableBuilder(
    column: $table.selectedMusclesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get surpriseMe => $composableBuilder(
    column: $table.surpriseMe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soreness => $composableBuilder(
    column: $table.soreness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avoidMusclesJson => $composableBuilder(
    column: $table.avoidMusclesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentOverrideJson => $composableBuilder(
    column: $table.equipmentOverrideJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyCheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyCheckInsTable> {
  $$DailyCheckInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedMusclesJson => $composableBuilder(
    column: $table.selectedMusclesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get surpriseMe => $composableBuilder(
    column: $table.surpriseMe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soreness => $composableBuilder(
    column: $table.soreness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avoidMusclesJson => $composableBuilder(
    column: $table.avoidMusclesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentOverrideJson => $composableBuilder(
    column: $table.equipmentOverrideJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyCheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyCheckInsTable> {
  $$DailyCheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get selectedMusclesJson => $composableBuilder(
    column: $table.selectedMusclesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get surpriseMe => $composableBuilder(
    column: $table.surpriseMe,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<String> get soreness =>
      $composableBuilder(column: $table.soreness, builder: (column) => column);

  GeneratedColumn<String> get avoidMusclesJson => $composableBuilder(
    column: $table.avoidMusclesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentOverrideJson => $composableBuilder(
    column: $table.equipmentOverrideJson,
    builder: (column) => column,
  );
}

class $$DailyCheckInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyCheckInsTable,
          DailyCheckInRow,
          $$DailyCheckInsTableFilterComposer,
          $$DailyCheckInsTableOrderingComposer,
          $$DailyCheckInsTableAnnotationComposer,
          $$DailyCheckInsTableCreateCompanionBuilder,
          $$DailyCheckInsTableUpdateCompanionBuilder,
          (
            DailyCheckInRow,
            BaseReferences<_$AppDatabase, $DailyCheckInsTable, DailyCheckInRow>,
          ),
          DailyCheckInRow,
          PrefetchHooks Function()
        > {
  $$DailyCheckInsTableTableManager(_$AppDatabase db, $DailyCheckInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyCheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyCheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyCheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<String> intensity = const Value.absent(),
                Value<String> selectedMusclesJson = const Value.absent(),
                Value<bool> surpriseMe = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<String> soreness = const Value.absent(),
                Value<String> avoidMusclesJson = const Value.absent(),
                Value<String?> equipmentOverrideJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCheckInsCompanion(
                id: id,
                date: date,
                mood: mood,
                intensity: intensity,
                selectedMusclesJson: selectedMusclesJson,
                surpriseMe: surpriseMe,
                focus: focus,
                soreness: soreness,
                avoidMusclesJson: avoidMusclesJson,
                equipmentOverrideJson: equipmentOverrideJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String mood,
                required String intensity,
                required String selectedMusclesJson,
                Value<bool> surpriseMe = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<String> soreness = const Value.absent(),
                Value<String> avoidMusclesJson = const Value.absent(),
                Value<String?> equipmentOverrideJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCheckInsCompanion.insert(
                id: id,
                date: date,
                mood: mood,
                intensity: intensity,
                selectedMusclesJson: selectedMusclesJson,
                surpriseMe: surpriseMe,
                focus: focus,
                soreness: soreness,
                avoidMusclesJson: avoidMusclesJson,
                equipmentOverrideJson: equipmentOverrideJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyCheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyCheckInsTable,
      DailyCheckInRow,
      $$DailyCheckInsTableFilterComposer,
      $$DailyCheckInsTableOrderingComposer,
      $$DailyCheckInsTableAnnotationComposer,
      $$DailyCheckInsTableCreateCompanionBuilder,
      $$DailyCheckInsTableUpdateCompanionBuilder,
      (
        DailyCheckInRow,
        BaseReferences<_$AppDatabase, $DailyCheckInsTable, DailyCheckInRow>,
      ),
      DailyCheckInRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutPlansTableCreateCompanionBuilder =
    WorkoutPlansCompanion Function({
      required String id,
      required String checkInId,
      required DateTime createdAt,
      required String exercisesJson,
      required String encouragement,
      Value<String?> preMealJson,
      Value<String?> postMealJson,
      Value<int> gymMinutes,
      Value<int?> exerciseCountOverride,
      Value<int> rowid,
    });
typedef $$WorkoutPlansTableUpdateCompanionBuilder =
    WorkoutPlansCompanion Function({
      Value<String> id,
      Value<String> checkInId,
      Value<DateTime> createdAt,
      Value<String> exercisesJson,
      Value<String> encouragement,
      Value<String?> preMealJson,
      Value<String?> postMealJson,
      Value<int> gymMinutes,
      Value<int?> exerciseCountOverride,
      Value<int> rowid,
    });

class $$WorkoutPlansTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkInId => $composableBuilder(
    column: $table.checkInId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exercisesJson => $composableBuilder(
    column: $table.exercisesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encouragement => $composableBuilder(
    column: $table.encouragement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preMealJson => $composableBuilder(
    column: $table.preMealJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postMealJson => $composableBuilder(
    column: $table.postMealJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gymMinutes => $composableBuilder(
    column: $table.gymMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseCountOverride => $composableBuilder(
    column: $table.exerciseCountOverride,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkInId => $composableBuilder(
    column: $table.checkInId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exercisesJson => $composableBuilder(
    column: $table.exercisesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encouragement => $composableBuilder(
    column: $table.encouragement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preMealJson => $composableBuilder(
    column: $table.preMealJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postMealJson => $composableBuilder(
    column: $table.postMealJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gymMinutes => $composableBuilder(
    column: $table.gymMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseCountOverride => $composableBuilder(
    column: $table.exerciseCountOverride,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get checkInId =>
      $composableBuilder(column: $table.checkInId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get exercisesJson => $composableBuilder(
    column: $table.exercisesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encouragement => $composableBuilder(
    column: $table.encouragement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preMealJson => $composableBuilder(
    column: $table.preMealJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postMealJson => $composableBuilder(
    column: $table.postMealJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gymMinutes => $composableBuilder(
    column: $table.gymMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseCountOverride => $composableBuilder(
    column: $table.exerciseCountOverride,
    builder: (column) => column,
  );
}

class $$WorkoutPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutPlansTable,
          WorkoutPlanRow,
          $$WorkoutPlansTableFilterComposer,
          $$WorkoutPlansTableOrderingComposer,
          $$WorkoutPlansTableAnnotationComposer,
          $$WorkoutPlansTableCreateCompanionBuilder,
          $$WorkoutPlansTableUpdateCompanionBuilder,
          (
            WorkoutPlanRow,
            BaseReferences<_$AppDatabase, $WorkoutPlansTable, WorkoutPlanRow>,
          ),
          WorkoutPlanRow,
          PrefetchHooks Function()
        > {
  $$WorkoutPlansTableTableManager(_$AppDatabase db, $WorkoutPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checkInId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> exercisesJson = const Value.absent(),
                Value<String> encouragement = const Value.absent(),
                Value<String?> preMealJson = const Value.absent(),
                Value<String?> postMealJson = const Value.absent(),
                Value<int> gymMinutes = const Value.absent(),
                Value<int?> exerciseCountOverride = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion(
                id: id,
                checkInId: checkInId,
                createdAt: createdAt,
                exercisesJson: exercisesJson,
                encouragement: encouragement,
                preMealJson: preMealJson,
                postMealJson: postMealJson,
                gymMinutes: gymMinutes,
                exerciseCountOverride: exerciseCountOverride,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checkInId,
                required DateTime createdAt,
                required String exercisesJson,
                required String encouragement,
                Value<String?> preMealJson = const Value.absent(),
                Value<String?> postMealJson = const Value.absent(),
                Value<int> gymMinutes = const Value.absent(),
                Value<int?> exerciseCountOverride = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion.insert(
                id: id,
                checkInId: checkInId,
                createdAt: createdAt,
                exercisesJson: exercisesJson,
                encouragement: encouragement,
                preMealJson: preMealJson,
                postMealJson: postMealJson,
                gymMinutes: gymMinutes,
                exerciseCountOverride: exerciseCountOverride,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutPlansTable,
      WorkoutPlanRow,
      $$WorkoutPlansTableFilterComposer,
      $$WorkoutPlansTableOrderingComposer,
      $$WorkoutPlansTableAnnotationComposer,
      $$WorkoutPlansTableCreateCompanionBuilder,
      $$WorkoutPlansTableUpdateCompanionBuilder,
      (
        WorkoutPlanRow,
        BaseReferences<_$AppDatabase, $WorkoutPlansTable, WorkoutPlanRow>,
      ),
      WorkoutPlanRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required String planId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<bool> completed,
      Value<String> muscleGroupsJson,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> planId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<bool> completed,
      Value<String> muscleGroupsJson,
      Value<int> rowid,
    });

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroupsJson => $composableBuilder(
    column: $table.muscleGroupsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroupsJson => $composableBuilder(
    column: $table.muscleGroupsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get muscleGroupsJson => $composableBuilder(
    column: $table.muscleGroupsJson,
    builder: (column) => column,
  );
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSessionRow,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (
            WorkoutSessionRow,
            BaseReferences<
              _$AppDatabase,
              $WorkoutSessionsTable,
              WorkoutSessionRow
            >,
          ),
          WorkoutSessionRow,
          PrefetchHooks Function()
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> muscleGroupsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                planId: planId,
                startedAt: startedAt,
                endedAt: endedAt,
                completed: completed,
                muscleGroupsJson: muscleGroupsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> muscleGroupsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                planId: planId,
                startedAt: startedAt,
                endedAt: endedAt,
                completed: completed,
                muscleGroupsJson: muscleGroupsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSessionRow,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (
        WorkoutSessionRow,
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSessionRow>,
      ),
      WorkoutSessionRow,
      PrefetchHooks Function()
    >;
typedef $$SetLogsTableCreateCompanionBuilder =
    SetLogsCompanion Function({
      required String id,
      required String sessionId,
      required String exerciseId,
      required int setNumber,
      required int repsCompleted,
      required double weightKg,
      required int rpe,
      Value<bool> completed,
      Value<int> durationSeconds,
      Value<int> rowid,
    });
typedef $$SetLogsTableUpdateCompanionBuilder =
    SetLogsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> exerciseId,
      Value<int> setNumber,
      Value<int> repsCompleted,
      Value<double> weightKg,
      Value<int> rpe,
      Value<bool> completed,
      Value<int> durationSeconds,
      Value<int> rowid,
    });

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsCompleted => $composableBuilder(
    column: $table.repsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsCompleted => $composableBuilder(
    column: $table.repsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get repsCompleted => $composableBuilder(
    column: $table.repsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLogRow,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLogRow, BaseReferences<_$AppDatabase, $SetLogsTable, SetLogRow>),
          SetLogRow,
          PrefetchHooks Function()
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int> repsCompleted = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> rpe = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                repsCompleted: repsCompleted,
                weightKg: weightKg,
                rpe: rpe,
                completed: completed,
                durationSeconds: durationSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String exerciseId,
                required int setNumber,
                required int repsCompleted,
                required double weightKg,
                required int rpe,
                Value<bool> completed = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                repsCompleted: repsCompleted,
                weightKg: weightKg,
                rpe: rpe,
                completed: completed,
                durationSeconds: durationSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLogRow,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLogRow, BaseReferences<_$AppDatabase, $SetLogsTable, SetLogRow>),
      SetLogRow,
      PrefetchHooks Function()
    >;
typedef $$WeeklyRoutinesTableCreateCompanionBuilder =
    WeeklyRoutinesCompanion Function({
      required String id,
      required String daysJson,
      required DateTime updatedAt,
      Value<DateTime?> deloadUntil,
      Value<int> rowid,
    });
typedef $$WeeklyRoutinesTableUpdateCompanionBuilder =
    WeeklyRoutinesCompanion Function({
      Value<String> id,
      Value<String> daysJson,
      Value<DateTime> updatedAt,
      Value<DateTime?> deloadUntil,
      Value<int> rowid,
    });

class $$WeeklyRoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyRoutinesTable> {
  $$WeeklyRoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get daysJson => $composableBuilder(
    column: $table.daysJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deloadUntil => $composableBuilder(
    column: $table.deloadUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyRoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyRoutinesTable> {
  $$WeeklyRoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysJson => $composableBuilder(
    column: $table.daysJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deloadUntil => $composableBuilder(
    column: $table.deloadUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyRoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyRoutinesTable> {
  $$WeeklyRoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get daysJson =>
      $composableBuilder(column: $table.daysJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deloadUntil => $composableBuilder(
    column: $table.deloadUntil,
    builder: (column) => column,
  );
}

class $$WeeklyRoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyRoutinesTable,
          WeeklyRoutineRow,
          $$WeeklyRoutinesTableFilterComposer,
          $$WeeklyRoutinesTableOrderingComposer,
          $$WeeklyRoutinesTableAnnotationComposer,
          $$WeeklyRoutinesTableCreateCompanionBuilder,
          $$WeeklyRoutinesTableUpdateCompanionBuilder,
          (
            WeeklyRoutineRow,
            BaseReferences<
              _$AppDatabase,
              $WeeklyRoutinesTable,
              WeeklyRoutineRow
            >,
          ),
          WeeklyRoutineRow,
          PrefetchHooks Function()
        > {
  $$WeeklyRoutinesTableTableManager(
    _$AppDatabase db,
    $WeeklyRoutinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyRoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyRoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyRoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> daysJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deloadUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyRoutinesCompanion(
                id: id,
                daysJson: daysJson,
                updatedAt: updatedAt,
                deloadUntil: deloadUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String daysJson,
                required DateTime updatedAt,
                Value<DateTime?> deloadUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyRoutinesCompanion.insert(
                id: id,
                daysJson: daysJson,
                updatedAt: updatedAt,
                deloadUntil: deloadUntil,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyRoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyRoutinesTable,
      WeeklyRoutineRow,
      $$WeeklyRoutinesTableFilterComposer,
      $$WeeklyRoutinesTableOrderingComposer,
      $$WeeklyRoutinesTableAnnotationComposer,
      $$WeeklyRoutinesTableCreateCompanionBuilder,
      $$WeeklyRoutinesTableUpdateCompanionBuilder,
      (
        WeeklyRoutineRow,
        BaseReferences<_$AppDatabase, $WeeklyRoutinesTable, WeeklyRoutineRow>,
      ),
      WeeklyRoutineRow,
      PrefetchHooks Function()
    >;
typedef $$DayLogsTableCreateCompanionBuilder =
    DayLogsCompanion Function({
      required String id,
      required DateTime date,
      required String plannedKind,
      Value<String?> actualKind,
      Value<String> note,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DayLogsTableUpdateCompanionBuilder =
    DayLogsCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> plannedKind,
      Value<String?> actualKind,
      Value<String> note,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DayLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plannedKind => $composableBuilder(
    column: $table.plannedKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actualKind => $composableBuilder(
    column: $table.actualKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plannedKind => $composableBuilder(
    column: $table.plannedKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actualKind => $composableBuilder(
    column: $table.actualKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get plannedKind => $composableBuilder(
    column: $table.plannedKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actualKind => $composableBuilder(
    column: $table.actualKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DayLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayLogsTable,
          DayLogRow,
          $$DayLogsTableFilterComposer,
          $$DayLogsTableOrderingComposer,
          $$DayLogsTableAnnotationComposer,
          $$DayLogsTableCreateCompanionBuilder,
          $$DayLogsTableUpdateCompanionBuilder,
          (DayLogRow, BaseReferences<_$AppDatabase, $DayLogsTable, DayLogRow>),
          DayLogRow,
          PrefetchHooks Function()
        > {
  $$DayLogsTableTableManager(_$AppDatabase db, $DayLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> plannedKind = const Value.absent(),
                Value<String?> actualKind = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayLogsCompanion(
                id: id,
                date: date,
                plannedKind: plannedKind,
                actualKind: actualKind,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String plannedKind,
                Value<String?> actualKind = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DayLogsCompanion.insert(
                id: id,
                date: date,
                plannedKind: plannedKind,
                actualKind: actualKind,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayLogsTable,
      DayLogRow,
      $$DayLogsTableFilterComposer,
      $$DayLogsTableOrderingComposer,
      $$DayLogsTableAnnotationComposer,
      $$DayLogsTableCreateCompanionBuilder,
      $$DayLogsTableUpdateCompanionBuilder,
      (DayLogRow, BaseReferences<_$AppDatabase, $DayLogsTable, DayLogRow>),
      DayLogRow,
      PrefetchHooks Function()
    >;
typedef $$HydrationLogsTableCreateCompanionBuilder =
    HydrationLogsCompanion Function({
      required String id,
      required DateTime date,
      Value<int> glasses,
      Value<int> goalGlasses,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HydrationLogsTableUpdateCompanionBuilder =
    HydrationLogsCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<int> glasses,
      Value<int> goalGlasses,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$HydrationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HydrationLogsTable> {
  $$HydrationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get glasses => $composableBuilder(
    column: $table.glasses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalGlasses => $composableBuilder(
    column: $table.goalGlasses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HydrationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HydrationLogsTable> {
  $$HydrationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get glasses => $composableBuilder(
    column: $table.glasses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalGlasses => $composableBuilder(
    column: $table.goalGlasses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HydrationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HydrationLogsTable> {
  $$HydrationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get glasses =>
      $composableBuilder(column: $table.glasses, builder: (column) => column);

  GeneratedColumn<int> get goalGlasses => $composableBuilder(
    column: $table.goalGlasses,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HydrationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HydrationLogsTable,
          HydrationLogRow,
          $$HydrationLogsTableFilterComposer,
          $$HydrationLogsTableOrderingComposer,
          $$HydrationLogsTableAnnotationComposer,
          $$HydrationLogsTableCreateCompanionBuilder,
          $$HydrationLogsTableUpdateCompanionBuilder,
          (
            HydrationLogRow,
            BaseReferences<_$AppDatabase, $HydrationLogsTable, HydrationLogRow>,
          ),
          HydrationLogRow,
          PrefetchHooks Function()
        > {
  $$HydrationLogsTableTableManager(_$AppDatabase db, $HydrationLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HydrationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HydrationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HydrationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> glasses = const Value.absent(),
                Value<int> goalGlasses = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HydrationLogsCompanion(
                id: id,
                date: date,
                glasses: glasses,
                goalGlasses: goalGlasses,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                Value<int> glasses = const Value.absent(),
                Value<int> goalGlasses = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HydrationLogsCompanion.insert(
                id: id,
                date: date,
                glasses: glasses,
                goalGlasses: goalGlasses,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HydrationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HydrationLogsTable,
      HydrationLogRow,
      $$HydrationLogsTableFilterComposer,
      $$HydrationLogsTableOrderingComposer,
      $$HydrationLogsTableAnnotationComposer,
      $$HydrationLogsTableCreateCompanionBuilder,
      $$HydrationLogsTableUpdateCompanionBuilder,
      (
        HydrationLogRow,
        BaseReferences<_$AppDatabase, $HydrationLogsTable, HydrationLogRow>,
      ),
      HydrationLogRow,
      PrefetchHooks Function()
    >;
typedef $$BodyMetricLogsTableCreateCompanionBuilder =
    BodyMetricLogsCompanion Function({
      required String id,
      required DateTime loggedAt,
      required double weightKg,
      Value<double?> waistCm,
      Value<String> note,
      Value<int> rowid,
    });
typedef $$BodyMetricLogsTableUpdateCompanionBuilder =
    BodyMetricLogsCompanion Function({
      Value<String> id,
      Value<DateTime> loggedAt,
      Value<double> weightKg,
      Value<double?> waistCm,
      Value<String> note,
      Value<int> rowid,
    });

class $$BodyMetricLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMetricLogsTable> {
  $$BodyMetricLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMetricLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMetricLogsTable> {
  $$BodyMetricLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMetricLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMetricLogsTable> {
  $$BodyMetricLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$BodyMetricLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMetricLogsTable,
          BodyMetricLogRow,
          $$BodyMetricLogsTableFilterComposer,
          $$BodyMetricLogsTableOrderingComposer,
          $$BodyMetricLogsTableAnnotationComposer,
          $$BodyMetricLogsTableCreateCompanionBuilder,
          $$BodyMetricLogsTableUpdateCompanionBuilder,
          (
            BodyMetricLogRow,
            BaseReferences<
              _$AppDatabase,
              $BodyMetricLogsTable,
              BodyMetricLogRow
            >,
          ),
          BodyMetricLogRow,
          PrefetchHooks Function()
        > {
  $$BodyMetricLogsTableTableManager(
    _$AppDatabase db,
    $BodyMetricLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMetricLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMetricLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMetricLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMetricLogsCompanion(
                id: id,
                loggedAt: loggedAt,
                weightKg: weightKg,
                waistCm: waistCm,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime loggedAt,
                required double weightKg,
                Value<double?> waistCm = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMetricLogsCompanion.insert(
                id: id,
                loggedAt: loggedAt,
                weightKg: weightKg,
                waistCm: waistCm,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMetricLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMetricLogsTable,
      BodyMetricLogRow,
      $$BodyMetricLogsTableFilterComposer,
      $$BodyMetricLogsTableOrderingComposer,
      $$BodyMetricLogsTableAnnotationComposer,
      $$BodyMetricLogsTableCreateCompanionBuilder,
      $$BodyMetricLogsTableUpdateCompanionBuilder,
      (
        BodyMetricLogRow,
        BaseReferences<_$AppDatabase, $BodyMetricLogsTable, BodyMetricLogRow>,
      ),
      BodyMetricLogRow,
      PrefetchHooks Function()
    >;
typedef $$ProgressPhotosTableCreateCompanionBuilder =
    ProgressPhotosCompanion Function({
      required String id,
      required DateTime loggedAt,
      required String filePath,
      Value<String> note,
      Value<int> rowid,
    });
typedef $$ProgressPhotosTableUpdateCompanionBuilder =
    ProgressPhotosCompanion Function({
      Value<String> id,
      Value<DateTime> loggedAt,
      Value<String> filePath,
      Value<String> note,
      Value<int> rowid,
    });

class $$ProgressPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$ProgressPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressPhotosTable,
          ProgressPhotoRow,
          $$ProgressPhotosTableFilterComposer,
          $$ProgressPhotosTableOrderingComposer,
          $$ProgressPhotosTableAnnotationComposer,
          $$ProgressPhotosTableCreateCompanionBuilder,
          $$ProgressPhotosTableUpdateCompanionBuilder,
          (
            ProgressPhotoRow,
            BaseReferences<
              _$AppDatabase,
              $ProgressPhotosTable,
              ProgressPhotoRow
            >,
          ),
          ProgressPhotoRow,
          PrefetchHooks Function()
        > {
  $$ProgressPhotosTableTableManager(
    _$AppDatabase db,
    $ProgressPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressPhotosCompanion(
                id: id,
                loggedAt: loggedAt,
                filePath: filePath,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime loggedAt,
                required String filePath,
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressPhotosCompanion.insert(
                id: id,
                loggedAt: loggedAt,
                filePath: filePath,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressPhotosTable,
      ProgressPhotoRow,
      $$ProgressPhotosTableFilterComposer,
      $$ProgressPhotosTableOrderingComposer,
      $$ProgressPhotosTableAnnotationComposer,
      $$ProgressPhotosTableCreateCompanionBuilder,
      $$ProgressPhotosTableUpdateCompanionBuilder,
      (
        ProgressPhotoRow,
        BaseReferences<_$AppDatabase, $ProgressPhotosTable, ProgressPhotoRow>,
      ),
      ProgressPhotoRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$DailyCheckInsTableTableManager get dailyCheckIns =>
      $$DailyCheckInsTableTableManager(_db, _db.dailyCheckIns);
  $$WorkoutPlansTableTableManager get workoutPlans =>
      $$WorkoutPlansTableTableManager(_db, _db.workoutPlans);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$WeeklyRoutinesTableTableManager get weeklyRoutines =>
      $$WeeklyRoutinesTableTableManager(_db, _db.weeklyRoutines);
  $$DayLogsTableTableManager get dayLogs =>
      $$DayLogsTableTableManager(_db, _db.dayLogs);
  $$HydrationLogsTableTableManager get hydrationLogs =>
      $$HydrationLogsTableTableManager(_db, _db.hydrationLogs);
  $$BodyMetricLogsTableTableManager get bodyMetricLogs =>
      $$BodyMetricLogsTableTableManager(_db, _db.bodyMetricLogs);
  $$ProgressPhotosTableTableManager get progressPhotos =>
      $$ProgressPhotosTableTableManager(_db, _db.progressPhotos);
}
