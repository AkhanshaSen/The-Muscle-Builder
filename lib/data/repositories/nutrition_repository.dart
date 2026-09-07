import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import 'seed_repository.dart';

class NutritionRepository {
  NutritionRepository(this._seed);

  final SeedRepository _seed;

  Future<List<MealSuggestion>> suggestionsFor({
    required MealTiming timing,
    required DietType dietType,
    required List<Allergy> allergies,
    CuisineRegion region = CuisineRegion.panIndian,
    List<String> preferredIngredients = const [],
  }) async {
    final meals = await _seed.loadMeals();
    final preferred = preferredIngredients.toSet();
    return meals.where((m) {
      if (m.timing != timing) return false;
      if (!m.dietTypes.contains(dietType)) return false;
      if (m.allergens.any(allergies.contains)) return false;
      if (region != CuisineRegion.panIndian &&
          !m.regions.contains(region) &&
          !m.regions.contains(CuisineRegion.panIndian)) {
        return false;
      }
      if (preferred.isNotEmpty) {
        final tags = m.ingredientTags.toSet();
        if (tags.intersection(preferred).isEmpty) return false;
      }
      return true;
    }).toList();
  }
}
