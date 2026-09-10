import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/meal_search.dart';
import 'package:the_muscle_builder/domain/models/enums.dart';
import 'package:the_muscle_builder/domain/models/models.dart';

MealSuggestion _meal({
  required String id,
  required String name,
  String description = '',
  String portion = '1 serving',
  List<String> ingredientTags = const [],
  MealRecipe? recipe,
}) {
  return MealSuggestion(
    id: id,
    name: name,
    description: description,
    timing: MealTiming.preWorkout,
    dietTypes: const [DietType.vegetarian],
    regions: const [CuisineRegion.panIndian],
    allergens: const [],
    timingGuidance: '30 min before',
    calories: 200,
    proteinG: 10,
    carbsG: 20,
    fatG: 5,
    portion: portion,
    ingredientTags: ingredientTags,
    recipe: recipe,
  );
}

void main() {
  test('normalize collapses case and whitespace', () {
    expect(MealSearch.normalize('  Whey   Protein '), 'whey protein');
  });

  test('partial name match is case-insensitive', () {
    final meals = [
      _meal(id: '1', name: 'Banana + Soaked Almonds'),
      _meal(id: '2', name: 'Poha with Peanuts'),
    ];
    final hits = MealSearch.apply(meals, 'ALM');
    expect(hits.map((m) => m.id), ['1']);
  });

  test('ingredient tag label match finds whey protein', () {
    final meals = [
      _meal(
        id: 'shake',
        name: 'Post Gym Shake',
        ingredientTags: const ['wheyProtein'],
      ),
      _meal(id: 'fruit', name: 'Fruit Bowl', ingredientTags: const ['fruit']),
    ];
    expect(MealSearch.matches(meals.first, 'whey protein'), isTrue);
    final hits = MealSearch.apply(meals, 'whey protein');
    expect(hits.map((m) => m.id), ['shake']);
  });

  test('ragi matches millet chip label', () {
    final meal = _meal(
      id: 'ragi',
      name: 'Ragi Malt',
      ingredientTags: const ['millet'],
    );
    expect(MealSearch.matches(meal, 'ragi'), isTrue);
  });

  test('recipe ingredient match', () {
    final meal = _meal(
      id: 'oats',
      name: 'Warm Bowl',
      recipe: const MealRecipe(
        prepMinutes: 5,
        ingredients: ['40g rolled oats', '200ml milk'],
        steps: ['Cook'],
      ),
    );
    expect(MealSearch.matches(meal, 'oats'), isTrue);
    expect(MealSearch.matches(meal, 'rolled'), isTrue);
  });

  test('multi-token query is AND', () {
    final meals = [
      _meal(id: '1', name: 'Banana + Soaked Almonds'),
      _meal(id: '2', name: 'Banana Chia Smoothie'),
      _meal(id: '3', name: 'Almond Milk Latte'),
    ];
    final hits = MealSearch.apply(meals, 'banana almond');
    expect(hits.map((m) => m.id), ['1']);
  });

  test('name matches rank above description matches', () {
    final meals = [
      _meal(
        id: 'desc',
        name: 'Warm Bowl',
        description: 'Packed with peanut butter for energy',
      ),
      _meal(id: 'name', name: 'Peanut Chikki'),
    ];
    final hits = MealSearch.apply(meals, 'peanut');
    expect(hits.first.id, 'name');
    expect(hits.map((m) => m.id), ['name', 'desc']);
  });

  test('empty query returns all meals', () {
    final meals = [
      _meal(id: '1', name: 'A'),
      _meal(id: '2', name: 'B'),
    ];
    expect(MealSearch.apply(meals, '  ').length, 2);
  });
}
