import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../nutrition/meal_icon_tile.dart';
import '../routine/routine_widgets.dart';

bool _isYogurtMeal(MealSuggestion m) {
  final key = '${m.id}_${m.name}_${m.description}'.toLowerCase();
  return key.contains('curd') ||
      key.contains('dahi') ||
      key.contains('yogurt') ||
      key.contains('yoghurt') ||
      key.contains('chaas') ||
      key.contains('buttermilk') ||
      key.contains('raita') ||
      key.contains('doi');
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _save(UserProfile profile) async {
    await ref.read(profileRepositoryProvider).saveProfile(profile);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final scheme = Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'You'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (profile) {
          if (profile == null) {
            return const EmptyState(
              icon: Icons.person_outline,
              title: 'No profile',
              message: 'Complete onboarding first.',
            );
          }

          return TabBarView(
            controller: _tabs,
            children: [
              FutureBuilder<List<MealSuggestion>>(
                future: _yogurtPicks(profile),
                builder: (context, mealSnap) {
                  final yogurtMeals =
                      mealSnap.data ?? const <MealSuggestion>[];
                  return _YouTab(
                    profile: profile,
                    yogurtMeals: yogurtMeals,
                    bottomPad: bottomPad,
                    onEditNames: () => _editNames(profile),
                    onEditStory: () => _editStory(profile),
                    onEditBody: () => _editBody(profile),
                    onSave: _save,
                    onOpenGuides: () => context.push('/guides'),
                    onOpenNutrition: () => context.go('/nutrition'),
                  );
                },
              ),
              _SettingsTab(
                profile: profile,
                scheme: scheme,
                bottomPad: bottomPad,
                onSave: _save,
                onExport: () => _exportBackup(context),
                onImport: () => _importBackup(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _exportBackup(BuildContext context) async {
    try {
      await ref.read(backupServiceProvider).shareExport();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup shared / saved')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  Future<void> _importBackup(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import backup?'),
        content: const Text(
          'Merges by id into this device. Matching rows keep the newer '
          'updatedAt when present. Photo files are path-only — re-add images if missing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      final raw = await ref.read(backupServiceProvider).pickImportFile();
      if (raw == null) return;
      final count =
          await ref.read(backupServiceProvider).importFromJsonString(raw);
      ref.invalidate(profileProvider);
      ref.invalidate(todaysPlanProvider);
      ref.invalidate(completedSessionsProvider);
      ref.invalidate(weeklyRoutineProvider);
      ref.read(metricsTickProvider.notifier).state++;
      ref.read(dayLogsTickProvider.notifier).state++;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imported $count records')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: $e')),
      );
    }
  }

  Future<List<MealSuggestion>> _yogurtPicks(UserProfile profile) async {
    final nutrition = ref.read(nutritionRepositoryProvider);
    final pre = await nutrition.suggestionsFor(
      timing: MealTiming.preWorkout,
      dietType: profile.dietType,
      allergies: profile.allergies,
      region: profile.cuisineRegion,
    );
    final post = await nutrition.suggestionsFor(
      timing: MealTiming.postWorkout,
      dietType: profile.dietType,
      allergies: profile.allergies,
      region: profile.cuisineRegion,
    );
    final picks = [...pre, ...post].where(_isYogurtMeal).toList();
    picks.sort((a, b) => a.timing.index.compareTo(b.timing.index));
    return picks.take(8).toList();
  }

  Future<void> _editNames(UserProfile profile) async {
    final nameCtrl = TextEditingController(text: profile.name);
    final journeyCtrl = TextEditingController(text: profile.journeyName);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: journeyCtrl,
              decoration: const InputDecoration(labelText: 'Journey name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == true) {
      await _save(
        profile.copyWith(
          name: nameCtrl.text.trim().isEmpty
              ? profile.name
              : nameCtrl.text.trim(),
          journeyName: journeyCtrl.text.trim().isEmpty
              ? profile.journeyName
              : journeyCtrl.text.trim(),
        ),
      );
    }
  }

  Future<void> _editBody(UserProfile profile) async {
    final weightCtrl =
        TextEditingController(text: profile.weightKg.toStringAsFixed(1));
    final heightCtrl =
        TextEditingController(text: profile.heightCm.toStringAsFixed(0));
    final ageCtrl = TextEditingController(text: '${profile.age}');
    var gender = profile.gender;
    var activity = profile.activityLevel;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Body & lifestyle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weightCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: heightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Gender>(
                  initialValue: gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: Gender.values
                      .map(
                        (g) => DropdownMenuItem(
                          value: g,
                          child: Text(g.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setLocal(() => gender = v);
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<ActivityLevel>(
                  initialValue: activity,
                  decoration:
                      const InputDecoration(labelText: 'Activity level'),
                  items: ActivityLevel.values
                      .map(
                        (a) => DropdownMenuItem(
                          value: a,
                          child: Text(a.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setLocal(() => activity = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (result != true) return;
    await _save(
      profile.copyWith(
        weightKg: double.tryParse(weightCtrl.text.trim()) ?? profile.weightKg,
        heightCm: double.tryParse(heightCtrl.text.trim()) ?? profile.heightCm,
        age: int.tryParse(ageCtrl.text.trim()) ?? profile.age,
        gender: gender,
        activityLevel: activity,
      ),
    );
  }

  Future<void> _editStory(UserProfile profile) async {
    final whyCtrl = TextEditingController(text: profile.fitnessWhy);
    final aspirationCtrl = TextEditingController(text: profile.aspiration);
    final targetCtrl = TextEditingController(
      text: profile.targetWeightKg?.toStringAsFixed(1) ?? '',
    );
    var goal = profile.primaryGoal;
    var days = profile.weeklyTrainingDays.clamp(1, 7);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Goals & motivation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<PrimaryGoal>(
                  initialValue: goal,
                  decoration: const InputDecoration(labelText: 'Primary goal'),
                  items: PrimaryGoal.values
                      .map(
                        (g) => DropdownMenuItem(
                          value: g,
                          child: Text(g.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setLocal(() => goal = v);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Training days / week: $days',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Slider(
                  value: days.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: '$days',
                  onChanged: (v) => setLocal(() => days = v.round()),
                ),
                TextField(
                  controller: targetCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Target weight (kg)',
                    hintText: 'Optional',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: aspirationCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Aspiration',
                    hintText: 'e.g. Feel strong for my kids / run a 10K…',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: whyCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Why fitness?',
                    hintText:
                        'What drives you on hard days? Energy, confidence, health…',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (result != true) return;
    final targetRaw = targetCtrl.text.trim();
    final target = double.tryParse(targetRaw);
    await _save(
      profile.copyWith(
        primaryGoal: goal,
        weeklyTrainingDays: days,
        aspiration: aspirationCtrl.text.trim(),
        fitnessWhy: whyCtrl.text.trim(),
        targetWeightKg: target,
        clearTargetWeight: targetRaw.isEmpty,
      ),
    );
  }
}

class _YouTab extends StatelessWidget {
  const _YouTab({
    required this.profile,
    required this.yogurtMeals,
    required this.bottomPad,
    required this.onEditNames,
    required this.onEditStory,
    required this.onEditBody,
    required this.onSave,
    required this.onOpenGuides,
    required this.onOpenNutrition,
  });

  final UserProfile profile;
  final List<MealSuggestion> yogurtMeals;
  final double bottomPad;
  final VoidCallback onEditNames;
  final VoidCallback onEditStory;
  final VoidCallback onEditBody;
  final Future<void> Function(UserProfile) onSave;
  final VoidCallback onOpenGuides;
  final VoidCallback onOpenNutrition;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasStory =
        profile.fitnessWhy.isNotEmpty || profile.aspiration.isNotEmpty;
    final delta = profile.targetWeightKg == null
        ? null
        : profile.targetWeightKg! - profile.weightKg;

    return ListView(
      padding: EdgeInsets.fromLTRB(14, 8, 14, 20 + bottomPad),
      children: [
        _JourneyHero(profile: profile, onEdit: onEditNames),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'About you',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: onEditBody,
                      child: const Text('Edit'),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _InfoChip(
                      icon: Icons.cake_outlined,
                      label: 'Age ${profile.age}',
                    ),
                    _InfoChip(
                      icon: Icons.wc_outlined,
                      label: profile.gender.label,
                    ),
                    _InfoChip(
                      icon: Icons.monitor_weight_outlined,
                      label: '${profile.weightKg.toStringAsFixed(1)} kg',
                    ),
                    _InfoChip(
                      icon: Icons.height,
                      label: '${profile.heightCm.toStringAsFixed(0)} cm',
                    ),
                    _InfoChip(
                      icon: Icons.directions_walk,
                      label: profile.activityLevel.label,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Goals & drive',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: onEditStory,
                      child: Text(hasStory ? 'Edit' : 'Add'),
                    ),
                  ],
                ),
                Text(
                  profile.primaryGoal.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.primary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.primaryGoal.blurb,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _InfoChip(
                      icon: Icons.event_repeat,
                      label: '${profile.weeklyTrainingDays} days / week',
                    ),
                    if (profile.targetWeightKg != null)
                      _InfoChip(
                        icon: Icons.flag_outlined,
                        label:
                            'Target ${profile.targetWeightKg!.toStringAsFixed(1)} kg'
                            '${delta == null ? '' : ' (${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)})'}',
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Aspiration',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.aspiration.isEmpty
                      ? 'What does “fit” look like for you long-term? Tap Add.'
                      : profile.aspiration,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: profile.aspiration.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: profile.aspiration.isEmpty
                            ? scheme.onSurfaceVariant
                            : null,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Why fitness?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.fitnessWhy.isEmpty
                      ? 'Your personal why keeps hard days honest. Tap Add.'
                      : profile.fitnessWhy,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: profile.fitnessWhy.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: profile.fitnessWhy.isEmpty
                            ? scheme.onSurfaceVariant
                            : null,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Primary focus',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: PrimaryGoal.values.map((g) {
                    return ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(g.label),
                      selected: profile.primaryGoal == g,
                      onSelected: (_) => onSave(profile.copyWith(primaryGoal: g)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Yogurt & dahi',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              onPressed: onOpenNutrition,
              child: const Text('All meals'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (yogurtMeals.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                profile.allergies.contains(Allergy.lactose)
                    ? 'Lactose avoided — open Nutrition for dairy-free fuel.'
                    : 'No yogurt picks yet. Refresh Nutrition.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          )
        else
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: yogurtMeals.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final meal = yogurtMeals[i];
                return _YogurtFuelCard(
                  meal: meal,
                  onTap: onOpenNutrition,
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            dense: true,
            leading: Icon(Icons.menu_book_outlined, color: scheme.primary),
            title: const Text('Coach-approved reading'),
            subtitle: const Text('Food Pharmer · ACSM · EatRight…'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOpenGuides,
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.profile,
    required this.scheme,
    required this.bottomPad,
    required this.onSave,
    required this.onExport,
    required this.onImport,
  });

  final UserProfile profile;
  final ColorScheme scheme;
  final double bottomPad;
  final Future<void> Function(UserProfile) onSave;
  final VoidCallback onExport;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(14, 8, 14, 20 + bottomPad),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        const WeeklyRoutineEditor(),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalization',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    for (final hex in const [
                      '#FF6B35',
                      '#4CAF50',
                      '#2196F3',
                      '#9C27B0',
                      '#FFC107',
                      '#E91E63',
                    ])
                      GestureDetector(
                        onTap: () => onSave(profile.copyWith(themeColorHex: hex)),
                        child: Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse('FF${hex.substring(1)}', radix: 16),
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: profile.themeColorHex.toUpperCase() == hex
                                  ? scheme.onSurface
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: ThemePreference.values.map((t) {
                    return ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(t.label),
                      selected: profile.themePreference == t,
                      onSelected: (_) =>
                          onSave(profile.copyWith(themePreference: t)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  'Coach personality',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: CoachTone.values.map((t) {
                    return ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(t.shortLabel),
                      selected: profile.coachTone == t,
                      onSelected: (_) =>
                          onSave(profile.copyWith(coachTone: t)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Training & diet',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Experience'),
                  trailing: DropdownButton<ExperienceLevel>(
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    value: profile.experience,
                    items: ExperienceLevel.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.label),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) onSave(profile.copyWith(experience: v));
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Diet type'),
                  trailing: DropdownButton<DietType>(
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    value: profile.dietType,
                    items: DietType.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.label),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) onSave(profile.copyWith(dietType: v));
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Cuisine'),
                  trailing: DropdownButton<CuisineRegion>(
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    value: profile.cuisineRegion,
                    items: CuisineRegion.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.label),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        onSave(profile.copyWith(cuisineRegion: v));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Equipment',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: Equipment.values.map((e) {
                    final on = profile.equipment.contains(e);
                    return FilterChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(e.label),
                      selected: on,
                      onSelected: (v) {
                        final next = List<Equipment>.from(profile.equipment);
                        if (v) {
                          next.add(e);
                        } else if (next.length > 1) {
                          next.remove(e);
                        }
                        onSave(profile.copyWith(equipment: next));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Allergies',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: Allergy.values.map((a) {
                    final on = profile.allergies.contains(a);
                    return FilterChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(a.label),
                      selected: on,
                      onSelected: (v) {
                        final next = List<Allergy>.from(profile.allergies);
                        if (v) {
                          next.add(a);
                        } else {
                          next.remove(a);
                        }
                        onSave(profile.copyWith(allergies: next));
                      },
                    );
                  }).toList(),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Show meal macros'),
                  value: profile.showMacros,
                  onChanged: (v) => onSave(profile.copyWith(showMacros: v)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backup',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'JSON export/import for reinstall or device move. Not live sync.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onExport,
                        icon: const Icon(Icons.upload_file, size: 18),
                        label: const Text('Export'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: onImport,
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Import'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          'Local-first · JSON backup',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Text(
          'Designed & built by ${AppConstants.developerName}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.38),
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
              ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _JourneyHero extends StatelessWidget {
  const _JourneyHero({required this.profile, required this.onEdit});

  final UserProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.22),
            scheme.primaryContainer.withValues(alpha: 0.35),
            scheme.surfaceContainerHighest.withValues(alpha: 0.9),
          ],
        ),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -4,
            top: -4,
            child: Icon(
              Icons.icecream_outlined,
              size: 56,
              color: scheme.primary.withValues(alpha: 0.18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit',
                    visualDensity: VisualDensity.compact,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
              Text(
                profile.journeyName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${profile.weightKg.toStringAsFixed(0)} kg · '
                '${profile.heightCm.toStringAsFixed(0)} cm · '
                'age ${profile.age}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _YogurtFuelCard extends StatelessWidget {
  const _YogurtFuelCard({required this.meal, required this.onTap});

  final MealSuggestion meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 124,
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MealIconTile(
                  mealId: meal.id,
                  mealName: meal.name,
                  size: 44,
                ),
                const SizedBox(height: 6),
                Text(
                  meal.timing.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  meal.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                ),
                Text(
                  '${meal.calories} kcal',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
