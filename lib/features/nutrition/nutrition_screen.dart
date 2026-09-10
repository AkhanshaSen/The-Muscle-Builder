import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/seed/pro_nutrition_guides.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import 'meal_icon_tile.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key, this.initialTiming});

  final MealTiming? initialTiming;

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  CuisineRegion? _regionOverride;
  bool _searching = false;
  String _query = '';
  late final TextEditingController _searchController;

  Future<void> _openPharmer(FoodPharmerPointer pointer) async {
    final uri = Uri.parse(pointer.url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open ${pointer.title}')),
      );
    }
  }

  void _openSearch() {
    setState(() => _searching = true);
  }

  void _closeSearch() {
    _searchController.clear();
    setState(() {
      _searching = false;
      _query = '';
    });
  }

  @override
  void initState() {
    super.initState();
    final initialIndex =
        widget.initialTiming == MealTiming.postWorkout ? 1 : 0;
    _tabs = TabController(length: 3, vsync: this, initialIndex: initialIndex);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final onPharmerTab = _tabs.index == 2;
    final showSearchAction = !onPharmerTab;

    return Scaffold(
      appBar: AppBar(
        title: _searching && showSearchAction
            ? TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search meals or ingredients',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v),
              )
            : const Text('Nutrition'),
        toolbarHeight: 48,
        scrolledUnderElevation: 1,
        actions: [
          if (showSearchAction)
            IconButton(
              tooltip: _searching ? 'Close search' : 'Search',
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: _searching ? _closeSearch : _openSearch,
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(height: 40, text: 'Pre-workout'),
            Tab(height: 40, text: 'Post-workout'),
            Tab(height: 40, text: 'Food Pharmer'),
          ],
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (profile) {
          if (profile == null) {
            return const EmptyState(
              icon: Icons.restaurant,
              title: 'No profile',
              message: 'Complete onboarding to get meal suggestions.',
            );
          }

          final region = _regionOverride ?? profile.cuisineRegion;

          return TabBarView(
            controller: _tabs,
            children: [
              NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverToBoxAdapter(
                    child: _NutritionFiltersHeader(
                      profile: profile,
                      region: region,
                      query: _query,
                      onRegionChanged: (r) =>
                          setState(() => _regionOverride = r),
                    ),
                  ),
                ],
                body: _MealList(
                  timing: MealTiming.preWorkout,
                  profile: profile,
                  region: region,
                  query: _query,
                  onClearSearch: _closeSearch,
                ),
              ),
              NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverToBoxAdapter(
                    child: _NutritionFiltersHeader(
                      profile: profile,
                      region: region,
                      query: _query,
                      onRegionChanged: (r) =>
                          setState(() => _regionOverride = r),
                    ),
                  ),
                ],
                body: _MealList(
                  timing: MealTiming.postWorkout,
                  profile: profile,
                  region: region,
                  query: _query,
                  onClearSearch: _closeSearch,
                ),
              ),
              _FoodPharmerTab(onOpenPharmer: _openPharmer),
            ],
          );
        },
      ),
    );
  }
}

class _NutritionFiltersHeader extends ConsumerWidget {
  const _NutritionFiltersHeader({
    required this.profile,
    required this.region,
    required this.query,
    required this.onRegionChanged,
  });

  final UserProfile profile;
  final CuisineRegion region;
  final String query;
  final ValueChanged<CuisineRegion> onRegionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proteinFocusOn = MealIngredientChip.proteinFocus.every(
      (c) => profile.preferredIngredients.contains(c.name),
    );
    final searching = query.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 6, AppSpacing.md, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  profile.dietType.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              FilterChip(
                visualDensity: VisualDensity.compact,
                label: Text(profile.showMacros ? 'Macros on' : 'Macros off'),
                selected: profile.showMacros,
                onSelected: (v) async {
                  await ref.read(profileRepositoryProvider).saveProfile(
                        profile.copyWith(showMacros: v),
                      );
                },
              ),
            ],
          ),
          if (!searching) ...[
            const SizedBox(height: AppSpacing.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final r in CuisineRegion.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        label: Text(r.label),
                        selected: region == r,
                        onSelected: (_) => onRegionChanged(r),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'I want to eat',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      visualDensity: VisualDensity.compact,
                      avatar: const Icon(Icons.bolt, size: 16),
                      label: const Text('Protein focus'),
                      selected: proteinFocusOn,
                      onSelected: (on) async {
                        final next =
                            Set<String>.from(profile.preferredIngredients);
                        for (final c in MealIngredientChip.proteinFocus) {
                          if (on) {
                            next.add(c.name);
                          } else {
                            next.remove(c.name);
                          }
                        }
                        await ref.read(profileRepositoryProvider).saveProfile(
                              profile.copyWith(
                                preferredIngredients: next.toList(),
                              ),
                            );
                      },
                    ),
                  ),
                  for (final chip in MealIngredientChip.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        visualDensity: VisualDensity.compact,
                        label: Text(chip.label),
                        selected:
                            profile.preferredIngredients.contains(chip.name),
                        onSelected: (on) async {
                          final next =
                              List<String>.from(profile.preferredIngredients);
                          if (on) {
                            if (!next.contains(chip.name)) next.add(chip.name);
                          } else {
                            next.remove(chip.name);
                          }
                          await ref.read(profileRepositoryProvider).saveProfile(
                                profile.copyWith(preferredIngredients: next),
                              );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Meals',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (searching) ...[
            const SizedBox(height: 2),
            Text(
              'Searching “${query.trim()}” · region & chips ignored',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FoodPharmerTab extends StatelessWidget {
  const _FoodPharmerTab({required this.onOpenPharmer});

  final Future<void> Function(FoodPharmerPointer pointer) onOpenPharmer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: AppSpacing.page,
      children: [
        Text(
          'Label & shopping pointers',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Educational · Food Pharmer · not medical advice. Opens in your browser.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.tonalIcon(
          onPressed: () => onOpenPharmer(
            const FoodPharmerPointer(
              id: 'fp_hub',
              title: 'Food Pharmer',
              tip: '',
              url: 'https://foodpharmer.health/',
            ),
          ),
          icon: const Icon(Icons.open_in_new),
          label: const Text('Open Food Pharmer site'),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...foodPharmerPointers.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _FoodPharmerListTile(
              pointer: p,
              onTap: () => onOpenPharmer(p),
            ),
          ),
        ),
      ],
    );
  }
}

class _FoodPharmerListTile extends StatelessWidget {
  const _FoodPharmerListTile({required this.pointer, required this.onTap});

  final FoodPharmerPointer pointer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(Icons.verified_outlined, color: scheme.primary),
        title: Text(
          pointer.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(pointer.tip),
        trailing: Icon(Icons.open_in_new, color: scheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

class _MealList extends ConsumerWidget {
  const _MealList({
    required this.timing,
    required this.profile,
    required this.region,
    required this.query,
    required this.onClearSearch,
  });

  final MealTiming timing;
  final UserProfile profile;
  final CuisineRegion region;
  final String query;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searching = query.trim().isNotEmpty;
    return FutureBuilder<List<MealSuggestion>>(
      key: ValueKey(
        '${timing.name}_${region.name}_${profile.preferredIngredients.join(',')}_$query',
      ),
      future: ref.read(nutritionRepositoryProvider).suggestionsFor(
            timing: timing,
            dietType: profile.dietType,
            allergies: profile.allergies,
            region: region,
            preferredIngredients: profile.preferredIngredients,
            query: query,
          ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final meals = snapshot.data!;
        if (meals.isEmpty) {
          if (searching) {
            return EmptyState(
              icon: Icons.search_off,
              title: 'No meals match "${query.trim()}"',
              message: 'Try another name or ingredient, or clear search.',
              action: TextButton(
                onPressed: onClearSearch,
                child: const Text('Clear search'),
              ),
            );
          }
          return EmptyState(
            icon: Icons.no_meals_outlined,
            title: 'No matches',
            message: profile.preferredIngredients.isEmpty
                ? 'Try changing region filters or allergies in Profile settings.'
                : 'Widen chips or clear preferences to see more meals.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          itemCount: searching ? meals.length + 1 : meals.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            if (searching && index == 0) {
              return Text(
                '${meals.length} result${meals.length == 1 ? '' : 's'} for "${query.trim()}"',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              );
            }
            final m = meals[searching ? index - 1 : index];
            final unlocked = profile.unlockedRecipeIds.contains(m.id);
            final scheme = Theme.of(context).colorScheme;
            return Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                  childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  leading: MealIconTile(
                    mealId: m.id,
                    mealName: m.name,
                    size: 44,
                  ),
                  title: Text(
                    m.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  subtitle: Text(
                    '${m.calories} kcal · P ${m.proteinG.toStringAsFixed(0)}g · '
                    'C ${m.carbsG.toStringAsFixed(0)}g · F ${m.fatG.toStringAsFixed(0)}g',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        m.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${m.portion} · ${m.timingGuidance}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (profile.showMacros && m.nutritionNotes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          m.nutritionNotes.first,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: unlocked && m.hasUnlockableRecipe
                          ? TextButton.icon(
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () => _showRecipe(context, m),
                              icon: const Icon(Icons.menu_book_outlined, size: 18),
                              label: const Text('View recipe'),
                            )
                          : OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () => _onUnlock(context, ref, m),
                              icon: Icon(
                                unlocked
                                    ? Icons.lock_open
                                    : Icons.lock_outline,
                                size: 18,
                              ),
                              label: Text(
                                unlocked
                                    ? 'Recipe coming soon'
                                    : 'Unlock recipe',
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onUnlock(
    BuildContext context,
    WidgetRef ref,
    MealSuggestion meal,
  ) async {
    if (!profile.unlockedRecipeIds.contains(meal.id)) {
      final next = [...profile.unlockedRecipeIds, meal.id];
      await ref.read(profileRepositoryProvider).saveProfile(
            profile.copyWith(unlockedRecipeIds: next),
          );
    }

    if (!context.mounted) return;

    if (meal.hasUnlockableRecipe) {
      _showRecipe(context, meal);
    } else {
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Recipe unlocked in your library — full steps for this meal are coming soon.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Portion for now: ${meal.portion}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showRecipe(BuildContext context, MealSuggestion meal) {
    final recipe = meal.recipe;
    if (recipe == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, controller) {
            final sheetWidth = MediaQuery.sizeOf(context).width;
            // Keep header template (text left / art right); enlarge subject only.
            final artSize =
                ((sheetWidth - 48) * 0.44).clamp(188.0, 236.0);

            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Portion · ${meal.portion} · ~${recipe.prepMinutes} min prep',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                ),
                          ),
                          if (meal.description.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              meal.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Transform.translate(
                      offset: const Offset(10, -4),
                      child: MealIconTile(
                        mealId: meal.id,
                        mealName: meal.name,
                        size: artSize,
                        bordered: false,
                        softGlow: true,
                        contentScale: 1.45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...recipe.ingredients.map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $i'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Steps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...recipe.steps.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text('${e.key + 1}. ${e.value}'),
                      ),
                    ),
              ],
            );
          },
        );
      },
    );
  }
}
