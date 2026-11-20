import 'enums.dart';

const _dbBase =
    'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises';

class WorkoutCategory {
  const WorkoutCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.heroImageUrl,
    this.prefillMuscles = const [],
    this.prefillEquipment = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final String heroImageUrl;
  final List<MuscleGroup> prefillMuscles;
  final List<Equipment> prefillEquipment;

  static const catalog = [
    WorkoutCategory(
      id: 'forMen',
      title: 'Workouts for men',
      subtitle: 'Strength & size bias',
      heroImageUrl: '$_dbBase/Dumbbell_Bench_Press/0.jpg',
    ),
    WorkoutCategory(
      id: 'forWomen',
      title: 'Workouts for women',
      subtitle: 'Glutes, tone, conditioning',
      heroImageUrl: '$_dbBase/Squat/0.jpg',
    ),
    WorkoutCategory(
      id: 'muscleBuilding',
      title: 'Muscle building',
      subtitle: 'Hypertrophy focus',
      heroImageUrl: '$_dbBase/Barbell_Bench_Press_-_Medium_Grip/0.jpg',
      prefillMuscles: [MuscleGroup.chest, MuscleGroup.back],
    ),
    WorkoutCategory(
      id: 'fatLoss',
      title: 'Fat loss',
      subtitle: 'Burn & metabolic work',
      heroImageUrl: '$_dbBase/Burpee/0.jpg',
    ),
    WorkoutCategory(
      id: 'strength',
      title: 'Increase strength',
      subtitle: 'Heavy compounds',
      heroImageUrl: '$_dbBase/Barbell_Squat/0.jpg',
    ),
    WorkoutCategory(
      id: 'abs',
      title: 'Ab workouts',
      subtitle: 'Core stability',
      heroImageUrl: '$_dbBase/Crunches/0.jpg',
      prefillMuscles: [MuscleGroup.core],
    ),
    WorkoutCategory(
      id: 'fullBody',
      title: 'Full body',
      subtitle: 'Total session',
      heroImageUrl: '$_dbBase/Kettlebell_Swing/0.jpg',
    ),
    WorkoutCategory(
      id: 'sportsPerformance',
      title: 'Sports performance',
      subtitle: 'Power & agility',
      heroImageUrl: '$_dbBase/Box_Jump/0.jpg',
    ),
    WorkoutCategory(
      id: 'bodyweight',
      title: 'Bodyweight',
      subtitle: 'No equipment needed',
      heroImageUrl: '$_dbBase/Pushups/0.jpg',
      prefillEquipment: [Equipment.bodyweight],
    ),
    WorkoutCategory(
      id: 'beginner',
      title: 'Beginner',
      subtitle: 'Learn the patterns',
      heroImageUrl: '$_dbBase/Pushups/0.jpg',
    ),
    WorkoutCategory(
      id: 'atHome',
      title: 'At home',
      subtitle: 'Dumbbell & floor work',
      heroImageUrl: '$_dbBase/Dumbbell_Floor_Press/0.jpg',
      prefillEquipment: [Equipment.dumbbell, Equipment.bodyweight],
    ),
    WorkoutCategory(
      id: 'cardio',
      title: 'Cardio',
      subtitle: 'Conditioning finishers',
      heroImageUrl: '$_dbBase/Jump_Rope/0.jpg',
    ),
    WorkoutCategory(
      id: 'chest',
      title: 'Chest workouts',
      subtitle: 'Press & fly',
      heroImageUrl: '$_dbBase/Dumbbell_Bench_Press/0.jpg',
      prefillMuscles: [MuscleGroup.chest],
    ),
    WorkoutCategory(
      id: 'back',
      title: 'Back workouts',
      subtitle: 'Pull & row',
      heroImageUrl: '$_dbBase/Pullups/0.jpg',
      prefillMuscles: [MuscleGroup.back],
    ),
    WorkoutCategory(
      id: 'biceps',
      title: 'Bicep workouts',
      subtitle: 'Curl variations',
      heroImageUrl: '$_dbBase/Dumbbell_Bicep_Curl/0.jpg',
      prefillMuscles: [MuscleGroup.arms],
    ),
    WorkoutCategory(
      id: 'celebrity',
      title: 'Celebrity inspo',
      subtitle: 'Iconic movie physiques',
      heroImageUrl: '$_dbBase/Pullups/0.jpg',
    ),
  ];

  static WorkoutCategory? byId(String id) {
    for (final c in catalog) {
      if (c.id == id) return c;
    }
    return null;
  }
}