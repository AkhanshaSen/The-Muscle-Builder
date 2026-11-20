import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/models/models.dart';
import 'reference_data_unavailable.dart';

class SeedRepository {
  /// [client] is optional so unit tests can use asset fallback only.
  SeedRepository([this._client]);

  final SupabaseClient? _client;

  List<Exercise>? _exercises;
  List<MealSuggestion>? _meals;

  void clearCache() {
    _exercises = null;
    _meals = null;
  }

  Future<List<Exercise>> loadExercises({bool forceReload = false}) async {
    if (forceReload) {
      _exercises = null;
    }
    if (_exercises != null) return _exercises!;

    if (AppConstants.hasSupabaseKey) {
      _exercises = await _loadExercisesFromSupabase();
      return _exercises!;
    }

    return _loadExercisesFromAssets();
  }

  Future<List<MealSuggestion>> loadMeals({bool forceReload = false}) async {
    if (forceReload) {
      _meals = null;
    }
    if (_meals != null) return _meals!;

    if (AppConstants.hasSupabaseKey) {
      _meals = await _loadMealsFromSupabase();
      return _meals!;
    }

    return _loadMealsFromAssets();
  }

  Future<List<Exercise>> _loadExercisesFromSupabase() async {
    final client = _client;
    if (client == null) {
      throw ReferenceDataUnavailableException(
        'SUPABASE_ANON_KEY is set but Supabase client is not initialized.',
      );
    }
    try {
      final rows =
          await client.from('exercises').select().eq('is_deleted', false);
      final list = rows as List<dynamic>;
      if (list.isEmpty) {
        throw ReferenceDataUnavailableException(
          'exercises table is empty — run supabase/seed/exercises_upsert_full.sql',
        );
      }
      return list
          .map(
            (e) => Exercise.fromJson(
              _rowToExerciseJson(Map<String, dynamic>.from(e as Map)),
            ),
          )
          .toList();
    } catch (e) {
      if (e is ReferenceDataUnavailableException) rethrow;
      throw ReferenceDataUnavailableException(
        'Failed to load exercises from Supabase',
        cause: e,
      );
    }
  }

  Future<List<MealSuggestion>> _loadMealsFromSupabase() async {
    final client = _client;
    if (client == null) {
      throw ReferenceDataUnavailableException(
        'SUPABASE_ANON_KEY is set but Supabase client is not initialized.',
      );
    }
    try {
      final rows = await client.from('meals').select().eq('is_deleted', false);
      final list = rows as List<dynamic>;
      if (list.isEmpty) {
        throw ReferenceDataUnavailableException(
          'meals table is empty — run supabase/seed/meals_upsert.sql',
        );
      }
      return list
          .map(
            (e) => MealSuggestion.fromJson(
              _rowToMealJson(Map<String, dynamic>.from(e as Map)),
            ),
          )
          .toList();
    } catch (e) {
      if (e is ReferenceDataUnavailableException) rethrow;
      throw ReferenceDataUnavailableException(
        'Failed to load meals from Supabase',
        cause: e,
      );
    }
  }

  Future<List<Exercise>> _loadExercisesFromAssets() async {
    final raw = await rootBundle.loadString('assets/data/exercises.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _exercises = list
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
    return _exercises!;
  }

  Future<List<MealSuggestion>> _loadMealsFromAssets() async {
    final raw = await rootBundle.loadString('assets/data/meals.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _meals = list
        .map((e) => MealSuggestion.fromJson(e as Map<String, dynamic>))
        .toList();
    return _meals!;
  }

  @visibleForTesting
  static Map<String, dynamic> rowToMealJsonForTest(Map<String, dynamic> row) =>
      _rowToMealJson(row);

  @visibleForTesting
  static Map<String, dynamic> rowToExerciseJsonForTest(Map<String, dynamic> row) =>
      _rowToExerciseJson(row);

  /// Bridges snake_case Supabase columns → camelCase [MealSuggestion.fromJson].
  static Map<String, dynamic> _rowToMealJson(Map<String, dynamic> row) {
    return {
      'id': row['id'],
      'name': row['name'],
      'description': row['description'],
      'timing': row['timing'],
      'dietTypes': row['diet_types'] ?? const [],
      'regions': row['regions'] ?? const [],
      'allergens': row['allergens'] ?? const [],
      'timingGuidance': row['timing_guidance'] ?? '',
      'calories': row['calories'],
      'proteinG': row['protein_g'],
      'carbsG': row['carbs_g'],
      'fatG': row['fat_g'],
      'portion': row['portion'] ?? '1 serving',
      'recipe': row['recipe'],
      'recipeAvailable': row['recipe_available'] ?? false,
      'ingredientTags': row['ingredient_tags'] ?? const [],
      'nutritionNotes': row['nutrition_notes'] ?? const [],
    };
  }

  /// Bridges snake_case Supabase columns → camelCase [Exercise.fromJson].
  static Map<String, dynamic> _rowToExerciseJson(Map<String, dynamic> row) {
    return {
      'id': row['id'],
      'name': row['name'],
      'muscleGroups': row['muscle_groups'] ?? const [],
      'equipment': row['equipment'] ?? const [],
      'difficulty': row['difficulty'],
      'estimatedCalories': row['estimated_calories'],
      'formCues': row['form_cues'] ?? const [],
      'commonMistakes': row['common_mistakes'] ?? const [],
      'isCompound': row['is_compound'] ?? false,
      'demoUrl': row['demo_url'],
      'variants': row['variants'] ?? const {},
      'demoImages': row['demo_images'] ?? const [],
      'demoSource': row['demo_source'],
      'audiences': row['audiences'] ?? const ['all'],
      'quickSteps': row['quick_steps'] ?? const [],
      'catalogTags': row['catalog_tags'] ?? const [],
      'demoFrames': row['demo_frames'] ?? const [],
      'demoVideoUrl': row['demo_video_url'],
    };
  }
}