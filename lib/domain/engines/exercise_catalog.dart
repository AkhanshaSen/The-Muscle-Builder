import '../models/enums.dart';
import '../models/models.dart';
import '../models/workout_category.dart';

class ExerciseCatalog {
  ExerciseCatalog._();

  static bool _matchesGender(Exercise e, Gender gender) {
    return switch (gender) {
      Gender.female =>
        e.audiences.contains(ExerciseAudience.all) ||
            e.audiences.contains(ExerciseAudience.female),
      Gender.male =>
        e.audiences.contains(ExerciseAudience.all) ||
            e.audiences.contains(ExerciseAudience.male),
      Gender.other || Gender.preferNotToSay => true,
    };
  }

  static int _genderSortScore(Exercise e, Gender gender) {
    if (gender == Gender.preferNotToSay || gender == Gender.other) {
      return e.audiences.contains(ExerciseAudience.all) ? 0 : 1;
    }
    final target = gender == Gender.female
        ? ExerciseAudience.female
        : ExerciseAudience.male;
    if (e.audiences.contains(target)) return 0;
    if (e.audiences.contains(ExerciseAudience.all)) return 1;
    return 2;
  }

  static List<Exercise> filterExercises(
    List<Exercise> bank, {
    Set<MuscleGroup> muscleGroups = const {},
    String query = '',
    Gender? gender,
    Set<Equipment>? equipment,
  }) {
    final tokens = query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    var list = bank.where((e) {
      if (gender != null && !_matchesGender(e, gender)) return false;
      if (muscleGroups.isNotEmpty &&
          !e.muscleGroups.any(muscleGroups.contains)) {
        return false;
      }
      if (equipment != null && equipment.isNotEmpty) {
        final ok = e.equipment.any(equipment.contains) ||
            e.equipment.contains(Equipment.bodyweight);
        if (!ok) return false;
      }
      if (tokens.isEmpty) return true;
      final hay = e.name.toLowerCase();
      return tokens.every(hay.contains);
    }).toList();

    final g = gender ?? Gender.preferNotToSay;
    final highlight = muscleGroups.contains(MuscleGroup.chest) ||
        muscleGroups.contains(MuscleGroup.shoulders);
    list.sort((a, b) {
      var cmp = _genderSortScore(a, g).compareTo(_genderSortScore(b, g));
      if (cmp != 0) return cmp;
      if (highlight) {
        final aFocus = a.muscleGroups.any(muscleGroups.contains);
        final bFocus = b.muscleGroups.any(muscleGroups.contains);
        if (aFocus != bFocus) return aFocus ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return dedupeByDisplayName(list);
  }

  static bool _isGenericQuickSteps(List<String> steps) {
    if (steps.isEmpty) return true;
    const generic = {
      'control the movement',
      'full range of motion',
      'set up',
      'move with control',
      'finish strong',
    };
    return steps.every((s) => generic.contains(s.trim().toLowerCase()));
  }

  static int _exerciseRichnessScore(Exercise e) {
    var score = e.demoImages.length * 10;
    if (e.demoUrl != null && e.demoUrl!.isNotEmpty) score += 5;
    score += e.demoFrames.length * 3;
    if (e.demoVideoUrl != null && e.demoVideoUrl!.isNotEmpty) score += 15;
    if (!_isGenericQuickSteps(e.quickSteps)) score += 8;
    if (!_isGenericQuickSteps(quickSteps(e))) score += 4;
    return score;
  }

  /// Collapse duplicate display names (keeps richer media + steps).
  static List<Exercise> dedupeByDisplayName(List<Exercise> list) {
    final byName = <String, Exercise>{};
    for (final e in list) {
      final key = e.name.trim().toLowerCase();
      final existing = byName[key];
      if (existing == null) {
        byName[key] = e;
        continue;
      }
      final keep = _exerciseRichnessScore(e) >= _exerciseRichnessScore(existing)
          ? e
          : existing;
      byName[key] = keep;
    }
    final winnerIds = byName.values.map((e) => e.id).toSet();
    return list.where((e) => winnerIds.contains(e.id)).toList();
  }

  static String equipmentSubtitle(Exercise e) {
    final eq = e.equipment.map((x) => x.label).join(' · ');
    final aud = e.audiences.length == 1 && !e.audiences.contains(ExerciseAudience.all)
        ? switch (e.audiences.first) {
            ExerciseAudience.male => 'Men focus',
            ExerciseAudience.female => 'Women focus',
            ExerciseAudience.all => '',
          }
        : '';
    if (eq.isEmpty) return aud;
    if (aud.isEmpty) return eq;
    return '$eq · $aud';
  }

  static List<String> quickSteps(Exercise e) {
    if (e.quickSteps.isNotEmpty) {
      return e.quickSteps.take(3).toList();
    }
    final fromCues = e.formCues.take(3).map(_trimQuickStep).toList();
    if (fromCues.isEmpty) {
      return const [
        'Set up with control',
        'Move through full range',
        'Finish strong and steady',
      ];
    }
    while (fromCues.length < 3) {
      fromCues.add('Keep breathing steady');
    }
    return fromCues;
  }

  static String _trimQuickStep(String raw) {
    final t = raw.trim();
    if (t.length <= 55) return t;
    final head = t.substring(0, 55);
    final dot = head.lastIndexOf('.');
    if (dot > 24) return head.substring(0, dot + 1);
    final space = head.lastIndexOf(' ');
    if (space > 30) return '${head.substring(0, space)}…';
    return '$head…';
  }

  static List<Exercise> filterByCategory(
    List<Exercise> bank,
    String categoryId, {
    Gender? gender,
  }) {
    final cat = WorkoutCategory.byId(categoryId);
  final gendered = filterExercises(bank, gender: gender);
    if (cat == null) return gendered;

    final tagged = gendered
        .where((e) => e.catalogTags.contains(categoryId))
        .toList();
    if (tagged.isNotEmpty) return tagged;

    Iterable<Exercise> out = gendered;
    switch (categoryId) {
      case 'forMen':
        out = out.where(
          (e) =>
              e.audiences.contains(ExerciseAudience.male) ||
              e.audiences.contains(ExerciseAudience.all),
        );
      case 'forWomen':
        out = out.where(
          (e) =>
              e.audiences.contains(ExerciseAudience.female) ||
              e.audiences.contains(ExerciseAudience.all),
        );
      case 'beginner':
        out = out.where((e) => e.difficulty == ExperienceLevel.beginner);
      case 'bodyweight':
        out = out.where((e) => e.equipment.contains(Equipment.bodyweight));
      case 'atHome':
        out = out.where(
          (e) => e.equipment.every(
            (eq) =>
                eq == Equipment.bodyweight ||
                eq == Equipment.dumbbell ||
                eq == Equipment.resistanceBand,
          ),
        );
      case 'abs':
        out = out.where((e) => e.muscleGroups.contains(MuscleGroup.core));
      case 'chest':
        out = out.where((e) => e.muscleGroups.contains(MuscleGroup.chest));
      case 'back':
        out = out.where((e) => e.muscleGroups.contains(MuscleGroup.back));
      case 'biceps':
        out = out.where((e) => e.muscleGroups.contains(MuscleGroup.arms));
      case 'fatLoss':
      case 'cardio':
        out = out.where(
          (e) => e.isCompound || e.estimatedCalories >= 85,
        );
      case 'strength':
        out = out.where((e) => e.isCompound);
      case 'muscleBuilding':
        out = out.where(
          (e) =>
              e.muscleGroups.contains(MuscleGroup.chest) ||
              e.muscleGroups.contains(MuscleGroup.back) ||
              e.muscleGroups.contains(MuscleGroup.legs),
        );
      case 'fullBody':
        out = out.where((e) => e.muscleGroups.length >= 2);
      case 'sportsPerformance':
        out = out.where(
          (e) =>
              e.muscleGroups.contains(MuscleGroup.legs) ||
              e.name.toLowerCase().contains('jump') ||
              e.name.toLowerCase().contains('swing'),
        );
      case 'celebrity':
        out = out.where((e) => e.catalogTags.contains('celebrity'));
      default:
        if (cat.prefillMuscles.isNotEmpty) {
          return filterExercises(
            bank,
            gender: gender,
            muscleGroups: cat.prefillMuscles.toSet(),
          );
        }
    }
    final list = out.toList();
    return list.isEmpty ? gendered : list;
  }
}