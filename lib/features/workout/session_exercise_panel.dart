import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/design_tokens.dart';
import '../../domain/engines/exercise_catalog.dart';
import '../../domain/models/models.dart';
import 'exercise_posture_gallery.dart';

class SessionExercisePanel extends StatefulWidget {
  const SessionExercisePanel({
    super.key,
    required this.index,
    required this.exercise,
    required this.timeWindow,
    required this.roleLabel,
    required this.why,
    required this.imageUrls,
    this.catalogExercise,
    required this.onSetsChanged,
    this.onSkip,
    this.canSkip = true,
    this.initiallyExpanded = false,
  });

  final int index;
  final PlannedExercise exercise;
  final String timeWindow;
  final String roleLabel;
  final String why;
  final List<String> imageUrls;
  final Exercise? catalogExercise;
  final ValueChanged<int> onSetsChanged;
  final VoidCallback? onSkip;
  final bool canSkip;
  final bool initiallyExpanded;

  @override
  State<SessionExercisePanel> createState() => _SessionExercisePanelState();
}

class _SessionExercisePanelState extends State<SessionExercisePanel> {
  late var _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final craft = context.craft;
    final scheme = Theme.of(context).colorScheme;
    final steps = widget.catalogExercise != null
        ? ExerciseCatalog.quickSteps(widget.catalogExercise!)
        : widget.exercise.formCues.take(3).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: craft.surface,
          border: Border.all(color: craft.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          '${widget.index}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.exercise.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          if (widget.exercise.muscleGroups.isNotEmpty)
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: widget.exercise.muscleGroups.map((g) {
                                return _MuscleTag(label: g.label);
                              }).toList(),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            'Min ${widget.timeWindow} · ${widget.roleLabel}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            '${widget.exercise.sets}×${widget.exercise.reps} · rest ${widget.exercise.restSeconds}s'
                            '${widget.exercise.includeDropSet ? ' · drop set' : ''}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: craft.textMuted,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: AppMotion.expandDuration,
              crossFadeState:
                  _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: craft.surfaceRaised,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: craft.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: _SetsStepper(
                          sets: widget.exercise.sets,
                          ideal: widget.exercise.recommendedSets ??
                              widget.exercise.sets,
                          onChanged: widget.onSetsChanged,
                        ),
                      ),
                    ),
                    if (widget.canSkip && widget.onSkip != null) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: widget.onSkip,
                          icon: const Icon(Icons.remove_circle_outline, size: 18),
                          label: const Text('Skip this today'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      widget.why,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (steps.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      for (var i = 0; i < steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Step ${i + 1}: ${steps[i]}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                    if (widget.imageUrls.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ExercisePostureGallery(
                        imageUrls: widget.imageUrls,
                        height: 96,
                      ),
                    ],
                    if (widget.exercise.commonMistakes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Avoid: ${widget.exercise.commonMistakes.take(2).join(' · ')}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: craft.textFaint,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuscleTag extends StatelessWidget {
  const _MuscleTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final craft = context.craft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: craft.border),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: craft.textMuted,
              fontSize: 10,
            ),
      ),
    );
  }
}

class _SetsStepper extends StatelessWidget {
  const _SetsStepper({
    required this.sets,
    required this.ideal,
    required this.onChanged,
  });

  final int sets;
  final int ideal;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final differs = sets != ideal;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sets', style: Theme.of(context).textTheme.labelLarge),
              Text(
                differs
                    ? 'Ideal today: $ideal'
                    : 'On target: $ideal',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: differs ? scheme.primary : null,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: sets > 1 ? () => onChanged(sets - 1) : null,
          icon: const Icon(Icons.remove, size: 20),
        ),
        Text('$sets', style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          onPressed: sets < 6 ? () => onChanged(sets + 1) : null,
          icon: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }
}

/// Compact row for builders / category lists (matches session panel typography).
class CatalogExerciseRow extends StatelessWidget {
  const CatalogExerciseRow({
    super.key,
    required this.exercise,
    required this.selected,
    required this.onPreviewTap,
    required this.onTogglePick,
    this.isExpanded = false,
    this.legacyOnTap,
    this.onLongPress,
  });

  final Exercise exercise;
  final bool selected;
  final bool isExpanded;
  final VoidCallback onPreviewTap;
  final VoidCallback onTogglePick;
  /// Category list: single tap still picks when set.
  final VoidCallback? legacyOnTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final craft = context.craft;
    final scheme = Theme.of(context).colorScheme;
    final steps = ExerciseCatalog.quickSteps(exercise);
    final subtitle = ExerciseCatalog.equipmentSubtitle(exercise);
    final url = exercise.demoUrl;
    final onRowTap = legacyOnTap ?? onPreviewTap;

    return Material(
      color: selected ? craft.accentDim : craft.surface,
      child: InkWell(
        onTap: onRowTap,
        onLongPress: onLongPress,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: selected ? scheme.primary : Colors.transparent,
                width: 3,
              ),
              bottom: BorderSide(color: craft.border),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (url != null && url.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _thumbPlaceholder(context),
                    ),
                  )
                else
                  _thumbPlaceholder(context),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: craft.textMuted,
                              ),
                        ),
                      for (var i = 0; i < steps.length; i++)
                        Text(
                          'Step ${i + 1}: ${steps[i]}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
                if (legacyOnTap == null) ...[
                  IconButton(
                    onPressed: onRowTap,
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    tooltip: 'Preview',
                  ),
                  IconButton(
                    onPressed: onTogglePick,
                    icon: Icon(
                      selected ? Icons.check_circle : Icons.add_circle_outline,
                      size: 22,
                      color: selected ? scheme.primary : craft.textMuted,
                    ),
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                    tooltip: selected ? 'Added' : 'Add',
                  ),
                ] else if (selected)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.check, size: 18, color: scheme.primary),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumbPlaceholder(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ColoredBox(
        color: context.craft.surfaceRaised,
        child: Icon(
          Icons.fitness_center,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}