import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/models.dart';

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.servingLabel,
    required this.servingGrams,
    required this.kcalPerServing,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.aliases = const [],
  });

  final String id;
  final String name;
  final String servingLabel;
  final double servingGrams;
  final double kcalPerServing;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final List<String> aliases;

  MealLogLineItem scaled(double servings) {
    final q = servings <= 0 ? 1.0 : servings;
    return MealLogLineItem(
      foodId: id,
      label: name,
      quantity: q,
      unit: servingLabel,
      kcal: kcalPerServing * q,
      proteinG: proteinG * q,
      carbsG: carbsG * q,
      fatG: fatG * q,
      source: MealFoodSource.systemImported,
    );
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      servingLabel: json['servingLabel'] as String? ?? 'serving',
      servingGrams: (json['servingGrams'] as num?)?.toDouble() ?? 100,
      kcalPerServing: (json['kcalPerServing'] as num).toDouble(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
      aliases: (json['aliases'] as List?)?.cast<String>() ?? const [],
    );
  }
}

class FoodCatalog {
  FoodCatalog._();

  static List<FoodItem>? _cache;

  static void invalidate() => _cache = null;

  static Future<List<FoodItem>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/foods.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _cache = list
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  static List<FoodItem> search(List<FoodItem> bank, String query) {
    final tokens = query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return bank.take(12).toList();
    return bank.where((f) {
      final hay = '${f.name} ${f.aliases.join(' ')}'.toLowerCase();
      return tokens.every(hay.contains);
    }).take(20).toList();
  }

  static FoodItem? bestMatch(List<FoodItem> bank, String query) {
    final hits = search(bank, query);
    return hits.isEmpty ? null : hits.first;
  }
}