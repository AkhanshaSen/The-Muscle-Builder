import '../models/models.dart';
import 'food_catalog.dart';

class MealFoodSearchHit {
  const MealFoodSearchHit({
    required this.label,
    required this.source,
    this.foodId,
    this.customFood,
    this.catalogFood,
  });

  final String label;
  final MealFoodSource source;
  final String? foodId;
  final CustomFoodItem? customFood;
  final FoodItem? catalogFood;
}

class MealFoodSearch {
  MealFoodSearch._();

  static List<MealFoodSearchHit> search({
    required List<FoodItem> catalog,
    required List<CustomFoodItem> userFoods,
    required String query,
  }) {
    final tokens = query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    final userHits = userFoods.where((f) {
      if (tokens.isEmpty) return true;
      final hay = f.label.toLowerCase();
      return tokens.every(hay.contains);
    }).map(
      (f) => MealFoodSearchHit(
        label: f.label,
        source: MealFoodSource.userInputted,
        customFood: f,
      ),
    );

    final catalogHits = FoodCatalog.search(catalog, query).map(
      (f) => MealFoodSearchHit(
        label: f.name,
        source: MealFoodSource.systemImported,
        foodId: f.id,
        catalogFood: f,
      ),
    );

    final combined = [...userHits, ...catalogHits];
    if (tokens.isEmpty) return combined.take(12).toList();
    return combined.take(20).toList();
  }

  static MealFoodSearchHit? bestMatch({
    required List<FoodItem> catalog,
    required List<CustomFoodItem> userFoods,
    required String query,
  }) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return null;
    for (final f in userFoods) {
      if (f.label.toLowerCase() == q) {
        return MealFoodSearchHit(
          label: f.label,
          source: MealFoodSource.userInputted,
          customFood: f,
        );
      }
    }
    final catalogHit = FoodCatalog.bestMatch(catalog, query);
    if (catalogHit != null) {
      return MealFoodSearchHit(
        label: catalogHit.name,
        source: MealFoodSource.systemImported,
        foodId: catalogHit.id,
        catalogFood: catalogHit,
      );
    }
    for (final f in userFoods) {
      if (f.label.toLowerCase().contains(q)) {
        return MealFoodSearchHit(
          label: f.label,
          source: MealFoodSource.userInputted,
          customFood: f,
        );
      }
    }
    return null;
  }

  static MealLogLineItem lineItemFromHit(MealFoodSearchHit hit, double servings) {
    if (hit.customFood != null) {
      return hit.customFood!.toLineItem(quantity: servings);
    }
    if (hit.catalogFood != null) {
      return hit.catalogFood!.scaled(servings).copyWithSource(
            MealFoodSource.systemImported,
          );
    }
    return MealLogLineItem(
      label: hit.label,
      quantity: servings,
      unit: 'serving',
      kcal: 0,
      proteinG: 0,
      carbsG: 0,
      fatG: 0,
      source: hit.source,
    );
  }
}

extension MealLogLineItemSource on MealLogLineItem {
  MealLogLineItem copyWithSource(MealFoodSource source) {
    return MealLogLineItem(
      foodId: foodId,
      label: label,
      quantity: quantity,
      unit: unit,
      kcal: kcal,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      source: source,
    );
  }
}