import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';
import '../routine/routine_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final planAsync = ref.watch(todaysPlanProvider);
    final weekAsync = ref.watch(workoutsThisWeekProvider);

    return Scaffold(
      appBar: AppBar(
        title: profileAsync.when(
          data: (p) => Text(p?.journeyName ?? AppConstants.appName),
          loading: () => const Text(AppConstants.appName),
          error: (_, _) => const Text(AppConstants.appName),
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile'));
          }
          final tip = EncouragementCopy.tipOfDay(profile.coachTone.name);
          final firstName = profile.name.split(' ').first;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(todaysPlanProvider);
              ref.invalidate(workoutsThisWeekProvider);
              ref.invalidate(todaysHydrationProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Hey, $firstName',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  tip,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: StatChip(
                        label: 'This week',
                        value: weekAsync.when(
                          data: (n) => '$n workouts',
                          loading: () => '…',
                          error: (_, _) => '—',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatChip(
                        label: 'Coach',
                        value: profile.coachTone.label.split(' ').first,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const TodayRoutineCard(),
                const SizedBox(height: 16),
                const _HomeHydrationCard(),
                const SizedBox(height: 16),
                planAsync.when(
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (e, _) => Text('Could not load plan: $e'),
                  data: (plan) {
                    if (plan == null) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s check-in',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tell us your mood, intensity, and target muscles to generate today\'s routine.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              PrimaryCta(
                                label: 'Start check-in',
                                icon: Icons.favorite_outline,
                                onPressed: () => context.push('/checkin'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s plan',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              plan.encouragement,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${plan.exercises.length} exercises ready',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            PrimaryCta(
                              label: 'Open workout',
                              icon: Icons.fitness_center,
                              onPressed: () => context.push('/plan/${plan.id}'),
                            ),
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: () => context.push('/checkin'),
                              child: const Text('Re-do check-in'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.restaurant,
                        label: 'Meals',
                        onTap: () => context.go('/nutrition'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.insights,
                        label: 'Progress',
                        onTap: () => context.go('/progress'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeHydrationCard extends ConsumerStatefulWidget {
  const _HomeHydrationCard();

  @override
  ConsumerState<_HomeHydrationCard> createState() => _HomeHydrationCardState();
}

class _HomeHydrationCardState extends ConsumerState<_HomeHydrationCard> {
  int? _pendingGlasses;

  @override
  Widget build(BuildContext context) {
    final hydroAsync = ref.watch(todaysHydrationProvider);
    final scheme = Theme.of(context).colorScheme;

    return hydroAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (log) {
        final glasses = _pendingGlasses ?? log.glasses;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.water_drop_outlined, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Water today',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        '$glasses / ${log.goalGlasses} glasses · ~${glasses * 250} ml',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: glasses <= 0
                      ? null
                      : () => _bump(glasses - 1),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$glasses',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                IconButton(
                  onPressed: () => _bump(glasses + 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _bump(int next) async {
    setState(() => _pendingGlasses = next);
    try {
      await ref.read(metricsRepositoryProvider).setGlasses(
            DateTime.now(),
            next,
          );
      ref.read(metricsTickProvider.notifier).state++;
      if (mounted) setState(() => _pendingGlasses = null);
    } catch (_) {
      if (mounted) setState(() => _pendingGlasses = null);
    }
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
