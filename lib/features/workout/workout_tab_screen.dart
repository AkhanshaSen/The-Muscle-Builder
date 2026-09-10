import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/gym_session_sizing.dart';
import '../../domain/models/models.dart';
import '../routine/routine_widgets.dart';
import 'exercise_posture_gallery.dart';

class WorkoutTabScreen extends ConsumerWidget {
  const WorkoutTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(todayStatusProvider);
    final trainAnyway = ref.watch(trainAnywayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (status) {
          if (status.isRestLogged && !trainAnyway) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                RestDayCard(
                  kind: status.loggedKind!,
                  hasPlan: status.plan != null,
                ),
              ],
            );
          }

          final plan = status.plan;
          if (plan == null) {
            return EmptyState(
              icon: Icons.fitness_center,
              title: 'No plan yet',
              message:
                  'Complete a daily check-in to generate a mood-aware routine.',
              action: FilledButton(
                onPressed: () => context.push('/checkin'),
                child: const Text('Daily check-in'),
              ),
            );
          }

          final active = GymSessionSizing.activeExercises(plan);
          final mins = GymSessionSizing.totalMinutes(active);
          final scheme = Theme.of(context).colorScheme;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                  children: [
                    Text(
                      plan.encouragement,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: Icon(
                            Icons.fitness_center,
                            size: 16,
                            color: scheme.primary,
                          ),
                          label: Text('${active.length} moves'),
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: Icon(
                            Icons.schedule,
                            size: 16,
                            color: scheme.primary,
                          ),
                          label: Text('~$mins min'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (var i = 0; i < active.length; i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                indent: 52,
                                color: scheme.outlineVariant
                                    .withValues(alpha: 0.5),
                              ),
                            _CompactExerciseRow(
                              index: i + 1,
                              exercise: active[i],
                              onTap: () => _showExerciseDetail(
                                context,
                                plan: plan,
                                exercise: active[i],
                                index: i,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryCta(
                        label: 'Open full plan',
                        onPressed: () => context.push('/plan/${plan.id}'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => context.push('/checkin'),
                        child: const Text('New check-in'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showExerciseDetail(
    BuildContext context, {
    required WorkoutPlan plan,
    required PlannedExercise exercise,
    required int index,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              children: [
                Text(
                  'Exercise ${index + 1} of ${plan.exercises.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${exercise.sets} sets × ${exercise.reps} reps · '
                  '${exercise.restSeconds}s rest'
                  '${exercise.includeDropSet ? ' · drop set' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                if (exercise.muscleGroups.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: exercise.muscleGroups
                        .map((m) => Chip(label: Text(m.label)))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 14),
                ExercisePostureGallery(
                  imageUrls: exercise.demoImages,
                  height: 140,
                ),
                if (exercise.formCues.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Form cues',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  ...exercise.formCues.asMap().entries.map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('${c.key + 1}. ${c.value}'),
                        ),
                      ),
                ],
                if (exercise.commonMistakes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Common mistakes',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  ...exercise.commonMistakes.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $c'),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/plan/${plan.id}');
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open full plan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CompactExerciseRow extends StatelessWidget {
  const _CompactExerciseRow({
    required this.index,
    required this.exercise,
    required this.onTap,
  });

  final int index;
  final PlannedExercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: scheme.primary.withValues(alpha: 0.15),
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '${exercise.sets}×${exercise.reps} · ${exercise.restSeconds}s'
                    '${exercise.includeDropSet ? ' · drop' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
