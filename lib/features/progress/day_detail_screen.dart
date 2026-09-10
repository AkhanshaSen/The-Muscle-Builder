import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/gym_session_sizing.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../routine/routine_widgets.dart';

class DayDetailScreen extends ConsumerStatefulWidget {
  const DayDetailScreen({super.key, required this.date});

  final DateTime date;

  static String pathFor(DateTime d) {
    final key = DateTime(d.year, d.month, d.day);
    final y = key.year.toString().padLeft(4, '0');
    final m = key.month.toString().padLeft(2, '0');
    final day = key.day.toString().padLeft(2, '0');
    return '/day/$y-$m-$day';
  }

  @override
  ConsumerState<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends ConsumerState<DayDetailScreen> {
  late Future<DayActivitySnapshot> _future;
  DayActivitySnapshot? _snapshot;
  DayKind? _pendingKind;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<DayActivitySnapshot> _load() {
    final key =
        DateTime(widget.date.year, widget.date.month, widget.date.day);
    return ref.read(workoutRepositoryProvider).getDayActivity(
          key,
          ref.read(routineRepositoryProvider).ensureDayLog,
        );
  }

  Future<void> _setDayKind(DateTime key, DayKind k) async {
    setState(() => _pendingKind = k);
    try {
      final updated = await ref.read(routineRepositoryProvider).logDay(
            date: key,
            actual: k,
            note: k == DayKind.skip ? 'Holiday / gym closed' : '',
          );
      ref.read(dayLogsTickProvider.notifier).state++;
      if (!mounted) return;
      final base = _snapshot;
      setState(() {
        _pendingKind = null;
        if (base != null) {
          _snapshot = DayActivitySnapshot(
            date: base.date,
            dayLog: updated,
            sessions: base.sessions,
            plan: base.plan,
            hydration: base.hydration,
          );
        }
      });
    } catch (_) {
      if (mounted) setState(() => _pendingKind = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final key =
        DateTime(widget.date.year, widget.date.month, widget.date.day);
    final titleFmt = DateFormat('EEEE, d MMM y');
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(titleFmt.format(key)),
        leading: const NestedBackButton(fallbackLocation: '/progress'),
      ),
      body: FutureBuilder<DayActivitySnapshot>(
        future: _future,
        builder: (context, snap) {
          final data = _snapshot ?? snap.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_snapshot == null && snap.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _snapshot == null) {
                setState(() => _snapshot = snap.data);
              }
            });
          }
          final log = data.dayLog;
          final selected = _pendingKind ?? log.actualKind;
          final effective = selected ?? log.plannedKind;

          return ListView(
            padding: AppSpacing.page,
            children: [
              Card(
                child: Padding(
                  padding: AppSpacing.card,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: dayKindColor(scheme, effective)
                            .withValues(alpha: 0.2),
                        child: Icon(
                          dayKindIcon(effective),
                          color: dayKindColor(scheme, effective),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Planned ${log.plannedKind.label}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              selected == null
                                  ? 'Not logged yet'
                                  : 'Logged ${selected.label}'
                                      '${log.note.isEmpty ? '' : ' · ${log.note}'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _DayHydrationRow(date: key),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Log this day',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final k in DayKind.logKinds)
                    ChoiceChip(
                      avatar: Icon(dayKindIcon(k), size: 16),
                      label: Text(k.label),
                      selected: selected == k,
                      onSelected: (_) => _setDayKind(key, k),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Skip = holiday or gym closed. Or pick Rest / Cheat to log something else.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Fuel & plan',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              if (data.plan != null)
                Card(
                  child: Padding(
                    padding: AppSpacing.card,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data.plan!.exercises.length} exercises · '
                          '${data.plan!.gymMinutes} min gym',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Burn ~${GymSessionSizing.activeBurnKcal(data.plan!)} kcal · '
                          'Meals ${data.plan!.mealFuelKcal} kcal · '
                          'P ${data.plan!.mealProteinG.toStringAsFixed(0)}g',
                        ),
                        if (data.plan!.preMeal != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Pre: ${data.plan!.preMeal!.name} · '
                            '${data.plan!.preMeal!.calories} kcal · '
                            'P ${data.plan!.preMeal!.proteinG.toStringAsFixed(0)}g',
                          ),
                        ],
                        if (data.plan!.postMeal != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Post: ${data.plan!.postMeal!.name} · '
                            '${data.plan!.postMeal!.calories} kcal · '
                            'P ${data.plan!.postMeal!.proteinG.toStringAsFixed(0)}g',
                          ),
                        ],
                        TextButton(
                          onPressed: () =>
                              context.push('/plan/${data.plan!.id}'),
                          child: const Text('Open plan'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Card(
                  child: ListTile(
                    dense: true,
                    title: Text('No workout plan this day'),
                    subtitle: Text('Check-in generates a plan on gym days.'),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sessions',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              if (data.sessions.isEmpty)
                const Card(
                  child: ListTile(
                    dense: true,
                    title: Text('No sessions'),
                    subtitle: Text('Finish a workout to see sets here.'),
                  ),
                )
              else
                ...data.sessions.map((s) {
                  final mins = s.duration?.inMinutes;
                  final muscles = s.muscleGroups.isEmpty
                      ? 'Mixed'
                      : s.muscleGroups.map((m) => m.label).join(', ');
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        s.completed ? Icons.check_circle : Icons.timelapse,
                        color: scheme.primary,
                      ),
                      title: Text(
                        s.completed ? 'Completed session' : 'In progress',
                      ),
                      subtitle: Text(
                        '$muscles · ${mins ?? '—'} min · '
                        '${s.setLogs.where((l) => l.completed).length} sets',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/session/${s.id}'),
                    ),
                  );
                }),
              const SizedBox(height: AppSpacing.sm),
              Card(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                child: Padding(
                  padding: AppSpacing.card,
                  child: Text(
                    'Summary: ${data.setsCompleted} sets · '
                    '${data.totalSessionMinutes} min · '
                    '${data.sessions.length} session(s)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DayHydrationRow extends ConsumerWidget {
  const _DayHydrationRow({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(metricsTickProvider);
    return FutureBuilder(
      future: ref.read(metricsRepositoryProvider).getOrCreateHydration(date),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        final log = snap.data!;
        return Card(
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.water_drop_outlined),
            title: const Text('Water'),
            subtitle: Text('${log.glasses} / ${log.goalGlasses} glasses'),
            trailing: Text('~${log.glasses * 250} ml'),
          ),
        );
      },
    );
  }
}
