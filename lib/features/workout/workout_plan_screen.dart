import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/gym_session_sizing.dart';
import '../../domain/engines/routine_engine.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../nutrition/meal_icon_tile.dart';
import 'exercise_posture_gallery.dart';
import 'reset_today.dart';

class WorkoutPlanScreen extends ConsumerStatefulWidget {
  const WorkoutPlanScreen({super.key, required this.planId});

  final String planId;

  @override
  ConsumerState<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends ConsumerState<WorkoutPlanScreen> {
  WorkoutPlan? _plan;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final plan =
        await ref.read(workoutRepositoryProvider).getPlanById(widget.planId);
    if (!mounted) return;
    var resolved = plan;
    if (resolved != null) {
      resolved = await _ensureMeals(resolved);
      resolved = await _refreshMealMacros(resolved);
    }
    setState(() {
      _plan = resolved;
      _loading = false;
    });
  }

  /// Pull latest kcal/protein from seed catalog for saved meal IDs.
  Future<WorkoutPlan> _refreshMealMacros(WorkoutPlan plan) async {
    final catalog = await ref
        .read(seedRepositoryProvider)
        .loadMeals(forceReload: true);
    final byId = {for (final m in catalog) m.id: m};
    final pre = plan.preMeal == null ? null : byId[plan.preMeal!.id] ?? plan.preMeal;
    final post =
        plan.postMeal == null ? null : byId[plan.postMeal!.id] ?? plan.postMeal;
    if (pre == plan.preMeal && post == plan.postMeal) return plan;
    return ref.read(workoutRepositoryProvider).updatePlanMeals(
          planId: plan.id,
          preMeal: pre,
          postMeal: post,
        );
  }

  Future<WorkoutPlan> _ensureMeals(WorkoutPlan plan) async {
    final profile = await ref.read(profileRepositoryProvider).getProfile();
    if (profile == null) return plan;
    final nutrition = ref.read(nutritionRepositoryProvider);
    MealSuggestion? pre = plan.preMeal;
    MealSuggestion? post = plan.postMeal;
    if (pre == null) {
      final list = await nutrition.suggestionsFor(
        timing: MealTiming.preWorkout,
        dietType: profile.dietType,
        allergies: profile.allergies,
        region: profile.cuisineRegion,
      );
      pre = list.isEmpty ? null : list.first;
    }
    if (post == null) {
      final list = await nutrition.suggestionsFor(
        timing: MealTiming.postWorkout,
        dietType: profile.dietType,
        allergies: profile.allergies,
        region: profile.cuisineRegion,
      );
      post = list.isEmpty ? null : list.first;
    }
    if (pre == plan.preMeal && post == plan.postMeal) return plan;
    return ref.read(workoutRepositoryProvider).updatePlanMeals(
          planId: plan.id,
          preMeal: pre,
          postMeal: post,
        );
  }

  Future<void> _pickMeal(MealTiming timing) async {
    final plan = _plan;
    if (plan == null) return;
    final profile = await ref.read(profileRepositoryProvider).getProfile();
    if (profile == null || !mounted) return;
    final options = await ref.read(nutritionRepositoryProvider).suggestionsFor(
          timing: timing,
          dietType: profile.dietType,
          allergies: profile.allergies,
          region: profile.cuisineRegion,
          preferredIngredients: profile.preferredIngredients,
        );
    if (!mounted) return;
    if (options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No meals match your diet filters right now.'),
        ),
      );
      return;
    }

    final current =
        timing == MealTiming.preWorkout ? plan.preMeal : plan.postMeal;
    final selected = await showModalBottomSheet<MealSuggestion>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return _MealPickerSheet(
              timing: timing,
              options: options,
              currentId: current?.id,
              controller: scrollController,
            );
          },
        );
      },
    );
    if (selected == null || !mounted) return;

    final updated = await ref.read(workoutRepositoryProvider).updatePlanMeals(
          planId: plan.id,
          preMeal: timing == MealTiming.preWorkout ? selected : plan.preMeal,
          postMeal:
              timing == MealTiming.postWorkout ? selected : plan.postMeal,
        );
    ref.invalidate(todaysPlanProvider);
    ref.invalidate(recentFuelHistoryProvider);
    if (!mounted) return;
    setState(() => _plan = updated);
  }

  Future<void> _setGymMinutes(int minutes) async {
    final plan = _plan;
    if (plan == null) return;
    final saved = await ref.read(workoutRepositoryProvider).updatePlanExercises(
          plan.id,
          plan.exercises,
          gymMinutes: minutes,
        );
    ref.invalidate(todaysPlanProvider);
    if (!mounted) return;
    setState(() => _plan = saved);
  }

  Future<void> _setExerciseCount(int? count) async {
    final plan = _plan;
    if (plan == null) return;
    final saved = await ref
        .read(workoutRepositoryProvider)
        .updatePlanExerciseCount(plan.id, count);
    ref.invalidate(todaysPlanProvider);
    if (!mounted) return;
    setState(() => _plan = saved);
  }

  Future<void> _removeExercise(int activeIndex) async {
    final plan = _plan;
    if (plan == null) return;
    final active = GymSessionSizing.activeExercises(plan);
    if (active.length <= 1 || activeIndex < 0 || activeIndex >= active.length) {
      return;
    }
    final id = active[activeIndex].exerciseId;
    final remaining =
        plan.exercises.where((e) => e.exerciseId != id).toList();
    if (remaining.isEmpty) return;
    final saved = await ref
        .read(workoutRepositoryProvider)
        .updatePlanExercises(plan.id, remaining, gymMinutes: plan.gymMinutes);
    ref.invalidate(todaysPlanProvider);
    if (!mounted) return;
    setState(() => _plan = saved);
  }

  Future<void> _updateSets(String exerciseId, int sets) async {
    final plan = _plan;
    if (plan == null) return;
    final next = [
      for (final e in plan.exercises)
        if (e.exerciseId == exerciseId)
          e.copyWith(sets: sets.clamp(1, 6))
        else
          e,
    ];
    final saved = await ref
        .read(workoutRepositoryProvider)
        .updatePlanExercises(plan.id, next, gymMinutes: plan.gymMinutes);
    ref.invalidate(todaysPlanProvider);
    if (!mounted) return;
    setState(() => _plan = saved);
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final plan = _plan;
    if (plan == null) {
      return Scaffold(
        appBar: AppBar(leading: const NestedBackButton()),
        body: const EmptyState(
          icon: Icons.error_outline,
          title: 'Plan not found',
          message: 'Try generating a new check-in.',
        ),
      );
    }

    final demoById = {
      for (final e in exercisesAsync.asData?.value ?? const <Exercise>[])
        e.id: e.demoImages,
    };
    final scheme = Theme.of(context).colorScheme;
    final active = GymSessionSizing.activeExercises(plan);
    final windows = GymSessionSizing.timeWindows(active);
    final sessionMins = GymSessionSizing.totalMinutes(active);
    final muscles = active
        .expand((e) => e.muscleGroups)
        .toSet()
        .map((m) => m.label)
        .toList();

    // Group by primary muscle while preserving first-appearance order.
    final grouped = <MuscleGroup, List<(int idx, PlannedExercise ex)>>{};
    for (var i = 0; i < active.length; i++) {
      final primary = active[i].muscleGroups.isNotEmpty
          ? active[i].muscleGroups.first
          : MuscleGroup.values.first;
      grouped.putIfAbsent(primary, () => []).add((i, active[i]));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s routine'),
        leading: const NestedBackButton(),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value != 'reset') return;
              final ok = await confirmResetToday(context, ref);
              if (ok && context.mounted) {
                context.go('/checkin');
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'reset',
                child: Text('Reset today\'s routine'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: scheme.surface,
        elevation: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: PrimaryCta(
                label:
                    'Start session · ${active.length} moves · ~$sessionMins min',
                icon: Icons.play_arrow_rounded,
                onPressed: () async {
                  final sessionPlan = plan.copyWith(exercises: active);
                  final session = await ref
                      .read(workoutRepositoryProvider)
                      .startSession(sessionPlan);
                  if (context.mounted) {
                    context.push('/session/${session.id}');
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const NoStretchScrollBehavior(),
        child: ListView(
        padding: AppSpacing.page,
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.card,
              child: Text(plan.encouragement),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DayFuelCard(
            plan: plan,
            burnOverride: GymSessionSizing.activeBurnKcal(plan),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Fuel for this session',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pre + post meals ride with your routine so Progress can balance calories at day end.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          _PlanMealCard(
            label: 'Pre-workout',
            meal: plan.preMeal,
            onSelect: () => _pickMeal(MealTiming.preWorkout),
          ),
          const SizedBox(height: 10),
          _PlanMealCard(
            label: 'Post-workout',
            meal: plan.postMeal,
            onSelect: () => _pickMeal(MealTiming.postWorkout),
          ),
          const SizedBox(height: AppSpacing.md),
          _OrderGuideCard(exercises: active),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Exercises for your gym time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Gym time sets a baseline — customize the count below. Clock is an estimate.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          _GymTimePicker(
            gymMinutes: plan.gymMinutes,
            exerciseCount: active.length,
            baselineCount: GymSessionSizing.exerciseCountFor(plan.gymMinutes),
            catalogLength: plan.exercises.length,
            overrideCount: plan.exerciseCountOverride,
            estimatedMinutes: sessionMins,
            onGymMinutesChanged: _setGymMinutes,
            onExerciseCountChanged: _setExerciseCount,
          ),
          if (muscles.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: muscles
                  .map(
                    (m) => Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(m),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ...grouped.entries.expand((groupEntry) {
            final muscle = groupEntry.key;
            final items = groupEntry.value;
            return [
              SectionLabel(
                '${muscle.label} · ${items.length} '
                'move${items.length == 1 ? '' : 's'}',
              ),
              const SizedBox(height: AppSpacing.sm),
              ...items.map((item) {
                final i = item.$1;
                final e = item.$2;
                final window = windows[i];
                final images = e.demoImages.isNotEmpty
                    ? e.demoImages
                    : (demoById[e.exerciseId] ?? const <String>[]);
                final role = RoutineOrderGuide.roleLabel(i, active.length, e);
                final why = RoutineOrderGuide.roleWhy(i, active.length, e);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    title: Text(e.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (e.muscleGroups.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: e.muscleGroups.map((g) {
                              return Chip(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                label: Text(
                                  g.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          'Min ${window.start}–${window.end} · $role\n'
                          '${e.sets} sets × ${e.reps} reps · rest ${e.restSeconds}s'
                          '${e.includeDropSet ? ' · drop set on last' : ''}',
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: _SetsStepper(
                          sets: e.sets,
                          ideal: e.recommendedSets ?? e.sets,
                          onChanged: (v) => _updateSets(e.exerciseId, v),
                        ),
                      ),
                      if (active.length > 1)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _removeExercise(i),
                            icon: const Icon(Icons.remove_circle_outline),
                            label: const Text('Skip this today'),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            why,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ),
                      if (images.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          child: ExercisePostureGallery(
                            imageUrls: images,
                            height: 110,
                          ),
                        ),
                      if (e.formCues.isNotEmpty)
                        ListTile(
                          title: const Text('Form cues'),
                          subtitle: Text(
                            e.formCues
                                .asMap()
                                .entries
                                .map((c) => '${c.key + 1}. ${c.value}')
                                .join('\n'),
                          ),
                        ),
                      if (e.commonMistakes.isNotEmpty)
                        ListTile(
                          title: const Text('Common mistakes'),
                          subtitle: Text(
                            e.commonMistakes.map((c) => '• $c').join('\n'),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sm),
            ];
          }),
        ],
      ),
      ),
    );
  }
}

class _GymTimePicker extends StatelessWidget {
  const _GymTimePicker({
    required this.gymMinutes,
    required this.exerciseCount,
    required this.baselineCount,
    required this.catalogLength,
    required this.overrideCount,
    required this.estimatedMinutes,
    required this.onGymMinutesChanged,
    required this.onExerciseCountChanged,
  });

  final int gymMinutes;
  final int exerciseCount;
  final int baselineCount;
  final int catalogLength;
  final int? overrideCount;
  final int estimatedMinutes;
  final ValueChanged<int> onGymMinutesChanged;
  final ValueChanged<int?> onExerciseCountChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final customized = overrideCount != null;
    final atCatalogCap = exerciseCount >= catalogLength &&
        catalogLength < GymSessionSizing.maxExerciseCount;
    final maxAllowed = catalogLength.clamp(
      GymSessionSizing.minExerciseCount,
      GymSessionSizing.maxExerciseCount,
    );

    return Card(
      child: Padding(
        padding: AppSpacing.cardTight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gym time · ~$estimatedMinutes min clock',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: GymSessionSizing.optionsMinutes.map((m) {
                final label = m >= 120
                    ? (m == 120 ? '2 hr' : '2.5 hr')
                    : '$m min';
                return ChoiceChip(
                  label: Text(label),
                  selected: gymMinutes == m,
                  onSelected: (_) => onGymMinutesChanged(m),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Exercises today',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              customized
                  ? 'Custom · gym-time baseline is $baselineCount'
                  : '${GymSessionSizing.labelForMinutes(gymMinutes)} baseline',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                IconButton(
                  tooltip: 'Fewer exercises',
                  onPressed: exerciseCount > GymSessionSizing.minExerciseCount
                      ? () => onExerciseCountChanged(exerciseCount - 1)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$exerciseCount',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                IconButton(
                  tooltip: 'More exercises',
                  onPressed: exerciseCount < maxAllowed
                      ? () => onExerciseCountChanged(exerciseCount + 1)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (customized)
                  TextButton(
                    onPressed: () => onExerciseCountChanged(null),
                    child: const Text('Match gym time'),
                  ),
              ],
            ),
            if (atCatalogCap)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'Catalog max for this plan is $catalogLength. '
                  'Re-do check-in for a longer list.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.tertiary,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SetsStepper extends StatelessWidget {
  const _SetsStepper({
    required this.sets,
    required this.ideal,
    required this.onChanged,
  });

  final int sets;
  final int ideal;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final differs = sets != ideal;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sets',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                differs
                    ? 'Ideal for you today: $ideal sets'
                    : 'Ideal for your intensity: $ideal sets',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: differs ? scheme.primary : scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Fewer sets',
          onPressed: sets > 1 ? () => onChanged(sets - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          '$sets',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        IconButton(
          tooltip: 'More sets',
          onPressed: sets < 6 ? () => onChanged(sets + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _OrderGuideCard extends StatelessWidget {
  const _OrderGuideCard({required this.exercises});

  final List<PlannedExercise> exercises;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.route_rounded, color: scheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Why this order',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(RoutineOrderGuide.sessionGuide(exercises)),
            const SizedBox(height: AppSpacing.md),
            _GuideStep(
              step: '1',
              title: 'Openers first',
              body: 'Strength + skill while you\'re fresh — biggest progress signal.',
            ),
            _GuideStep(
              step: '2',
              title: 'Volume in the middle',
              body: 'Hypertrophy and calorie burn with quality still high.',
            ),
            _GuideStep(
              step: '3',
              title: 'Finishers last',
              body: 'Isolation / drop sets when tired — pump without risky heavy loads.',
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({
    required this.step,
    required this.title,
    required this.body,
  });

  final String step;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: scheme.primary.withValues(alpha: 0.2),
            child: Text(
              step,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: scheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayFuelCard extends StatelessWidget {
  const _DayFuelCard({required this.plan, this.burnOverride});

  final WorkoutPlan plan;
  final int? burnOverride;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final burn = burnOverride ?? plan.estimatedBurnKcal;
    final fuel = plan.mealFuelKcal;
    final balance = fuel - burn;
    final balanceLabel = balance >= 0
        ? '+$balance kcal recovery surplus'
        : '${balance.abs()} kcal net burn vs meals';

    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.28),
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s calorie snapshot',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _FuelStat(
                    label: 'Workout burn',
                    value: '~$burn',
                    hint: 'kcal est.',
                  ),
                ),
                Expanded(
                  child: _FuelStat(
                    label: 'Meal fuel',
                    value: '$fuel',
                    hint: 'kcal',
                  ),
                ),
                Expanded(
                  child: _FuelStat(
                    label: 'Protein',
                    value: plan.mealProteinG.toStringAsFixed(0),
                    hint: 'g pre+post',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$balanceLabel · C ${plan.mealCarbsG.toStringAsFixed(0)}g · '
              'F ${plan.mealFatG.toStringAsFixed(0)}g from selected meals',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FuelStat extends StatelessWidget {
  const _FuelStat({
    required this.label,
    required this.value,
    required this.hint,
  });

  final String label;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          hint,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _PlanMealCard extends StatelessWidget {
  const _PlanMealCard({
    required this.label,
    required this.meal,
    required this.onSelect,
  });

  final String label;
  final MealSuggestion? meal;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (meal == null) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.restaurant_outlined, color: scheme.primary),
          title: Text(label),
          subtitle: const Text('Tap to choose a meal for your diet.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: onSelect,
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: AppSpacing.card,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MealIconTile(mealId: meal!.id, mealName: meal!.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meal!.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      meal!.portion,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text('${meal!.calories} kcal'),
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            'P ${meal!.proteinG.toStringAsFixed(0)}g',
                          ),
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            'C ${meal!.carbsG.toStringAsFixed(0)}g',
                          ),
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            'F ${meal!.fatG.toStringAsFixed(0)}g',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meal!.timingGuidance,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to browse & select another meal',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.expand_more_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealPickerSheet extends StatelessWidget {
  const _MealPickerSheet({
    required this.timing,
    required this.options,
    required this.currentId,
    required this.controller,
  });

  final MealTiming timing;
  final List<MealSuggestion> options;
  final String? currentId;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timing == MealTiming.preWorkout
                    ? 'Choose pre-workout meal'
                    : 'Choose post-workout meal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Macros estimated from stated portions (ICMR–NIN / USDA-style '
                'food composition). Educational — not lab analysis of your plate.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            itemCount: options.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final m = options[i];
              final selected = m.id == currentId;
              return Material(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.12)
                    : scheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.pop(context, m),
                  child: Padding(
                    padding: AppSpacing.card,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MealIconTile(mealId: m.id, mealName: m.name),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                m.portion,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${m.calories} kcal · '
                                'P ${m.proteinG.toStringAsFixed(0)}g · '
                                'C ${m.carbsG.toStringAsFixed(0)}g · '
                                'F ${m.fatG.toStringAsFixed(0)}g',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              if (m.nutritionNotes.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  m.nutritionNotes.first,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (selected)
                          Icon(Icons.check_circle, color: scheme.primary),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
