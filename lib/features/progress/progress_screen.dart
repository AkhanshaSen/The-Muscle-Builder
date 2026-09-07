import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/gym_session_sizing.dart';
import '../../domain/models/models.dart';
import '../routine/routine_widgets.dart';
import 'day_detail_screen.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(completedSessionsProvider);
    final weekAsync = ref.watch(workoutsThisWeekProvider);
    final setsTodayAsync = ref.watch(setsTodayProvider);
    final setsWeekAsync = ref.watch(setsThisWeekProvider);
    final profileAsync = ref.watch(profileProvider);
    final planAsync = ref.watch(todaysPlanProvider);
    final weekDaysAsync = ref.watch(thisWeekDayLogsProvider);
    final analysisAsync = ref.watch(routineAnalysisProvider);
    final dayLogsAsync = ref.watch(recentDayLogsProvider);
    final fuelAsync = ref.watch(recentFuelHistoryProvider);
    final dayFmt = DateFormat('EEE d');
    final mealDayFmt = DateFormat('EEE d MMM');
    final scheme = Theme.of(context).colorScheme;

    final setsToday = setsTodayAsync.asData?.value ?? 0;
    final name = profileAsync.asData?.value?.name ?? '';
    final tone = profileAsync.asData?.value?.coachTone.name ?? 'friendly';
    final cheer = setsToday == 0
        ? EncouragementCopy.tipOfDay(tone)
        : EncouragementCopy.forSetComplete(
            setNumber: setsToday,
            totalSetsInSession: setsToday,
            tone: tone,
            name: name,
            verdictLabel: 'Logged',
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        toolbarHeight: 48,
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (sessions) {
          final muscles = <String>{};
          for (final s in sessions) {
            for (final m in s.muscleGroups) {
              muscles.add(m.label);
            }
          }
          final recentSessions = sessions.take(4).toList();
          final recentDays = (dayLogsAsync.asData?.value ?? const <DayLog>[])
              .take(8)
              .toList();
          final fuelEntries = (fuelAsync.asData?.value ??
                  const <FuelHistoryEntry>[])
              .where(
                (e) =>
                    (e.preMealName != null && e.preMealName!.isNotEmpty) ||
                    (e.postMealName != null && e.postMealName!.isNotEmpty),
              )
              .take(8)
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 20),
            children: [
              Card(
                color: scheme.primaryContainer.withValues(alpha: 0.3),
                child: ListTile(
                  dense: true,
                  leading: Icon(Icons.emoji_events, color: scheme.primary),
                  title: const Text('Keep going'),
                  subtitle: Text(cheer, maxLines: 2),
                ),
              ),
              if (planAsync.asData?.value case final plan?) ...[
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Burn ~${GymSessionSizing.activeBurnKcal(plan)} · '
                          'Meals ${plan.mealFuelKcal} kcal · '
                          'P ${plan.mealProteinG.toStringAsFixed(0)}g · '
                          '${plan.gymMinutes} min',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () =>
                              context.push(DayDetailScreen.pathFor(DateTime.now())),
                          child: const Text('Open today\'s detail'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: StatChip(
                      label: 'Sets today',
                      value: '${setsTodayAsync.asData?.value ?? '…'}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatChip(
                      label: 'Sets week',
                      value: '${setsWeekAsync.asData?.value ?? '…'}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: StatChip(
                      label: 'Workouts',
                      value: '${sessions.length}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatChip(
                      label: 'This week',
                      value: '${weekAsync.asData?.value ?? '…'}',
                    ),
                  ),
                ],
              ),
              if (muscles.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: muscles
                      .take(8)
                      .map(
                        (m) => Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(m),
                          avatar: Icon(Icons.fitness_center,
                              size: 14, color: scheme.primary),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'This week',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              weekDaysAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (days) => _CompactWeekStrip(
                  days: days,
                  onTapDay: (d) =>
                      context.push(DayDetailScreen.pathFor(d.date)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Day history',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Text(
                    'Tap for detail',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (recentDays.isEmpty)
                const Card(
                  child: ListTile(
                    dense: true,
                    title: Text('No days yet'),
                    subtitle: Text('Log today on Home or finish a session.'),
                  ),
                )
              else
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < recentDays.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        _DayHistoryTile(
                          log: recentDays[i],
                          label: dayFmt.format(recentDays[i].date),
                          onTap: () => context.push(
                            DayDetailScreen.pathFor(recentDays[i].date),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Meal history',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              if (fuelEntries.isEmpty)
                const Card(
                  child: ListTile(
                    dense: true,
                    title: Text('No meals logged yet'),
                    subtitle: Text(
                      'Pick a pre-workout meal in check-in to build history.',
                    ),
                  ),
                )
              else
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < fuelEntries.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        _FuelHistoryTile(
                          entry: fuelEntries[i],
                          label: mealDayFmt.format(fuelEntries[i].date),
                          onTap: () => context.push(
                            DayDetailScreen.pathFor(fuelEntries[i].date),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Recent sessions',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              if (recentSessions.isEmpty)
                EmptyState(
                  icon: Icons.insights_outlined,
                  title: 'No sessions yet',
                  message: 'Finish a workout to see it here.',
                  action: FilledButton(
                    onPressed: () => context.push('/checkin'),
                    child: const Text('Daily check-in'),
                  ),
                )
              else
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < recentSessions.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.check, color: scheme.primary),
                          title: Text(
                            DateFormat('EEE d MMM · HH:mm')
                                .format(recentSessions[i].startedAt),
                          ),
                          subtitle: Text(
                            [
                              if (recentSessions[i].muscleGroups.isEmpty)
                                'Mixed'
                              else
                                recentSessions[i]
                                    .muscleGroups
                                    .map((m) => m.label)
                                    .join(', '),
                              '${recentSessions[i].setLogs.length} sets',
                            ].join(' · '),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push(
                            DayDetailScreen.pathFor(
                              recentSessions[i].startedAt,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              analysisAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (a) => _CompactCharts(analysis: a),
              ),
              const SizedBox(height: 12),
              const _BodyMetricsSection(),
            ],
          );
        },
      ),
    );
  }
}

class _FuelHistoryTile extends StatelessWidget {
  const _FuelHistoryTile({
    required this.entry,
    required this.label,
    required this.onTap,
  });

  final FuelHistoryEntry entry;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lines = <String>[];
    if (entry.preMealName != null && entry.preMealName!.isNotEmpty) {
      final cal = entry.preMealCalories;
      lines.add(
        cal != null ? 'Pre: ${entry.preMealName} · $cal kcal' : 'Pre: ${entry.preMealName}',
      );
    }
    if (entry.postMealName != null && entry.postMealName!.isNotEmpty) {
      final cal = entry.postMealCalories;
      lines.add(
        cal != null
            ? 'Post: ${entry.postMealName} · $cal kcal'
            : 'Post: ${entry.postMealName}',
      );
    }
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: scheme.tertiaryContainer,
        child: Icon(Icons.restaurant, size: 16, color: scheme.onTertiaryContainer),
      ),
      title: Text(label),
      subtitle: Text(lines.join('\n'), maxLines: 2),
      isThreeLine: lines.length > 1,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _DayHistoryTile extends StatelessWidget {
  const _DayHistoryTile({
    required this.log,
    required this.label,
    required this.onTap,
  });

  final DayLog log;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final kind = log.effectiveKind;
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: dayKindColor(scheme, kind).withValues(alpha: 0.2),
        child: Icon(dayKindIcon(kind), size: 16, color: dayKindColor(scheme, kind)),
      ),
      title: Text(label),
      subtitle: Text(
        log.actualKind == null
            ? 'Plan ${log.plannedKind.label} · not logged'
            : 'Logged ${log.actualKind!.label}',
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}

class _CompactWeekStrip extends StatelessWidget {
  const _CompactWeekStrip({required this.days, required this.onTapDay});

  final List<DayLog> days;
  final ValueChanged<DayLog> onTapDay;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final short = DateFormat('E');
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: days.map((d) {
            final kind = d.effectiveKind;
            final color = dayKindColor(scheme, kind);
            return Expanded(
              child: InkWell(
                onTap: () => onTapDay(d),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Text(short.format(d.date),
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 4),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: color.withValues(alpha: 0.2),
                        child: Icon(dayKindIcon(kind), size: 14, color: color),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CompactCharts extends StatelessWidget {
  const _CompactCharts({required this.analysis});

  final RoutineAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total =
        analysis.gymCount + analysis.restCount + analysis.cheatCount;
    final adherencePct = (analysis.adherence * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: StatChip(
                label: 'Adherence',
                value: total == 0 ? '—' : '$adherencePct%',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatChip(
                label: 'Gym (4w)',
                value: '${analysis.gymCount}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day mix · gym / week',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      Expanded(
                        child: total == 0
                            ? const Center(child: Text('Log days'))
                            : PieChart(
                                PieChartData(
                                  sectionsSpace: 1,
                                  centerSpaceRadius: 18,
                                  pieTouchData:
                                      PieTouchData(enabled: false),
                                  sections: [
                                    if (analysis.gymCount > 0)
                                      PieChartSectionData(
                                        value: analysis.gymCount.toDouble(),
                                        title: '${analysis.gymCount}',
                                        color: scheme.primary,
                                        radius: 28,
                                        titleStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    if (analysis.restCount > 0)
                                      PieChartSectionData(
                                        value: analysis.restCount.toDouble(),
                                        title: '${analysis.restCount}',
                                        color: scheme.tertiary,
                                        radius: 28,
                                        titleStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    if (analysis.cheatCount > 0)
                                      PieChartSectionData(
                                        value: analysis.cheatCount.toDouble(),
                                        title: '${analysis.cheatCount}',
                                        color: scheme.secondary,
                                        radius: 28,
                                        titleStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            maxY: (analysis.weeklyGymCounts.fold<int>(
                                      0,
                                      (a, b) => a > b ? a : b,
                                    ) +
                                    1)
                                .toDouble()
                                .clamp(3, 7),
                            barTouchData: const BarTouchData(enabled: false),
                            barGroups: [
                              for (var i = 0;
                                  i < analysis.weeklyGymCounts.length;
                                  i++)
                                BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: analysis.weeklyGymCounts[i]
                                          .toDouble(),
                                      color: scheme.primary,
                                      width: 12,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                            ],
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (v, _) {
                                    const labels = ['-3', '-2', '-1', 'Now'];
                                    final i = v.toInt();
                                    if (i < 0 || i >= labels.length) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      labels[i],
                                      style:
                                          Theme.of(context).textTheme.labelSmall,
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BodyMetricsSection extends ConsumerWidget {
  const _BodyMetricsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydroAsync = ref.watch(recentHydrationProvider);
    final weightAsync = ref.watch(recentBodyMetricsProvider);
    final scheme = Theme.of(context).colorScheme;
    final profile = ref.watch(profileProvider).asData?.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Body & water',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            TextButton.icon(
              onPressed: () => _logWeight(context, ref, profile?.weightKg),
              icon: const Icon(Icons.monitor_weight_outlined, size: 18),
              label: const Text('Log weight'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        hydroAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (logs) {
            if (logs.isEmpty) {
              return const Text('Water: log glasses on Home.');
            }
            final maxG = logs
                .map((e) => e.glasses)
                .fold<int>(1, (a, b) => a > b ? a : b)
                .toDouble();
            return Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Water · last ${logs.length} days',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(
                      height: 88,
                      child: BarChart(
                        BarChartData(
                          maxY: (maxG + 1).clamp(4, 12),
                          barGroups: [
                            for (var i = 0; i < logs.length; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: logs[i].glasses.toDouble(),
                                    color: scheme.primary,
                                    width: 10,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ],
                              ),
                          ],
                          titlesData: const FlTitlesData(show: false),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barTouchData: const BarTouchData(enabled: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        weightAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (logs) {
            if (logs.isEmpty) {
              return Card(
                child: ListTile(
                  dense: true,
                  title: const Text('No weight logs yet'),
                  subtitle: const Text('Track trends month by month.'),
                  trailing: TextButton(
                    onPressed: () =>
                        _logWeight(context, ref, profile?.weightKg),
                    child: const Text('Add'),
                  ),
                ),
              );
            }
            final chronological = logs.reversed.toList();
            final spots = <FlSpot>[
              for (var i = 0; i < chronological.length; i++)
                FlSpot(i.toDouble(), chronological[i].weightKg),
            ];
            final minY = chronological
                    .map((e) => e.weightKg)
                    .reduce((a, b) => a < b ? a : b) -
                1;
            final maxY = chronological
                    .map((e) => e.weightKg)
                    .reduce((a, b) => a > b ? a : b) +
                1;

            // Month index: average kg per calendar month (oldest → newest).
            final monthBuckets = <String, List<double>>{};
            final monthOrder = <String>[];
            for (final log in chronological) {
              final key = DateFormat('yyyy-MM').format(log.loggedAt);
              if (!monthBuckets.containsKey(key)) {
                monthOrder.add(key);
                monthBuckets[key] = [];
              }
              monthBuckets[key]!.add(log.weightKg);
            }
            final monthAvgs = [
              for (final key in monthOrder)
                (
                  key: key,
                  label: DateFormat('MMM y').format(DateTime.parse('$key-01')),
                  avg: monthBuckets[key]!.reduce((a, b) => a + b) /
                      monthBuckets[key]!.length,
                ),
            ];

            return Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight · ${logs.first.weightKg.toStringAsFixed(1)} kg latest',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Month index',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: monthAvgs.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final m = monthAvgs[i];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.secondaryContainer
                                  .withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${m.label} · ${m.avg.toStringAsFixed(1)} kg',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 140,
                      child: LineChart(
                        LineChartData(
                          minY: minY,
                          maxY: maxY,
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: scheme.secondary,
                              barWidth: 2.5,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 36,
                                getTitlesWidget: (value, meta) {
                                  if (value == meta.min || value == meta.max) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final i = value.round();
                                  if (i < 0 || i >= chronological.length) {
                                    return const SizedBox.shrink();
                                  }
                                  // Only label first log of each month (month-wise axis).
                                  final d = chronological[i].loggedAt;
                                  final monthKey =
                                      DateFormat('yyyy-MM').format(d);
                                  if (i > 0 &&
                                      DateFormat('yyyy-MM').format(
                                            chronological[i - 1].loggedAt,
                                          ) ==
                                          monthKey) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      DateFormat('MMM').format(d),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: ((maxY - minY) / 3)
                                .clamp(0.5, 5)
                                .toDouble(),
                            getDrawingHorizontalLine: (_) => FlLine(
                              color: scheme.outlineVariant
                                  .withValues(alpha: 0.35),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineTouchData: const LineTouchData(enabled: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  Future<void> _logWeight(
    BuildContext context,
    WidgetRef ref,
    double? hint,
  ) async {
    final weightCtrl =
        TextEditingController(text: hint?.toStringAsFixed(1) ?? '');
    final waistCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log body weight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: waistCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Waist cm (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final w = double.tryParse(weightCtrl.text.trim());
    if (w == null) return;
    final waist = double.tryParse(waistCtrl.text.trim());
    await ref.read(metricsRepositoryProvider).logBodyMetric(
          weightKg: w,
          waistCm: waist,
        );
    final profile = await ref.read(profileRepositoryProvider).getProfile();
    if (profile != null) {
      await ref
          .read(profileRepositoryProvider)
          .saveProfile(profile.copyWith(weightKg: w));
    }
    ref.read(metricsTickProvider.notifier).state++;
  }
}
