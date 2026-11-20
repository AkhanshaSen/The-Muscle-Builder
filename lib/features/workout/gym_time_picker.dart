import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/engines/gym_session_sizing.dart';

/// Gym duration chips + exercise count stepper (check-in and plan screen).
class GymTimePicker extends StatelessWidget {
  const GymTimePicker({
    super.key,
    required this.gymMinutes,
    required this.exerciseCount,
    required this.baselineCount,
    required this.catalogLength,
    required this.overrideCount,
    required this.estimatedMinutes,
    required this.onGymMinutesChanged,
    required this.onExerciseCountChanged,
    this.showCatalogCapHint = true,
    this.embedded = false,
  });

  final int gymMinutes;
  final int exerciseCount;
  final int baselineCount;
  final int catalogLength;
  final int? overrideCount;
  final int estimatedMinutes;
  final ValueChanged<int> onGymMinutesChanged;
  final ValueChanged<int?> onExerciseCountChanged;

  /// When false, hides "catalog max" copy (check-in has no generated plan yet).
  final bool showCatalogCapHint;

  /// When true, omits outer [Card] (e.g. inside plan screen expansion).
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final customized = overrideCount != null;
    final atCatalogCap = showCatalogCapHint &&
        exerciseCount >= catalogLength &&
        catalogLength < GymSessionSizing.maxExerciseCount;
    final maxAllowed = catalogLength.clamp(
      GymSessionSizing.minExerciseCount,
      GymSessionSizing.maxExerciseCount,
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule, size: 18, color: scheme.primary),
            const SizedBox(width: 8),
            Text(
              'Gym time',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '~$estimatedMinutes min',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: GymSessionSizing.optionsMinutes.map((m) {
            final label = m >= 120
                ? (m == 120 ? '2 hr' : '2.5 hr')
                : '$m min';
            final selected = gymMinutes == m;
            return FilterChip(
              label: Text(label),
              selected: selected,
              showCheckmark: true,
              visualDensity: VisualDensity.compact,
              onSelected: (_) => onGymMinutesChanged(m),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5)),
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
              : GymSessionSizing.labelForMinutes(gymMinutes),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                tooltip: 'Fewer exercises',
                visualDensity: VisualDensity.compact,
                onPressed: exerciseCount > GymSessionSizing.minExerciseCount
                    ? () => onExerciseCountChanged(exerciseCount - 1)
                    : null,
                icon: const Icon(Icons.remove, size: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$exerciseCount',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'More exercises',
                visualDensity: VisualDensity.compact,
                onPressed: exerciseCount < maxAllowed
                    ? () => onExerciseCountChanged(exerciseCount + 1)
                    : null,
                icon: const Icon(Icons.add, size: 20),
              ),
              if (customized) ...[
                const SizedBox(width: 4),
                TextButton(
                  onPressed: () => onExerciseCountChanged(null),
                  child: const Text('Match gym time'),
                ),
              ],
            ],
          ),
        ),
        if (atCatalogCap)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'Catalog max for this plan is $catalogLength. '
              'Re-do check-in for a longer list.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.tertiary,
                  ),
            ),
          ),
      ],
    );

    if (embedded) {
      return Padding(
        padding: AppSpacing.cardTight,
        child: content,
      );
    }

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: AppSpacing.cardTight,
        child: content,
      ),
    );
  }
}