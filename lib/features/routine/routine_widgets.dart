import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';

IconData dayKindIcon(DayKind kind) => switch (kind) {
      DayKind.gym => Icons.fitness_center,
      DayKind.rest => Icons.hotel,
      DayKind.cheat => Icons.cake_outlined,
      DayKind.skip => Icons.event_busy_outlined,
    };

Color dayKindColor(ColorScheme scheme, DayKind kind) => switch (kind) {
      DayKind.gym => scheme.primary,
      DayKind.rest => scheme.tertiary,
      DayKind.cheat => scheme.secondary,
      DayKind.skip => scheme.outline,
    };

const _weekdayOrder = [
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
  DateTime.saturday,
  DateTime.sunday,
];

const _weekdayLetter = {
  DateTime.monday: 'M',
  DateTime.tuesday: 'T',
  DateTime.wednesday: 'W',
  DateTime.thursday: 'T',
  DateTime.friday: 'F',
  DateTime.saturday: 'S',
  DateTime.sunday: 'S',
};

const _weekdayShort = {
  DateTime.monday: 'Mon',
  DateTime.tuesday: 'Tue',
  DateTime.wednesday: 'Wed',
  DateTime.thursday: 'Thu',
  DateTime.friday: 'Fri',
  DateTime.saturday: 'Sat',
  DateTime.sunday: 'Sun',
};

String summarizeWeeklyRoutine(Map<int, DayKind> days) {
  String listDays(DayKind kind) {
    final names = _weekdayOrder
        .where((d) => (days[d] ?? DayKind.rest) == kind)
        .map((d) => _weekdayShort[d]!)
        .toList();
    if (names.isEmpty) return '';
    if (names.length <= 3) return names.join(', ');
    return '${names.take(3).join(', ')}…';
  }

  final gym = listDays(DayKind.gym);
  final rest = listDays(DayKind.rest);
  final cheat = listDays(DayKind.cheat);
  final parts = <String>[
    if (gym.isNotEmpty) 'Gym $gym',
    if (rest.isNotEmpty) 'Rest $rest',
    if (cheat.isNotEmpty) 'Cheat $cheat',
  ];
  if (parts.isEmpty) return 'Does not repeat';
  return 'Weekly · ${parts.join(' · ')}';
}

Map<int, DayKind> _presetWeekdaysGym() => {
      for (final d in _weekdayOrder)
        d: d <= DateTime.friday ? DayKind.gym : DayKind.rest,
    };

Map<int, DayKind> _presetMonWedFri() => {
      for (final d in _weekdayOrder)
        d: (d == DateTime.monday ||
                d == DateTime.wednesday ||
                d == DateTime.friday)
            ? DayKind.gym
            : (d == DateTime.sunday ? DayKind.cheat : DayKind.rest),
    };

Map<int, DayKind> _presetSixDay() => {
      for (final d in _weekdayOrder)
        d: d == DateTime.sunday ? DayKind.cheat : DayKind.gym,
    };

Map<int, DayKind> _presetFourDay() => WeeklyRoutine.defaultDays();

/// Google Calendar–inspired weekly routine picker (Profile).
class WeeklyRoutineEditor extends ConsumerWidget {
  const WeeklyRoutineEditor({super.key, this.embedded = false});

  /// When true, skips the outer Card and title (for use inside CollapsibleSection).
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineAsync = ref.watch(weeklyRoutineProvider);
    final scheme = Theme.of(context).colorScheme;

    return routineAsync.when(
      loading: () => const Padding(
        padding: AppSpacing.card,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (routine) {
        final summary = summarizeWeeklyRoutine(routine.days);
        final body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!embedded)
              Text(
                'Weekly routine',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('Deload this week'),
              subtitle: Text(
                routine.isDeloadActive && routine.deloadUntil != null
                    ? 'Lighter sets until ${DateFormat('EEE d').format(routine.deloadUntil!)}'
                    : 'Cuts ideal sets ~25% for 7 days',
              ),
              value: routine.isDeloadActive,
              onChanged: (v) async {
                await ref
                    .read(routineRepositoryProvider)
                    .setDeload(enabled: v);
              },
            ),
            Material(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openPresetSheet(context, ref, routine.days),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 10,
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  child: Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _MiniWeekPreview(days: routine.days),
          ],
        );

        if (embedded) return body;

        return Card(
          child: Padding(
            padding: AppSpacing.cardTight,
            child: body,
          ),
        );
      },
    );
  }

  Future<void> _openPresetSheet(
    BuildContext context,
    WidgetRef ref,
    Map<int, DayKind> current,
  ) async {
    final scheme = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: scheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final options = <({String title, Map<int, DayKind>? days})>[
          (
            title: 'Weekdays gym (Mon–Fri), weekend rest',
            days: _presetWeekdaysGym(),
          ),
          (
            title: 'Weekly on Monday, Wednesday, Friday',
            days: _presetMonWedFri(),
          ),
          (
            title: 'Mon–Sat gym, Sunday cheat',
            days: _presetSixDay(),
          ),
          (
            title: '4-day split · Tue/Thu rest · Sun cheat',
            days: _presetFourDay(),
          ),
          (title: 'Custom…', days: null),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                  child: Text(
                    'Repeat pattern',
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final opt in options)
                        ListTile(
                          title: Text(opt.title),
                          selected: opt.days != null &&
                              _mapsEqual(opt.days!, current),
                          selectedTileColor:
                              scheme.primary.withValues(alpha: 0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () async {
                            Navigator.pop(ctx);
                            if (opt.days == null) {
                              await _openCustomDialog(context, ref, current);
                            } else {
                              await ref
                                  .read(routineRepositoryProvider)
                                  .saveWeeklyRoutine(opt.days!);
                              ref.read(dayLogsTickProvider.notifier).state++;
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCustomDialog(
    BuildContext context,
    WidgetRef ref,
    Map<int, DayKind> current,
  ) async {
    final result = await showDialog<Map<int, DayKind>>(
      context: context,
      builder: (ctx) => _CustomRecurrenceDialog(initial: current),
    );
    if (result == null) return;
    await ref.read(routineRepositoryProvider).saveWeeklyRoutine(result);
    ref.read(dayLogsTickProvider.notifier).state++;
  }
}

bool _mapsEqual(Map<int, DayKind> a, Map<int, DayKind> b) {
  for (final d in _weekdayOrder) {
    if ((a[d] ?? DayKind.rest) != (b[d] ?? DayKind.rest)) return false;
  }
  return true;
}

class _MiniWeekPreview extends StatelessWidget {
  const _MiniWeekPreview({required this.days});

  final Map<int, DayKind> days;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final d in _weekdayOrder)
          Column(
            children: [
              Text(
                _weekdayLetter[d]!,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              CircleAvatar(
                radius: 14,
                backgroundColor: dayKindColor(scheme, days[d] ?? DayKind.rest)
                    .withValues(alpha: 0.22),
                child: Icon(
                  dayKindIcon(days[d] ?? DayKind.rest),
                  size: 14,
                  color: dayKindColor(scheme, days[d] ?? DayKind.rest),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Google Calendar–style custom recurrence for gym / rest / cheat.
class _CustomRecurrenceDialog extends StatefulWidget {
  const _CustomRecurrenceDialog({required this.initial});

  final Map<int, DayKind> initial;

  @override
  State<_CustomRecurrenceDialog> createState() =>
      _CustomRecurrenceDialogState();
}

enum _EndsMode { never, onDate, afterCount }

class _CustomRecurrenceDialogState extends State<_CustomRecurrenceDialog> {
  late Map<int, DayKind> _days;
  DayKind _paintKind = DayKind.gym;
  int _every = 1;
  _EndsMode _ends = _EndsMode.never;
  late DateTime _endDate;
  int _occurrences = 13;

  @override
  void initState() {
    super.initState();
    _days = Map<int, DayKind>.from(widget.initial);
    for (final d in _weekdayOrder) {
      _days.putIfAbsent(d, () => DayKind.rest);
    }
    _endDate = _dateFromOccurrences(_occurrences);
  }

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// Last occurrence date after [count] repeats of every [_every] weeks.
  DateTime _dateFromOccurrences(int count) {
    final steps = (count - 1).clamp(0, 200);
    return _today.add(Duration(days: 7 * _every * steps));
  }

  /// How many occurrences fit from today through [end] at every [_every] weeks.
  int _occurrencesFromDate(DateTime end) {
    final endDay = DateTime(end.year, end.month, end.day);
    final days = endDay.difference(_today).inDays;
    if (days < 0) return 1;
    final periodDays = 7 * _every;
    return ((days ~/ periodDays) + 1).clamp(1, 99);
  }

  void _setEvery(int next) {
    setState(() {
      _every = next.clamp(1, 12);
      switch (_ends) {
        case _EndsMode.afterCount:
          _endDate = _dateFromOccurrences(_occurrences);
        case _EndsMode.onDate:
          _occurrences = _occurrencesFromDate(_endDate);
        case _EndsMode.never:
          break;
      }
    });
  }

  void _setEnds(_EndsMode mode) {
    setState(() {
      _ends = mode;
      switch (mode) {
        case _EndsMode.afterCount:
          _endDate = _dateFromOccurrences(_occurrences);
        case _EndsMode.onDate:
          _occurrences = _occurrencesFromDate(_endDate);
        case _EndsMode.never:
          break;
      }
    });
  }

  void _setOccurrences(int next) {
    setState(() {
      _occurrences = next.clamp(1, 99);
      _ends = _EndsMode.afterCount;
      _endDate = _dateFromOccurrences(_occurrences);
    });
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_today) ? _today : _endDate,
      firstDate: _today,
      lastDate: _today.add(Duration(days: 7 * _every * 99)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _ends = _EndsMode.onDate;
      _endDate = DateTime(picked.year, picked.month, picked.day);
      _occurrences = _occurrencesFromDate(_endDate);
    });
  }

  void _setDay(int weekday, DayKind kind) {
    setState(() => _days[weekday] = kind);
  }

  String get _endsSummary {
    final unit = _every == 1 ? 'week' : '$_every weeks';
    return switch (_ends) {
      _EndsMode.never => 'Repeats every $unit with no end date.',
      _EndsMode.onDate =>
        'Repeats every $unit until ${DateFormat('MMM d, y').format(_endDate)} '
            '($_occurrences occurrence${_occurrences == 1 ? '' : 's'}).',
      _EndsMode.afterCount =>
        'Repeats every $unit for $_occurrences occurrence${_occurrences == 1 ? '' : 's'} '
            '(through ${DateFormat('MMM d, y').format(_endDate)}).',
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final weekLabel = _every == 1 ? 'week' : 'weeks';
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom recurrence',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Repeat every',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StepperBox(
                      value: '$_every',
                      onUp: () => _setEvery(_every + 1),
                      onDown: () => _setEvery(_every - 1),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(weekLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Assign with',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: DayKind.planKinds.map((k) {
                    final selected = _paintKind == k;
                    return ChoiceChip(
                      avatar: Icon(dayKindIcon(k), size: 16),
                      label: Text(k.label),
                      selected: selected,
                      onSelected: (_) => setState(() => _paintKind = k),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Text(
                  'Repeat on',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final d in _weekdayOrder)
                      _DayCircle(
                        letter: _weekdayLetter[d]!,
                        kind: _days[d] ?? DayKind.rest,
                        paintKind: _paintKind,
                        onTap: () => _setDay(d, _paintKind),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap a day to set it as ${_paintKind.label.toLowerCase()}. '
                  'Coloured circles show Gym / Rest / Cheat.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ends',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                _EndsOption(
                  selected: _ends == _EndsMode.never,
                  onTap: () => _setEnds(_EndsMode.never),
                  child: const Text('Never'),
                ),
                _EndsOption(
                  selected: _ends == _EndsMode.onDate,
                  onTap: () => _setEnds(_EndsMode.onDate),
                  child: Row(
                    children: [
                      const Text('On'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Opacity(
                          opacity: _ends == _EndsMode.onDate ? 1 : 0.45,
                          child: InkWell(
                            onTap: () {
                              if (_ends != _EndsMode.onDate) {
                                _setEnds(_EndsMode.onDate);
                              }
                              _pickEndDate();
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: scheme.surfaceContainerHighest,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                DateFormat('MMM d, y').format(_endDate),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _EndsOption(
                  selected: _ends == _EndsMode.afterCount,
                  onTap: () => _setEnds(_EndsMode.afterCount),
                  child: Row(
                    children: [
                      const Text('After'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Opacity(
                          opacity: _ends == _EndsMode.afterCount ? 1 : 0.45,
                          child: _StepperBox(
                            value: '$_occurrences occurrences',
                            wide: true,
                            onUp: () => _setOccurrences(_occurrences + 1),
                            onDown: () => _setOccurrences(_occurrences - 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    _endsSummary,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Text(
                  'Changing interval, end date, or count updates the others. '
                  'Weekly day pattern is what the app uses today; end rules are kept for reminders.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, _days),
                        style: FilledButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Done'),
                      ),
                    ],
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

class _EndsOption extends StatelessWidget {
  const _EndsOption({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({
    required this.letter,
    required this.kind,
    required this.paintKind,
    required this.onTap,
  });

  final String letter;
  final DayKind kind;
  final DayKind paintKind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = dayKindColor(scheme, kind);
    final isPaintTarget = kind == paintKind;
    final bg = isPaintTarget
        ? accent
        : accent.withValues(alpha: 0.22);
    final fg = isPaintTarget ? scheme.onPrimary : accent;

    return Tooltip(
      message: kind.label,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: CircleAvatar(
          radius: 18,
          backgroundColor: bg,
          child: Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: fg,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepperBox extends StatelessWidget {
  const _StepperBox({
    required this.value,
    this.onUp,
    this.onDown,
    this.wide = false,
  });

  final String value;
  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: wide ? null : 72,
      padding: const EdgeInsets.only(left: 10, right: 2, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onUp,
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 20,
                  color: onUp == null
                      ? scheme.onSurface.withValues(alpha: 0.3)
                      : scheme.onSurfaceVariant,
                ),
              ),
              InkWell(
                onTap: onDown,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: onDown == null
                      ? scheme.onSurface.withValues(alpha: 0.3)
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Home / Progress: today planned vs log buttons.
class TodayRoutineCard extends ConsumerStatefulWidget {
  const TodayRoutineCard({super.key});

  @override
  ConsumerState<TodayRoutineCard> createState() => _TodayRoutineCardState();
}

class _TodayRoutineCardState extends ConsumerState<TodayRoutineCard> {
  DayKind? _pending;
  bool? _expandedOverride;

  @override
  Widget build(BuildContext context) {
    final dayAsync = ref.watch(todaysDayLogProvider);
    final scheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat('EEEE, d MMM').format(DateTime.now());
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 220);

    return dayAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      loading: () => const Card(
        child: Padding(
          padding: AppSpacing.card,
          child: LinearProgressIndicator(),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (log) {
        final planned = log.plannedKind;
        final selected = _pending ?? log.actualKind;
        final expanded = _expandedOverride ?? (log.actualKind == null);
        final summaryKind = selected ?? planned;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: AnimatedSize(
            duration: duration,
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: AppSpacing.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => setState(() => _expandedOverride = !expanded),
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Icon(
                          dayKindIcon(summaryKind),
                          color: dayKindColor(scheme, summaryKind),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            expanded
                                ? 'Today · $dateLabel'
                                : 'Today · ${summaryKind.label}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (!expanded) ...[
                          TextButton(
                            onPressed: () =>
                                setState(() => _expandedOverride = true),
                            child: const Text('Re-do'),
                          ),
                        ],
                        AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: duration,
                          child: Icon(
                            Icons.expand_more_rounded,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (expanded) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          dayKindIcon(planned),
                          color: dayKindColor(scheme, planned),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Planned: ${planned.label} — ${planned.subtitle}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    if (selected != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Logged: ${selected.label}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: dayKindColor(scheme, selected),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Log how the day went',
                      style: Theme.of(context).textTheme.labelMedium,
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
                            onSelected: (_) {
                              setState(() {
                                _pending = k;
                                _expandedOverride = false;
                              });
                              _persist(k);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Skip = holiday or gym closed (won\'t hurt adherence).',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _persist(DayKind k) async {
    try {
      await ref.read(routineRepositoryProvider).logDay(
            date: DateTime.now(),
            actual: k,
            note: k == DayKind.skip ? 'Holiday / gym closed' : '',
          );
      ref.read(dayLogsTickProvider.notifier).state++;
      ref.read(trainAnywayProvider.notifier).state = false;
      if (mounted) setState(() => _pending = null);
    } catch (_) {
      if (mounted) setState(() => _pending = null);
    }
  }
}

/// Shown on Home / Workout when today is logged as Rest, Cheat or Skip.
class RestDayCard extends ConsumerWidget {
  const RestDayCard({
    super.key,
    required this.kind,
    this.hasPlan = false,
  });

  final DayKind kind;
  final bool hasPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final accent = dayKindColor(scheme, kind);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(dayKindIcon(kind), size: 18, color: accent),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Today is ${kind.label}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              kind.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            if (hasPlan) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () =>
                      ref.read(trainAnywayProvider.notifier).state = true,
                  child: const Text('Train anyway'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
