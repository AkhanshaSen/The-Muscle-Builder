import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/engines/food_catalog.dart';
import '../../domain/engines/meal_food_search.dart';
import '../../domain/engines/meal_timing_advisor.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';

class MealLogScreen extends ConsumerStatefulWidget {
  const MealLogScreen({super.key});

  @override
  ConsumerState<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends ConsumerState<MealLogScreen> {
  final _foodQuery = TextEditingController();
  final _notes = TextEditingController();
  DateTime _eatenAt = DateTime.now();
  MealLogTiming _timing = MealLogTiming.general;
  List<FoodItem> _catalog = const [];
  List<MealLogLineItem> _draftItems = [];
  MealLogVerdict? _lastVerdict;
  bool _loadingFoods = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    FoodCatalog.invalidate();
    final bank = await FoodCatalog.load();
    if (!mounted) return;
    setState(() {
      _catalog = bank;
      _loadingFoods = false;
    });
  }

  @override
  void dispose() {
    _foodQuery.dispose();
    _notes.dispose();
    super.dispose();
  }

  double get _kcal => _draftItems.fold(0.0, (s, i) => s + i.kcal);
  double get _protein => _draftItems.fold(0.0, (s, i) => s + i.proteinG);
  double get _carbs => _draftItems.fold(0.0, (s, i) => s + i.carbsG);
  double get _fat => _draftItems.fold(0.0, (s, i) => s + i.fatG);

  void _prepareMealLogTextInput() {
    ref.read(idleMascotHostBridgeProvider).collapseForTextInput();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _eatenAt,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(hours: 1)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eatenAt),
    );
    if (time == null || !mounted) return;
    setState(() {
      _eatenAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _addItemFromQuery() async {
    final q = _foodQuery.text.trim();
    if (q.isEmpty) return;
    final userFoods =
        await ref.read(customFoodRepositoryProvider).listUserFoods();
    final hit = MealFoodSearch.bestMatch(
      catalog: _catalog,
      userFoods: userFoods,
      query: q,
    );
    final MealLogLineItem item;
    if (hit != null) {
      item = MealFoodSearch.lineItemFromHit(hit, 1);
    } else {
      item = MealLogLineItem(
        label: q,
        quantity: 1,
        unit: 'serving',
        kcal: 0,
        proteinG: 0,
        carbsG: 0,
        fatG: 0,
        source: MealFoodSource.userInputted,
      );
    }
    if (!mounted) return;
    setState(() {
      _draftItems = [..._draftItems, item];
      _foodQuery.clear();
      _lastVerdict = null;
    });
  }

  void _addHit(MealFoodSearchHit hit) {
    setState(() {
      _draftItems = [
        ..._draftItems,
        MealFoodSearch.lineItemFromHit(hit, 1),
      ];
      _foodQuery.clear();
      _lastVerdict = null;
    });
  }

  Future<void> _save() async {
    if (_draftItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one food item')),
      );
      return;
    }
    final profile = await ref.read(profileRepositoryProvider).getProfile();
    final customFoods = ref.read(customFoodRepositoryProvider);
    final entry = await ref.read(mealLogRepositoryProvider).insert(
          eatenAt: _eatenAt,
          timing: _timing,
          items: _draftItems,
          notes: _notes.text.trim(),
        );
    for (final item in _draftItems) {
      if (item.resolvedSource == MealFoodSource.userInputted) {
        await customFoods.upsertFromLineItem(item);
      }
    }
    final verdict = MealTimingAdvisor.evaluate(
      entry: entry,
      diet: profile?.dietType ?? DietType.vegetarian,
    );
    if (!mounted) return;
    setState(() {
      _lastVerdict = verdict;
      _draftItems = [];
      _notes.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('EEE, d MMM · h:mm a');

    if (_loadingFoods) {
      return const Center(child: CircularProgressIndicator());
    }

    final userFoods = ref.watch(userCustomFoodsProvider).value ?? const [];
    final searchHits = MealFoodSearch.search(
      catalog: _catalog,
      userFoods: userFoods,
      query: _foodQuery.text,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      children: [
        Text(
          'Log what you ate',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Educational timing tips — not medical advice.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule_outlined),
          title: Text(fmt.format(_eatenAt)),
          trailing: TextButton(onPressed: _pickDateTime, child: const Text('Change')),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: MealLogTiming.values.map((t) {
            return ChoiceChip(
              label: Text(t.label),
              selected: _timing == t,
              onSelected: (_) => setState(() => _timing = t),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _foodQuery,
          decoration: InputDecoration(
            labelText: 'Food name',
            hintText: 'e.g. dal, rice, banana',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _addItemFromQuery,
            ),
          ),
          onTap: _prepareMealLogTextInput,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _addItemFromQuery(),
        ),
        if (_foodQuery.text.trim().isNotEmpty && searchHits.isEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'No catalog match — add as your food (macros optional; use notes).',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
        if (searchHits.isNotEmpty && _foodQuery.text.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: searchHits.map((hit) {
              final tag = hit.source == MealFoodSource.userInputted
                  ? ' · Yours'
                  : ' · Catalog';
              return ActionChip(
                avatar: Icon(
                  hit.source == MealFoodSource.userInputted
                      ? Icons.person_outline
                      : Icons.library_books_outlined,
                  size: 18,
                ),
                label: Text('${hit.label}$tag'),
                onPressed: () => _addHit(hit),
              );
            }).toList(),
          ),
        ],
        if (_draftItems.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'This log',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ..._draftItems.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Expanded(child: Text(item.label)),
                  Chip(
                    label: Text(
                      item.resolvedSource.label,
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              subtitle: Text(
                '${item.quantity.toStringAsFixed(item.quantity == item.quantity.roundToDouble() ? 0 : 1)} '
                '${item.unit} · '
                '${item.kcal.round()} kcal · P ${item.proteinG.round()}g',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Less',
                    onPressed: item.quantity > 0.5
                        ? () => setState(() {
                              _draftItems[i] = item.scaledToQuantity(
                                item.quantity - 0.5,
                              );
                            })
                        : null,
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                  ),
                  SizedBox(
                    width: 28,
                    child: Text(
                      item.quantity.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'More',
                    onPressed: () => setState(() {
                      _draftItems[i] =
                          item.scaledToQuantity(item.quantity + 0.5);
                    }),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() {
                      _draftItems = [..._draftItems]..removeAt(i);
                    }),
                  ),
                ],
              ),
            );
          }),
          Card(
            color: scheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Running total · ${_kcal.round()} kcal · '
                'P ${_protein.round()}g · C ${_carbs.round()}g · F ${_fat.round()}g',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _notes,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
          ),
          maxLines: 2,
          onTap: _prepareMealLogTextInput,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _save,
            child: const Text('Save log'),
          ),
        ),
        if (_lastVerdict != null) ...[
          const SizedBox(height: AppSpacing.lg),
          _VerdictCard(verdict: _lastVerdict!),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Recent logs',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Consumer(
          builder: (context, ref, _) {
            final async = ref.watch(recentMealLogsProvider);
            return async.when(
              loading: () => const SizedBox(
                height: 24,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (e, _) => Text('Could not load logs: $e'),
              data: (rows) {
                if (rows.isEmpty) {
                  return Text(
                    'No saved meals yet.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  );
                }
                return Column(
                  children: rows.map((e) {
                    final hasCustom = e.items.any(
                      (i) => i.resolvedSource == MealFoodSource.userInputted,
                    );
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        e.items.map((i) => i.label).join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${DateFormat('d MMM · h:mm a').format(e.eatenAt)} · '
                        '${e.timing.label} · ${e.totalKcal.round()} kcal'
                        '${hasCustom ? ' · incl. your foods' : ''}',
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.verdict});

  final MealLogVerdict verdict;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (verdict.score) {
      MealVerdictScore.good => const Color(0xFF3D9A6A),
      MealVerdictScore.okay => scheme.primary,
      MealVerdictScore.reconsider => const Color(0xFFC9A227),
    };
    return Card(
      color: color.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verdict.summary,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
            ),
            const SizedBox(height: 6),
            for (final b in verdict.bullets)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $b'),
              ),
            for (final s in verdict.suggestions) ...[
              const SizedBox(height: 4),
              Text(
                s,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}