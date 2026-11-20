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