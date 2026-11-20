import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/data/repositories/seed_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SeedRepository row mapping', () {
    test('maps exercise Supabase row to model json', () {
      final json = SeedRepository.rowToExerciseJsonForTest({
        'id': 'chest_pushup',
        'name': 'Push-Up',
        'muscle_groups': ['chest'],
        'equipment': ['bodyweight'],
        'difficulty': 'beginner',
        'estimated_calories': 80,
        'form_cues': ['Brace'],
        'common_mistakes': ['Sag'],
        'is_compound': true,
        'demo_url': 'https://example.com/0.jpg',
        'variants': {},
        'demo_images': [],
        'audiences': ['all'],
        'quick_steps': ['Step 1'],
        'catalog_tags': ['bodyweight'],
        'demo_frames': ['https://example.com/0.jpg'],
      });
      expect(json['id'], 'chest_pushup');
      expect(json['muscleGroups'], ['chest']);
      expect(json['quickSteps'], ['Step 1']);
    });

    test('maps meal Supabase row to model json', () {
      final json = SeedRepository.rowToMealJsonForTest({
        'id': 'pre_banana_almonds',
        'name': 'Banana',
        'description': 'Energy',
        'timing': 'preWorkout',
        'diet_types': ['vegetarian'],
        'regions': ['panIndian'],
        'allergens': [],
        'timing_guidance': '30 min before',
        'calories': 185,
        'protein_g': 4.5,
        'carbs_g': 29.0,
        'fat_g': 7.5,
        'portion': '1 serving',
        'recipe_available': true,
        'ingredient_tags': ['fruit'],
        'nutrition_notes': [],
      });
      expect(json['proteinG'], 4.5);
      expect(json['dietTypes'], ['vegetarian']);
    });
  });

  group('SeedRepository without Supabase key', () {
    test('loadExercises from bundled assets', () async {
      final seed = SeedRepository();
      final list = await seed.loadExercises();
      expect(list.length, 88);
      expect(list.first.id, isNotEmpty);
    });

    test('loadMeals from bundled assets', () async {
      final seed = SeedRepository();
      final list = await seed.loadMeals();
      expect(list.length, 58);
    });
  });
}