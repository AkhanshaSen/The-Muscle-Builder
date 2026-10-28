import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../seed/pro_nutrition_guides.dart';

/// One-time upsert of bundled reference data into Supabase.
///
/// Runs when tables are empty (or prefs flag is unset). Safe to call on every
/// cold start — it no-ops once seed is complete.
class SupabaseSeeder {
  SupabaseSeeder(this._client);

  final SupabaseClient _client;

  static const _prefsKey = 'supabase_reference_seeded_v1';

  Future<void> seedIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_prefsKey) == true) {
        // Still verify remote isn't empty (fresh project / wiped tables).
        final remoteEmpty = await _isTableEmpty('meals');
        if (!remoteEmpty) return;
      }

      final mealsEmpty = await _isTableEmpty('meals');
      final exercisesEmpty = await _isTableEmpty('exercises');
      final pharmerEmpty = await _isTableEmpty('food_pharmer_pointers');
      final guidesEmpty = await _isTableEmpty('pro_nutrition_guides');

      if (!mealsEmpty &&
          !exercisesEmpty &&
          !pharmerEmpty &&
          !guidesEmpty) {
        await prefs.setBool(_prefsKey, true);
        return;
      }

      if (mealsEmpty) await _seedMeals();
      if (exercisesEmpty) await _seedExercises();
      if (pharmerEmpty) await _seedPharmerPointers();
      if (guidesEmpty) await _seedNutritionGuides();

      await prefs.setBool(_prefsKey, true);
      debugPrint('SupabaseSeeder: reference data upserted');
    } catch (e, st) {
      // Never block app launch — SeedRepository falls back to assets.
      debugPrint('SupabaseSeeder failed: $e\n$st');
    }
  }

  Future<bool> _isTableEmpty(String table) async {
    final rows = await _client
        .from(table)
        .select('id')
        .eq('is_deleted', false)
        .limit(1);
    return (rows as List).isEmpty;
  }

  Future<void> _seedMeals() async {
    final raw = await rootBundle.loadString('assets/data/meals.json');
    final list = jsonDecode(raw) as List<dynamic>;
    final rows = list
        .map((e) => _mealJsonToRow(e as Map<String, dynamic>))
        .toList();
    await _upsertInChunks('meals', rows);
  }

  Future<void> _seedExercises() async {
    final raw = await rootBundle.loadString('assets/data/exercises.json');
    final list = jsonDecode(raw) as List<dynamic>;
    final rows = list
        .map((e) => _exerciseJsonToRow(e as Map<String, dynamic>))
        .toList();
    await _upsertInChunks('exercises', rows);
  }

  Future<void> _seedPharmerPointers() async {
    final rows = foodPharmerPointers
        .map(
          (p) => {
            'id': p.id,
            'title': p.title,
            'tip': p.tip,
            'url': p.url,
          },
        )
        .toList();
    await _client.from('food_pharmer_pointers').upsert(rows);
  }

  Future<void> _seedNutritionGuides() async {
    final rows = proNutritionGuides
        .map(
          (g) => {
            'id': g.id,
            'title': g.title,
            'source': g.source,
            'benefit': g.benefit,
            'url': g.url,
          },
        )
        .toList();
    await _client.from('pro_nutrition_guides').upsert(rows);
  }

  Future<void> _upsertInChunks(
    String table,
    List<Map<String, dynamic>> rows, {
    int chunkSize = 50,
  }) async {
    for (var i = 0; i < rows.length; i += chunkSize) {
      final end = (i + chunkSize < rows.length) ? i + chunkSize : rows.length;
      await _client.from(table).upsert(rows.sublist(i, end));
    }
  }

  static Map<String, dynamic> _mealJsonToRow(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'name': json['name'],
      'description': json['description'],
      'timing': json['timing'],
      'diet_types': json['dietTypes'] ?? const [],
      'regions': json['regions'] ?? const [],
      'allergens': json['allergens'] ?? const [],
      'timing_guidance': json['timingGuidance'] ?? '',
      'calories': json['calories'],
      'protein_g': json['proteinG'],
      'carbs_g': json['carbsG'],
      'fat_g': json['fatG'],
      'portion': json['portion'] ?? '1 serving',
      'recipe': json['recipe'],
      'recipe_available': json['recipeAvailable'] ?? false,
      'ingredient_tags': json['ingredientTags'] ?? const [],
      'nutrition_notes': json['nutritionNotes'] ?? const [],
    };
  }

  static Map<String, dynamic> _exerciseJsonToRow(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'name': json['name'],
      'muscle_groups': json['muscleGroups'] ?? const [],
      'equipment': json['equipment'] ?? const [],
      'difficulty': json['difficulty'],
      'estimated_calories': json['estimatedCalories'],
      'form_cues': json['formCues'] ?? const [],
      'common_mistakes': json['commonMistakes'] ?? const [],
      'is_compound': json['isCompound'] ?? false,
      'demo_url': json['demoUrl'],
      'variants': json['variants'] ?? const {},
      'demo_images': json['demoImages'] ?? const [],
      'demo_source': json['demoSource'],
    };
  }
}
