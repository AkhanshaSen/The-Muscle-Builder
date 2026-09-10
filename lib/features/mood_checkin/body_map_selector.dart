import 'package:flutter/material.dart';

import '../../domain/engines/muscle_recovery.dart';
import '../../domain/models/enums.dart';

/// Interactive body-map using tappable muscle zones (no dropdown).
class BodyMapSelector extends StatelessWidget {
  const BodyMapSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.statuses = const {},
    this.blocked = const {},
  });

  final Set<MuscleGroup> selected;
  final ValueChanged<Set<MuscleGroup>> onChanged;

  /// Recovery state per group. Empty until history loads.
  final Map<MuscleGroup, MuscleStatus> statuses;

  /// Groups trained in the last 24 h — cannot be selected.
  final Set<MuscleGroup> blocked;

  void _toggle(MuscleGroup muscle) {
    if (blocked.contains(muscle)) return; // hard block
    final next = Set<MuscleGroup>.from(selected);
    if (next.contains(muscle)) {
      next.remove(muscle);
    } else {
      next.add(muscle);
    }
    onChanged(next);
  }

  Color? _flagColor(ColorScheme scheme, MuscleGroup muscle) {
    return switch (statuses[muscle]?.readiness) {
      MuscleReadiness.recovering => scheme.error,
      MuscleReadiness.caution => scheme.tertiary,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget zone({
      required MuscleGroup muscle,
      required double top,
      required double left,
      required double width,
      required double height,
      BorderRadius? radius,
    }) {
      final isBlocked = blocked.contains(muscle);
      final isOn = selected.contains(muscle);
      final status = statuses[muscle];
      final flag = isBlocked ? scheme.error : _flagColor(scheme, muscle);
      final shape = radius ?? BorderRadius.circular(12);
      return Positioned(
        top: top,
        left: left,
        width: width,
        height: height,
        child: Tooltip(
          message: isBlocked
              ? '${muscle.label}: trained < 24 h — needs recovery'
              : '',
          child: Material(
            color: isBlocked
                ? scheme.errorContainer.withValues(alpha: 0.45)
                : isOn
                    ? scheme.primary.withValues(alpha: 0.75)
                    : scheme.surfaceContainerHighest
                        .withValues(alpha: flag != null ? 0.5 : 0.85),
            borderRadius: shape,
            child: InkWell(
              onTap: isBlocked ? null : () => _toggle(muscle),
              borderRadius: shape,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: shape,
                  border: flag == null
                      ? null
                      : Border.all(
                          color: flag.withValues(alpha: 0.9), width: 2),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isBlocked)
                          Icon(Icons.lock_outline,
                              size: 10, color: scheme.error),
                        Text(
                          muscle.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isBlocked
                                ? scheme.error
                                : isOn
                                    ? scheme.onPrimary
                                    : scheme.onSurface,
                          ),
                        ),
                        if (status != null)
                          Text(
                            isBlocked ? status.shortSince : status.shortSince,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: flag ??
                                  (isOn
                                      ? scheme.onPrimary.withValues(alpha: 0.8)
                                      : scheme.onSurface
                                          .withValues(alpha: 0.55)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 0.72,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              return Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Stack(
                  children: [
                    // Head silhouette
                    Positioned(
                      top: h * 0.02,
                      left: w * 0.38,
                      width: w * 0.24,
                      height: h * 0.1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.outlineVariant.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    zone(
                      muscle: MuscleGroup.shoulders,
                      top: h * 0.13,
                      left: w * 0.12,
                      width: w * 0.76,
                      height: h * 0.08,
                      radius: BorderRadius.circular(20),
                    ),
                    zone(
                      muscle: MuscleGroup.chest,
                      top: h * 0.22,
                      left: w * 0.28,
                      width: w * 0.44,
                      height: h * 0.14,
                    ),
                    zone(
                      muscle: MuscleGroup.arms,
                      top: h * 0.24,
                      left: w * 0.06,
                      width: w * 0.18,
                      height: h * 0.22,
                      radius: BorderRadius.circular(18),
                    ),
                    zone(
                      muscle: MuscleGroup.arms,
                      top: h * 0.24,
                      left: w * 0.76,
                      width: w * 0.18,
                      height: h * 0.22,
                      radius: BorderRadius.circular(18),
                    ),
                    zone(
                      muscle: MuscleGroup.core,
                      top: h * 0.38,
                      left: w * 0.30,
                      width: w * 0.40,
                      height: h * 0.14,
                    ),
                    zone(
                      muscle: MuscleGroup.back,
                      top: h * 0.54,
                      left: w * 0.26,
                      width: w * 0.48,
                      height: h * 0.1,
                    ),
                    zone(
                      muscle: MuscleGroup.legs,
                      top: h * 0.66,
                      left: w * 0.22,
                      width: w * 0.26,
                      height: h * 0.28,
                      radius: BorderRadius.circular(16),
                    ),
                    zone(
                      muscle: MuscleGroup.legs,
                      top: h * 0.66,
                      left: w * 0.52,
                      width: w * 0.26,
                      height: h * 0.28,
                      radius: BorderRadius.circular(16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (statuses.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _LegendDot(color: scheme.error, label: 'Trained < 24 h'),
              _LegendDot(color: scheme.tertiary, label: '24–48 h'),
              _LegendDot(
                color: scheme.onSurface.withValues(alpha: 0.35),
                label: 'Recovered',
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MuscleGroup.values.map((m) {
            final isBlocked = blocked.contains(m);
            final isOn = selected.contains(m);
            final status = statuses[m];
            final flag = isBlocked ? scheme.error : _flagColor(scheme, m);
            return FilterChip(
              label: Text(
                status == null ? m.label : '${m.label} · ${status.shortSince}',
              ),
              selected: isOn,
              avatar: isBlocked
                  ? Icon(Icons.lock_outline, size: 12, color: scheme.error)
                  : flag == null
                      ? null
                      : Icon(Icons.circle, size: 10, color: flag),
              onSelected: isBlocked ? null : (_) => _toggle(m),
              tooltip: isBlocked
                  ? 'Trained < 24 h — needs recovery'
                  : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 9, color: color),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
