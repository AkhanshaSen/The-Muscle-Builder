import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/models/models.dart';
import 'exercise_posture_gallery.dart';

class WorkoutTabScreen extends ConsumerWidget {
  const WorkoutTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(todaysPlanProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (plan) {
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

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                plan.encouragement,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...plan.exercises.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.15),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    title: Text(e.name),
                    subtitle: Text(
                      '${e.sets}×${e.reps} · ${e.restSeconds}s rest'
                      '${e.includeDropSet ? ' · drop set' : ''}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showExerciseDetail(
                      context,
                      plan: plan,
                      exercise: e,
                      index: index,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
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
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
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
                          fontWeight: FontWeight.w800,
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
                          fontWeight: FontWeight.w800,
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
