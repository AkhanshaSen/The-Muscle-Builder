import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../db/app_database.dart';
import 'cloud_sync_port.dart';

class ProfileRepository {
  ProfileRepository(this._db, this._sync);

  final AppDatabase _db;
  final CloudSyncPort _sync;
  final _uuid = const Uuid();

  Stream<UserProfile?> watchProfile() {
    return (_db.select(_db.userProfiles)..limit(1)).watch().map((rows) {
      if (rows.isEmpty) return null;
      return _mapProfile(rows.first);
    });
  }

  Future<UserProfile?> getProfile() async {
    final row =
        await (_db.select(_db.userProfiles)..limit(1)).getSingleOrNull();
    return row == null ? null : _mapProfile(row);
  }

  Future<UserProfile> saveProfile(UserProfile profile) async {
    final companion = UserProfilesCompanion(
      id: Value(profile.id),
      name: Value(profile.name),
      journeyName: Value(profile.journeyName),
      weightKg: Value(profile.weightKg),
      heightCm: Value(profile.heightCm),
      age: Value(profile.age),
      gender: Value(profile.gender.name),
      activityLevel: Value(profile.activityLevel.name),
      primaryGoal: Value(profile.primaryGoal.name),
      experience: Value(profile.experience.name),
      equipmentJson: Value(
        encodeStringList(profile.equipment.map((e) => e.name).toList()),
      ),
      dietType: Value(profile.dietType.name),
      allergiesJson: Value(
        encodeStringList(profile.allergies.map((e) => e.name).toList()),
      ),
      themeColorHex: Value(profile.themeColorHex),
      coachTone: Value(profile.coachTone.name),
      themePreference: Value(profile.themePreference.name),
      onboardingComplete: Value(profile.onboardingComplete),
      cuisineRegion: Value(profile.cuisineRegion.name),
      showMacros: Value(profile.showMacros),
      unlockedRecipesJson: Value(encodeStringList(profile.unlockedRecipeIds)),
      preferredIngredientsJson:
          Value(encodeStringList(profile.preferredIngredients)),
      fitnessWhy: Value(profile.fitnessWhy),
      aspiration: Value(profile.aspiration),
      targetWeightKg: Value(profile.targetWeightKg),
      weeklyTrainingDays: Value(profile.weeklyTrainingDays),
    );
    await _db.into(_db.userProfiles).insertOnConflictUpdate(companion);
    await _sync.syncProfile({'id': profile.id, 'name': profile.name});
    return profile;
  }

  Future<UserProfile> createDefaultDraft() async {
    final profile = UserProfile(
      id: _uuid.v4(),
      name: '',
      journeyName: 'My Journey',
      weightKg: 70,
      heightCm: 170,
      age: 25,
      gender: Gender.preferNotToSay,
      activityLevel: ActivityLevel.moderatelyActive,
      primaryGoal: PrimaryGoal.consistency,
      experience: ExperienceLevel.beginner,
      equipment: const [Equipment.bodyweight],
      dietType: DietType.vegetarian,
      allergies: const [],
      themeColorHex: '#FF6B35',
      coachTone: CoachTone.friendly,
      themePreference: ThemePreference.dark,
      onboardingComplete: false,
    );
    return saveProfile(profile);
  }

  UserProfile _mapProfile(UserProfileRow row) {
    return UserProfile(
      id: row.id,
      name: row.name,
      journeyName: row.journeyName,
      weightKg: row.weightKg,
      heightCm: row.heightCm,
      age: row.age,
      gender: Gender.values.byName(row.gender),
      activityLevel: ActivityLevel.values.byName(row.activityLevel),
      primaryGoal: PrimaryGoal.values.byName(row.primaryGoal),
      experience: ExperienceLevel.values.byName(row.experience),
      equipment: decodeStringList(row.equipmentJson)
          .map(Equipment.values.byName)
          .toList(),
      dietType: DietType.values.byName(row.dietType),
      allergies: decodeStringList(row.allergiesJson)
          .map(Allergy.values.byName)
          .toList(),
      themeColorHex: row.themeColorHex,
      coachTone: CoachTone.values.byName(row.coachTone),
      themePreference: ThemePreference.values.byName(row.themePreference),
      onboardingComplete: row.onboardingComplete,
      cuisineRegion: CuisineRegion.values.byName(row.cuisineRegion),
      showMacros: row.showMacros,
      unlockedRecipeIds: decodeStringList(row.unlockedRecipesJson),
      preferredIngredients: decodeStringList(row.preferredIngredientsJson),
      fitnessWhy: row.fitnessWhy,
      aspiration: row.aspiration,
      targetWeightKg: row.targetWeightKg,
      weeklyTrainingDays: row.weeklyTrainingDays,
    );
  }
}
