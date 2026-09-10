import '../models/enums.dart';
import '../models/models.dart';

/// Case-insensitive partial matching of meal names and ingredients.
class MealSearch {
  MealSearch._();

  /// Lowercases and collapses runs of whitespace.
  static String normalize(String raw) =>
      raw.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Every whitespace-separated token must appear somewhere in the meal.
  static bool matches(MealSuggestion meal, String query) {
    final tokens = _tokens(query);
    if (tokens.isEmpty) return true;
    final haystack = _haystack(meal);
    return tokens.every(haystack.contains);
  }

  /// Name-prefix hits first, then name-contains, then ingredient hits, then the rest.
  static List<MealSuggestion> apply(List<MealSuggestion> meals, String query) {
    final tokens = _tokens(query);
    if (tokens.isEmpty) return List<MealSuggestion>.from(meals);

    final matched = meals.where((m) {
      final haystack = _haystack(m);
      return tokens.every(haystack.contains);
    }).toList();

    int rank(MealSuggestion m) {
      final name = normalize(m.name);
      if (tokens.every((t) => name.startsWith(t) || name.split(' ').any((w) => w.startsWith(t)))) {
        // Prefer full name prefix of the joined query.
        final joined = tokens.join(' ');
        if (name.startsWith(joined)) return 0;
        return 1;
      }
      if (tokens.every(name.contains)) return 2;
      return 3;
    }

    matched.sort((a, b) {
      final cmp = rank(a).compareTo(rank(b));
      if (cmp != 0) return cmp;
      return a.name.compareTo(b.name);
    });
    return matched;
  }

  static List<String> _tokens(String query) {
    final n = normalize(query);
    if (n.isEmpty) return const [];
    return n.split(' ').where((t) => t.isNotEmpty).toList();
  }

  static String _haystack(MealSuggestion meal) {
    final chipLabels = MealIngredientChip.values.asNameMap();
    final parts = <String>[
      meal.name,
      meal.description,
      meal.portion,
      ...meal.ingredientTags,
      for (final tag in meal.ingredientTags)
        ?chipLabels[tag]?.label,
      ...?meal.recipe?.ingredients,
    ];
    return normalize(parts.join(' '));
  }
}
