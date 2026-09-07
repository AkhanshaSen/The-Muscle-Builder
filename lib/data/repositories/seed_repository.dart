import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/models.dart';

class SeedRepository {
  List<Exercise>? _exercises;
  List<MealSuggestion>? _meals;

  Future<List<Exercise>> loadExercises() async {
    if (_exercises != null) return _exercises!;
    final raw = await rootBundle.loadString('assets/data/exercises.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _exercises = list
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
    return _exercises!;
  }

  Future<List<MealSuggestion>> loadMeals({bool forceReload = false}) async {
    if (!forceReload && _meals != null) return _meals!;
    final raw = await rootBundle.loadString('assets/data/meals.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _meals = list
        .map((e) => MealSuggestion.fromJson(e as Map<String, dynamic>))
        .toList();
    return _meals!;
  }
}
