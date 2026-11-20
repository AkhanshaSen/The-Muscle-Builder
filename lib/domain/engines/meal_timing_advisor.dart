import '../models/enums.dart';
import '../models/models.dart';

class MealTimingAdvisor {
  MealTimingAdvisor._();

  static MealLogVerdict evaluate({
    required MealLogEntry entry,
    DietType diet = DietType.vegetarian,
  }) {
    final kcal = entry.totalKcal;
    final protein = entry.totalProtein;
    final carbs = entry.totalCarbs;
    final fat = entry.totalFat;

    final bullets = <String>[
      '${kcal.round()} kcal · ${protein.round()}g protein · ${carbs.round()}g carbs · ${fat.round()}g fat',
    ];
    final suggestions = <String>[];

    switch (entry.timing) {
      case MealLogTiming.preWorkout:
        if (kcal > 650) {
          bullets.add('Large meal — may feel heavy during training.');
          suggestions.add(
            'Try a lighter plate 60–90 min before (fruit + curd, or small dal-chawal).',
          );
        } else if (kcal < 120) {
          bullets.add('Quite light — you may run low on energy.');
          suggestions.add('Add a banana, toast, or small bowl of oats.');
        }
        if (fat > 25) {
          bullets.add('High fat can slow digestion before lifting.');
          suggestions.add('Save fried foods for after your session.');
        }
        if (carbs >= 25 && protein >= 12 && fat <= 22 && kcal <= 550) {
          return MealLogVerdict(
            score: MealVerdictScore.good,
            summary: 'Solid pre-workout fuel',
            bullets: bullets,
            suggestions: suggestions,
          );
        }
        return MealLogVerdict(
          score: suggestions.isEmpty ? MealVerdictScore.okay : MealVerdictScore.reconsider,
          summary: 'Adjust timing or portion',
          bullets: bullets,
          suggestions: suggestions.isEmpty
              ? ['Aim for carbs + modest protein 1–2 hours before training.']
              : suggestions,
        );
      case MealLogTiming.postWorkout:
        if (protein < 15) {
          bullets.add('Low protein for recovery.');
          suggestions.add(
            'Add paneer, eggs, dal, chicken, or a protein shake within 2 hours.',
          );
        }
        if (carbs < 20) {
          bullets.add('Low carbs — glycogen refill may be slow.');
          suggestions.add('Add rice, roti, or fruit to replenish.');
        }
        if (protein >= 20 && carbs >= 25) {
          return MealLogVerdict(
            score: MealVerdictScore.good,
            summary: 'Good post-workout recovery mix',
            bullets: bullets,
            suggestions: suggestions,
          );
        }
        return MealLogVerdict(
          score: protein < 12 ? MealVerdictScore.reconsider : MealVerdictScore.okay,
          summary: 'Post-workout meal review',
          bullets: bullets,
          suggestions: suggestions.isEmpty
              ? ['Pair protein with carbs soon after training.']
              : suggestions,
        );
      case MealLogTiming.general:
        return MealLogVerdict(
          score: MealVerdictScore.okay,
          summary: 'Logged for your day',
          bullets: bullets,
          suggestions: diet == DietType.vegetarian
              ? ['Use Pre/Post tags when eating around workouts for tailored tips.']
              : const [],
        );
    }
  }
}