enum Mood {
  energetic,
  tired,
  stressed,
  motivated,
  low;

  String get label => switch (this) {
        Mood.energetic => 'Energetic',
        Mood.tired => 'Tired',
        Mood.stressed => 'Stressed',
        Mood.motivated => 'Motivated',
        Mood.low => 'Low',
      };

  String get emoji => switch (this) {
        Mood.energetic => '⚡',
        Mood.tired => '😴',
        Mood.stressed => '😤',
        Mood.motivated => '🔥',
        Mood.low => '😔',
      };
}

enum Intensity {
  light,
  moderate,
  pushHard,
  prAttempt;

  String get label => switch (this) {
        Intensity.light => 'Light / Recovery',
        Intensity.moderate => 'Moderate',
        Intensity.pushHard => 'Push Hard',
        Intensity.prAttempt => 'PR Attempt',
      };
}

enum TrainingFocus {
  strength,
  stamina,
  hypertrophy,
  mobility;

  String get label => switch (this) {
        TrainingFocus.strength => 'Strength',
        TrainingFocus.stamina => 'Stamina',
        TrainingFocus.hypertrophy => 'Muscle build',
        TrainingFocus.mobility => 'Mobility',
      };

  String get subtitle => switch (this) {
        TrainingFocus.strength => 'Heavier loads, lower reps, longer rest',
        TrainingFocus.stamina => 'Higher reps, shorter rest, keep moving',
        TrainingFocus.hypertrophy => 'Classic muscle-building volume',
        TrainingFocus.mobility => 'Control, range of motion, lighter work',
      };
}

enum MuscleGroup {
  chest,
  back,
  legs,
  shoulders,
  arms,
  core;

  String get label => switch (this) {
        MuscleGroup.chest => 'Chest',
        MuscleGroup.back => 'Back',
        MuscleGroup.legs => 'Legs',
        MuscleGroup.shoulders => 'Shoulders',
        MuscleGroup.arms => 'Arms',
        MuscleGroup.core => 'Core',
      };
}

enum Equipment {
  bodyweight,
  dumbbell,
  gym,
  resistanceBand;

  String get label => switch (this) {
        Equipment.bodyweight => 'Bodyweight',
        Equipment.dumbbell => 'Dumbbell',
        Equipment.gym => 'Gym',
        Equipment.resistanceBand => 'Resistance Band',
      };
}

enum ExperienceLevel {
  beginner,
  intermediate,
  advanced;

  String get label => switch (this) {
        ExperienceLevel.beginner => 'Beginner',
        ExperienceLevel.intermediate => 'Intermediate',
        ExperienceLevel.advanced => 'Advanced',
      };
}

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive;

  String get label => switch (this) {
        ActivityLevel.sedentary => 'Sedentary',
        ActivityLevel.lightlyActive => 'Lightly Active',
        ActivityLevel.moderatelyActive => 'Moderately Active',
        ActivityLevel.veryActive => 'Very Active',
      };
}

enum PrimaryGoal {
  strength,
  recomposition,
  endurance,
  consistency,
  habit;

  String get label => switch (this) {
        PrimaryGoal.strength => 'Strength',
        PrimaryGoal.recomposition => 'Body Recomposition',
        PrimaryGoal.endurance => 'Endurance',
        PrimaryGoal.consistency => 'Consistency',
        PrimaryGoal.habit => 'Habit Building',
      };

  String get blurb => switch (this) {
        PrimaryGoal.strength => 'Lift heavier and feel capable in the gym',
        PrimaryGoal.recomposition => 'Build muscle while leaning out over time',
        PrimaryGoal.endurance => 'Last longer with better conditioning',
        PrimaryGoal.consistency => 'Show up often — progress compounds',
        PrimaryGoal.habit => 'Make training a non‑negotiable daily rhythm',
      };
}

enum Gender {
  male,
  female,
  other,
  preferNotToSay;

  String get label => switch (this) {
        Gender.male => 'Male',
        Gender.female => 'Female',
        Gender.other => 'Other',
        Gender.preferNotToSay => 'Prefer not to say',
      };
}

enum DietType {
  vegetarian,
  vegan,
  eggetarian,
  nonVegetarian;

  String get label => switch (this) {
        DietType.vegetarian => 'Vegetarian',
        DietType.vegan => 'Vegan',
        DietType.eggetarian => 'Eggetarian',
        DietType.nonVegetarian => 'Non-Vegetarian',
      };
}

enum Allergy {
  lactose,
  nuts,
  gluten,
  soy;

  String get label => switch (this) {
        Allergy.lactose => 'Lactose',
        Allergy.nuts => 'Nuts',
        Allergy.gluten => 'Gluten',
        Allergy.soy => 'Soy',
      };
}

enum CuisineRegion {
  northIndian,
  southIndian,
  panIndian;

  String get label => switch (this) {
        CuisineRegion.northIndian => 'North Indian',
        CuisineRegion.southIndian => 'South Indian',
        CuisineRegion.panIndian => 'Pan Indian',
      };
}

enum MealTiming {
  preWorkout,
  postWorkout;

  String get label => switch (this) {
        MealTiming.preWorkout => 'Pre-Workout',
        MealTiming.postWorkout => 'Post-Workout',
      };
}

/// Planned / logged day type for the weekly gym calendar.
enum DayKind {
  gym,
  rest,
  cheat,
  /// Holiday, gym closed, travel — planned gym day excused.
  skip;

  String get label => switch (this) {
        DayKind.gym => 'Gym',
        DayKind.rest => 'Rest',
        DayKind.cheat => 'Cheat',
        DayKind.skip => 'Skip',
      };

  String get subtitle => switch (this) {
        DayKind.gym => 'Train today',
        DayKind.rest => 'Recover',
        DayKind.cheat => 'Flexible / treat day',
        DayKind.skip => 'Holiday / gym closed',
      };

  /// Weekly template paint options (not skip).
  static const planKinds = [DayKind.gym, DayKind.rest, DayKind.cheat];

  /// What you can log for a calendar day.
  static const logKinds = [
    DayKind.gym,
    DayKind.rest,
    DayKind.cheat,
    DayKind.skip,
  ];
}

enum SorenessLevel {
  none,
  mild,
  high;

  String get label => switch (this) {
        SorenessLevel.none => 'None',
        SorenessLevel.mild => 'Mild',
        SorenessLevel.high => 'High',
      };
}

/// Chips on Nutrition — “I want to eat” filters (OR match on meal tags).
enum MealIngredientChip {
  wheyProtein,
  plantProtein,
  proteinBake,
  curd,
  eggs,
  paneer,
  chicken,
  oats,
  dates,
  fruit,
  spinach,
  millet,
  legumes;

  String get label => switch (this) {
        MealIngredientChip.wheyProtein => 'Whey protein',
        MealIngredientChip.plantProtein => 'Plant protein',
        MealIngredientChip.proteinBake => 'Protein cake',
        MealIngredientChip.curd => 'Curd / yogurt',
        MealIngredientChip.eggs => 'Eggs',
        MealIngredientChip.paneer => 'Paneer',
        MealIngredientChip.chicken => 'Chicken',
        MealIngredientChip.oats => 'Oats',
        MealIngredientChip.dates => 'Dates',
        MealIngredientChip.fruit => 'Fruit',
        MealIngredientChip.spinach => 'Spinach',
        MealIngredientChip.millet => 'Ragi / millet',
        MealIngredientChip.legumes => 'Legumes',
      };

  /// Tags used for protein-focus shortcut.
  static const proteinFocus = [
    MealIngredientChip.wheyProtein,
    MealIngredientChip.plantProtein,
    MealIngredientChip.proteinBake,
  ];
}

enum CoachTone {
  toughLove,
  friendly,
  calmData;

  String get label => switch (this) {
        CoachTone.toughLove => 'Tough Love',
        CoachTone.friendly => 'Friendly Cheerleader',
        CoachTone.calmData => 'Calm & Data-Driven',
      };

  /// Compact chip label for dense Profile UI.
  String get shortLabel => switch (this) {
        CoachTone.toughLove => 'Tough Love',
        CoachTone.friendly => 'Friendly',
        CoachTone.calmData => 'Calm & Data',
      };
}

enum ThemePreference {
  system,
  light,
  dark;

  String get label => switch (this) {
        ThemePreference.system => 'System',
        ThemePreference.light => 'Light',
        ThemePreference.dark => 'Dark',
      };
}
