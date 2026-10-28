import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../seed/pro_nutrition_guides.dart';

class GuidesRepository {
  /// [client] is optional so callers can fall back to bundled const lists.
  GuidesRepository([this._client]);

  final SupabaseClient? _client;

  List<FoodPharmerPointer>? _pharmer;
  List<ProNutritionGuide>? _guides;

  Future<List<FoodPharmerPointer>> loadPharmerPointers() async {
    if (_pharmer != null) return _pharmer!;

    final client = _client;
    if (client != null) {
      try {
        final rows = await client
            .from('food_pharmer_pointers')
            .select()
            .eq('is_deleted', false);
        final list = rows as List<dynamic>;
        if (list.isNotEmpty) {
          _pharmer = list.map((e) {
            final row = Map<String, dynamic>.from(e as Map);
            return FoodPharmerPointer(
              id: row['id'] as String,
              title: row['title'] as String,
              tip: row['tip'] as String,
              url: row['url'] as String,
            );
          }).toList();
          return _pharmer!;
        }
      } catch (e) {
        debugPrint('GuidesRepository.loadPharmerPointers Supabase miss: $e');
      }
    }

    _pharmer = List<FoodPharmerPointer>.from(foodPharmerPointers);
    return _pharmer!;
  }

  Future<List<ProNutritionGuide>> loadNutritionGuides() async {
    if (_guides != null) return _guides!;

    final client = _client;
    if (client != null) {
      try {
        final rows = await client
            .from('pro_nutrition_guides')
            .select()
            .eq('is_deleted', false);
        final list = rows as List<dynamic>;
        if (list.isNotEmpty) {
          _guides = list.map((e) {
            final row = Map<String, dynamic>.from(e as Map);
            return ProNutritionGuide(
              id: row['id'] as String,
              title: row['title'] as String,
              source: row['source'] as String,
              benefit: row['benefit'] as String,
              url: row['url'] as String,
            );
          }).toList();
          return _guides!;
        }
      } catch (e) {
        debugPrint('GuidesRepository.loadNutritionGuides Supabase miss: $e');
      }
    }

    _guides = List<ProNutritionGuide>.from(proNutritionGuides);
    return _guides!;
  }
}
