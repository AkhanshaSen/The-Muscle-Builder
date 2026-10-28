import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/models.dart';

class SeedRepository {
  /// [client] is optional so unit tests can use asset fallback only.
  SeedRepository([this._client]);

  final SupabaseClient? _client;

  List<Exercise>? _exercises;
  List<MealSuggestion>? _meals;

  Future<List<Exercise>> loadExercises() async {
    if (_exercises != null) return _exercises!;

    final client = _client;
    if (client != null) {
      try {
        final rows =
            await client.from('exercises').select().eq('is_deleted', false);
        final list = rows as List<dynamic>;
        if (list.isNotEmpty) {
          _exercises = list
              .map(
                (e) => Exercise.fromJson(
                  _rowToExerciseJson(Map<String, dynamic>.from(e as Map)),
                ),
              )
              .toList();
          return _exercises!;
        }
      } catch (e) {
        debugPrint('SeedRepository.loadExercises Supabase miss: $e');
      }
    }

    return _loadExercisesFromAssets();
  }

  Future<List<MealSuggestion>> loadMeals({bool forceReload = false}) async {
    if (!forceReload && _meals != null) return _meals!;

    final client = _client;
    if (client != null) {
      try {
        final rows =
            await client.from('meals').select().eq('is_deleted', false);
        final list = rows as List<dynamic>;
        if (list.isNotEmpty) {
          _meals = list
              .map(
                (e) => MealSuggestion.fromJson(
                  _rowToMealJson(Map<String, dynamic>.from(e as Map)),
                ),
              )
              .toList();
          return _meals!;
        }
      } catch (e) {
        debugPrint('SeedRepository.loadMeals Supabase miss: $e');
      }
    }

    return _loadMealsFromAssets(forceReload: forceReload);
  }

  Future<List<Exercise>> _loadExercisesFromAssets() async {
    final raw = await rootBundle.loadString('assets/data/exercises.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _exercises = list
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
    return _exercises!;
  }

  Future<List<MealSuggestion>> _loadMealsFromAssets({
    bool forceReload = false,
  }) async {
    if (!forceReload && _meals != null) return _meals!;
    final raw = await rootBundle.loadString('assets/data/meals.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _meals = list
        .map((e) => MealSuggestion.fromJson(e as Map<String, dynamic>))
        .toList();
    return _meals!;
  }

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
    };
  }
}
