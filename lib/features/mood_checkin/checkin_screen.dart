import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/gym_session_sizing.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../nutrition/meal_icon_tile.dart';
import 'body_map_selector.dart';

IconData _focusIcon(TrainingFocus f) => switch (f) {
      TrainingFocus.strength => Icons.fitness_center,
      TrainingFocus.stamina => Icons.directions_run,
      TrainingFocus.hypertrophy => Icons.monitor_weight_outlined,
      TrainingFocus.mobility => Icons.self_improvement,
    };

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  static const _totalSteps = 6;

  int _step = 0;
  Mood? _mood;
  Intensity _intensity = Intensity.moderate;
  TrainingFocus _focus = TrainingFocus.hypertrophy;
  final Set<MuscleGroup> _muscles = {};
  SorenessLevel _soreness = SorenessLevel.none;
  final Set<MuscleGroup> _avoidMuscles = {};
  /// null = use profile equipment
  Set<Equipment>? _equipmentToday;
  int _gymMinutes = 45;
  MealSuggestion? _preMeal;
  List<MealSuggestion> _preMealOptions = const [];
  bool _preMealsLoading = false;
  bool _generating = false;

  Future<void> _loadPreMeals() async {
    setState(() => _preMealsLoading = true);
    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      if (profile == null) return;
      final options = await ref.read(nutritionRepositoryProvider).suggestionsFor(
            timing: MealTiming.preWorkout,
            dietType: profile.dietType,
            allergies: profile.allergies,
            region: profile.cuisineRegion,
            preferredIngredients: profile.preferredIngredients,
          );
      if (!mounted) return;
      setState(() {
        _preMealOptions = options;
        if (_preMeal == null && options.isNotEmpty) {
          _preMeal = options.first;
        } else if (_preMeal != null &&
            options.every((m) => m.id != _preMeal!.id)) {
          _preMeal = options.isEmpty ? null : options.first;
        }
      });
    } finally {
      if (mounted) setState(() => _preMealsLoading = false);
    }
  }

  Future<void> _surpriseMe() async {
    final recent =
        await ref.read(workoutRepositoryProvider).recentlyTrainedMuscles();
    final picks = ref.read(routineEngineProvider).surpriseMuscles(
          recentlyTrained: recent,
          count: 2,
        );
    setState(() {
      _muscles
        ..clear()
        ..addAll(picks);
      _mood ??= Mood.motivated;
    });
    await _loadPreMeals();
    await _generate(surprise: true);
  }

  Future<void> _generate({bool surprise = false}) async {
    if (_mood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a mood first')),
      );
      return;
    }
    if (_muscles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one muscle group')),
      );
      return;
    }

    setState(() => _generating = true);
    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      if (profile == null) return;
      final bank = await ref.read(seedRepositoryProvider).loadExercises();
      final engine = ref.read(routineEngineProvider);
      final routine = await ref.read(routineRepositoryProvider).getOrCreateWeeklyRoutine();
      final equipment = _equipmentToday?.toList() ?? profile.equipment;

      final catalog = engine.generate(
        mood: _mood!,
        intensity: _intensity,
        muscles: _muscles.toList(),
        availableEquipment: equipment,
        experience: profile.experience,
        bank: bank,
        focus: _focus,
        exerciseCount: GymSessionSizing.maxCatalogCount(),
        soreness: _soreness,
        avoidMuscles: _avoidMuscles.toList(),
        deloadActive: routine.isDeloadActive,
      );

      final checkIn = DailyCheckIn(
        id: const Uuid().v4(),
        date: DateTime.now(),
        mood: _mood!,
        intensity: _intensity,
        selectedMuscles: _muscles.toList(),
        surpriseMe: surprise,
        focus: _focus,
        soreness: _soreness,
        avoidMuscles: _avoidMuscles.toList(),
        equipmentOverride: _equipmentToday?.toList(),
      );
      await ref.read(workoutRepositoryProvider).saveCheckIn(checkIn);

      final encouragement = EncouragementCopy.forMood(
        mood: _mood!.name,
        tone: profile.coachTone.name,
        name: profile.name,
      );

      final nutrition = ref.read(nutritionRepositoryProvider);
      var pre = _preMeal;
      if (pre == null) {
        final preMeals = await nutrition.suggestionsFor(
          timing: MealTiming.preWorkout,
          dietType: profile.dietType,
          allergies: profile.allergies,
          region: profile.cuisineRegion,
          preferredIngredients: profile.preferredIngredients,
        );
        pre = preMeals.isEmpty ? null : preMeals.first;
      }
      final postMeals = await nutrition.suggestionsFor(
        timing: MealTiming.postWorkout,
        dietType: profile.dietType,
        allergies: profile.allergies,
        region: profile.cuisineRegion,
        preferredIngredients: profile.preferredIngredients,
      );

      final plan = WorkoutPlan(
        id: const Uuid().v4(),
        checkInId: checkIn.id,
        createdAt: DateTime.now(),
        exercises: catalog,
        encouragement: encouragement,
        preMeal: pre,
        postMeal: postMeals.isEmpty ? null : postMeals.first,
        gymMinutes: _gymMinutes,
      );
      await ref.read(workoutRepositoryProvider).savePlan(plan);

      ref.invalidate(todaysPlanProvider);
      ref.invalidate(todaysCheckInProvider);
      ref.invalidate(recentFuelHistoryProvider);

      if (!mounted) return;
      context.go('/plan/${plan.id}');
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily check-in'),
        leading: const NestedBackButton(),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / _totalSteps),
            Expanded(
              child: ScrollConfiguration(
                behavior: const NoStretchScrollBehavior(),
                child: IndexedStack(
                  index: _step,
                  sizing: StackFit.expand,
                  children: [
                    _moodStep(),
                    _intensityStep(),
                    _focusStep(),
                    _muscleStep(),
                    _recoveryStep(),
                    _preMealStep(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: () => setState(() => _step--),
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  if (_step < _totalSteps - 1)
                    FilledButton(
                      onPressed: () async {
                        if (_step == 0 && _mood == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Select a mood')),
                          );
                          return;
                        }
                        if (_step == 3 && _muscles.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Select at least one muscle group'),
                            ),
                          );
                          return;
                        }
                        final next = _step + 1;
                        setState(() => _step = next);
                        if (next == 5) await _loadPreMeals();
                      },
                      child: const Text('Next'),
                    )
                  else ...[
                    OutlinedButton(
                      onPressed: _generating ? null : _surpriseMe,
                      child: const Text('Surprise'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _generating ? null : () => _generate(),
                      child: _generating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Generate'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodStep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeader(
          title: 'How are you feeling today?',
          subtitle: 'Mood tweaks rest and encouragement.',
        ),
        const SizedBox(height: 20),
        ...Mood.values.map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SelectableCard(
              selected: _mood == m,
              onTap: () => setState(() => _mood = m),
              child: Row(
                children: [
                  Text(m.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Text(m.label, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _intensityStep() {
    final count = GymSessionSizing.exerciseCountFor(_gymMinutes);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeader(
          title: 'Breakthrough intensity',
          subtitle: 'How hard do you want to push today?',
        ),
        const SizedBox(height: 24),
        Text(
          _intensity.label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
        Slider(
          value: _intensity.index.toDouble(),
          min: 0,
          max: (Intensity.values.length - 1).toDouble(),
          divisions: Intensity.values.length - 1,
          label: _intensity.label,
          onChanged: (v) {
            setState(() => _intensity = Intensity.values[v.round()]);
          },
        ),
        ...Intensity.values.map((i) {
          return ListTile(
            leading: Icon(
              _intensity == i
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(i.label),
            onTap: () => setState(() => _intensity = i),
          );
        }),
        const SizedBox(height: 16),
        const SectionHeader(
          title: 'Gym time today',
          subtitle: 'Exercise count follows how long you can stay.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: GymSessionSizing.optionsMinutes.map((m) {
            final selected = _gymMinutes == m;
            final label = m >= 120
                ? (m == 120 ? '2 hr' : '2.5 hr')
                : '$m min';
            return ChoiceChip(
              label: Text(label),
              selected: selected,
              onSelected: (_) => setState(() => _gymMinutes = m),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          '${GymSessionSizing.labelForMinutes(_gymMinutes)} → $count numbered exercises',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _focusStep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeader(
          title: 'Today\'s focus',
          subtitle: 'Strength, stamina, muscle build, or mobility — shapes reps & rest.',
        ),
        const SizedBox(height: 16),
        ...TrainingFocus.values.map((f) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SelectableCard(
              selected: _focus == f,
              onTap: () => setState(() => _focus = f),
              child: Row(
                children: [
                  Icon(
                    _focusIcon(f),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.label,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          f.subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _muscleStep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SectionHeader(
          title: 'Target muscle groups',
          subtitle: _muscles.isEmpty
              ? 'Tap one or more body parts — multi-focus days are encouraged.'
              : 'Selected: ${_muscles.map((m) => m.label).join(', ')}',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              avatar: const Icon(Icons.select_all, size: 18),
              label: const Text('Upper body'),
              onSelected: (_) => setState(() {
                _muscles
                  ..clear()
                  ..addAll([
                    MuscleGroup.chest,
                    MuscleGroup.back,
                    MuscleGroup.shoulders,
                    MuscleGroup.arms,
                  ]);
              }),
            ),
            FilterChip(
              avatar: const Icon(Icons.directions_walk, size: 18),
              label: const Text('Lower + core'),
              onSelected: (_) => setState(() {
                _muscles
                  ..clear()
                  ..addAll([MuscleGroup.legs, MuscleGroup.core]);
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BodyMapSelector(
          selected: _muscles,
          onChanged: (v) => setState(() {
            _muscles
              ..clear()
              ..addAll(v);
          }),
        ),
      ],
    );
  }

  Widget _recoveryStep() {
    final profileAsync = ref.watch(profileProvider);
    final profileEquip = profileAsync.asData?.value?.equipment ??
        const [Equipment.bodyweight];
    final effective = _equipmentToday ?? profileEquip.toSet();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeader(
          title: 'Recovery & gear today',
          subtitle:
              'Self-report only — not medical advice. High soreness or avoid list lightens volume.',
        ),
        const SizedBox(height: 16),
        Text('Soreness', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: SorenessLevel.values.map((s) {
            return ChoiceChip(
              label: Text(s.label),
              selected: _soreness == s,
              onSelected: (_) => setState(() => _soreness = s),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          'Avoid today (optional)',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MuscleGroup.values.map((m) {
            final selected = _avoidMuscles.contains(m);
            return FilterChip(
              label: Text(m.label),
              selected: selected,
              onSelected: (v) => setState(() {
                if (v) {
                  _avoidMuscles.add(m);
                } else {
                  _avoidMuscles.remove(m);
                }
              }),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          'Equipment today',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          _equipmentToday == null
              ? 'Using profile defaults'
              : 'Override for this plan only',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('Profile default'),
              selected: _equipmentToday == null,
              onSelected: (_) => setState(() => _equipmentToday = null),
            ),
            ...Equipment.values.map((e) {
              final selected =
                  _equipmentToday != null && effective.contains(e);
              return FilterChip(
                label: Text(e.label),
                selected: selected,
                onSelected: (v) => setState(() {
                  final next = Set<Equipment>.from(
                    _equipmentToday ?? profileEquip,
                  );
                  if (v) {
                    next.add(e);
                  } else {
                    next.remove(e);
                  }
                  if (next.isEmpty) next.add(Equipment.bodyweight);
                  _equipmentToday = next;
                }),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _preMealStep() {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeader(
          title: 'Pre-workout meal today',
          subtitle:
              'Pick what you\'ll eat before training — we save it in Progress for future reference.',
        ),
        const SizedBox(height: 12),
        if (_preMealsLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_preMealOptions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No pre-workout matches for your diet chips. Adjust Nutrition preferences or continue — we\'ll skip logging a pre meal.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          ..._preMealOptions.map((meal) {
            final selected = _preMeal?.id == meal.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SelectableCard(
                selected: selected,
                onTap: () => setState(() => _preMeal = meal),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MealIconTile(mealId: meal.id, mealName: meal.name),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${meal.portion} · ${meal.calories} kcal',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            meal.timingGuidance,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: scheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle, color: scheme.primary),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
