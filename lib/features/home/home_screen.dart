import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/water_glass.dart';
import '../routine/routine_widgets.dart';
import '../workout/reset_today.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final statusAsync = ref.watch(todayStatusProvider);
    final trainAnyway = ref.watch(trainAnywayProvider);
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
              ref.invalidate(todaysDayLogProvider);
              ref.invalidate(workoutsThisWeekProvider);
              ref.invalidate(todaysHydrationProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              padding: AppSpacing.page,
              children: [
                _GreetingHero(
                  firstName: firstName,
                  tip: tip,
                  workouts: weekAsync.when(
                    data: (n) => '$n workouts',
                    loading: () => '…',
                    error: (_, _) => '—',
                  ),
                  coach: profile.coachTone.label.split(' ').first,
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionLabel('Today'),
                const SizedBox(height: 10),
                const TodayRoutineCard(),
                const SizedBox(height: AppSpacing.md),
                const _HomeHydrationCard(),
                const SizedBox(height: AppSpacing.md),
                statusAsync.when(
                  loading: () => const Card(
                    child: Padding(
                      padding: AppSpacing.card,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (e, _) => Text('Could not load plan: $e'),
                  data: (status) {
                    if (status.isRestLogged && !trainAnyway) {
                      return RestDayCard(
                        kind: status.loggedKind!,
                        hasPlan: status.plan != null,
                      );
                    }
                    final plan = status.plan;
                    if (plan == null) {
                      return Card(
                        child: Padding(
                          padding: AppSpacing.cardTight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CardHeader(
                                icon: Icons.favorite_outline,
                                title: 'Today\'s check-in',
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Tell us your mood, intensity, and target muscles to generate today\'s routine.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.lg),
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
                        padding: AppSpacing.cardTight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CardHeader(
                              icon: Icons.fitness_center,
                              title: 'Today\'s plan',
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              plan.encouragement,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _CountPill(
                              label: '${plan.exercises.length} exercises ready',
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            PrimaryCta(
                              label: 'Open workout',
                              icon: Icons.fitness_center,
                              onPressed: () =>
                                  context.push('/plan/${plan.id}'),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () => context.push('/checkin'),
                                  child: const Text('Re-do'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final ok =
                                        await confirmResetToday(context, ref);
                                    if (ok && context.mounted) {
                                      context.push('/checkin');
                                    }
                                  },
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                const SectionLabel('Quick access'),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.restaurant,
                        label: 'Meals',
                        subtitle: 'Pre & post fuel',
                        onTap: () => context.go('/nutrition'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.insights,
                        label: 'Progress',
                        subtitle: 'History & charts',
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

class _GreetingHero extends StatelessWidget {
  const _GreetingHero({
    required this.firstName,
    required this.tip,
    required this.workouts,
    required this.coach,
  });

  final String firstName;
  final String tip;
  final String workouts;
  final String coach;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardTight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.22),
            scheme.primaryContainer.withValues(alpha: 0.35),
            scheme.surfaceContainerHighest.withValues(alpha: 0.9),
          ],
        ),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.25)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -10,
            child: Icon(
              Icons.bolt,
              size: 64,
              color: scheme.primary.withValues(alpha: 0.16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.35,
                      color: scheme.onSurface.withValues(alpha: 0.72),
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _HeroStat(
                      icon: Icons.local_fire_department_outlined,
                      label: 'This week',
                      value: workouts,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _HeroStat(
                      icon: Icons.record_voice_over_outlined,
                      label: 'Coach',
                      value: coach,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.65),
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
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

class _CountPill extends StatelessWidget {
  const _CountPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
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
        final goal = log.goalGlasses;
        final progress = goal <= 0 ? 0.0 : (glasses / goal).clamp(0.0, 1.0);
        final reached = goal > 0 && glasses >= goal;
        final hydroColor = AppColors.hydrationColor(progress);
        final level = AppColors.hydrationLevelLabel(progress);

        return Card(
          child: Padding(
            padding: AppSpacing.cardTight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    WaterGlass(
                      progress: progress,
                      color: hydroColor,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Water today',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: scheme.surfaceContainerHighest
                                  .withValues(alpha: 0.8),
                              valueColor:
                                  AlwaysStoppedAnimation(hydroColor),
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              reached
                                  ? 'Goal hit · $level · $glasses of $goal · ~${glasses * 250} ml'
                                  : '$level · $glasses of $goal glasses · ~${glasses * 250} ml',
                              maxLines: 1,
                              softWrap: false,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: hydroColor,
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed:
                                glasses <= 0 ? null : () => _bump(glasses - 1),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '$glasses',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => _bump(glasses + 1),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardTight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: scheme.primary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
