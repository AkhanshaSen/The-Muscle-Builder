import 'package:flutter/material.dart';

import '../../domain/models/enums.dart';

/// Interactive body-map using tappable muscle zones (no dropdown).
class BodyMapSelector extends StatelessWidget {
  const BodyMapSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<MuscleGroup> selected;
  final ValueChanged<Set<MuscleGroup>> onChanged;

  void _toggle(MuscleGroup muscle) {
    final next = Set<MuscleGroup>.from(selected);
    if (next.contains(muscle)) {
      next.remove(muscle);
    } else {
      next.add(muscle);
    }
    onChanged(next);
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
      final isOn = selected.contains(muscle);
      return Positioned(
        top: top,
        left: left,
        width: width,
        height: height,
        child: Material(
          color: isOn
              ? scheme.primary.withValues(alpha: 0.75)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.85),
          borderRadius: radius ?? BorderRadius.circular(12),
          child: InkWell(
            onTap: () => _toggle(muscle),
            borderRadius: radius ?? BorderRadius.circular(12),
            child: Center(
              child: Text(
                muscle.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isOn ? scheme.onPrimary : scheme.onSurface,
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
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MuscleGroup.values.map((m) {
            final isOn = selected.contains(m);
            return FilterChip(
              label: Text(m.label),
              selected: isOn,
              onSelected: (_) => _toggle(m),
            );
          }).toList(),
        ),
      ],
    );
  }
}
