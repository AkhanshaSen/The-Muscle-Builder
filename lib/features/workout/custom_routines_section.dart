import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/models/models.dart';
import 'use_custom_routine_today.dart';

class CustomRoutinesSection extends ConsumerWidget {
  const CustomRoutinesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(customRoutinesProvider);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Your routines',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push('/custom-routine/new'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        routinesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('$e'),
          data: (routines) {
            if (routines.isEmpty) {
              return Card(
                child: InkWell(
                  onTap: () => context.push('/custom-routine/new'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: AppSpacing.card,
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune_outlined,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Build a chest & shoulder template — pick moves, save, use any day.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: routines.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  return _RoutineCard(
                    routine: routines[i],
                    onTap: () => _showActions(context, ref, routines[i]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _showActions(
    BuildContext context,
    WidgetRef ref,
    CustomRoutine routine,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(routine.name),
              subtitle: Text('${routine.exerciseIds.length} exercises'),
            ),
            ListTile(
              leading: const Icon(Icons.play_arrow_rounded),
              title: const Text('Use today'),
              onTap: () {
                Navigator.pop(ctx);
                useCustomRoutineToday(context, ref, routine);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/custom-routine/${routine.id}/edit');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(ctx).colorScheme.error,
              ),
              title: const Text('Delete'),
              onTap: () async {
                Navigator.pop(ctx);
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (d) => AlertDialog(
                    title: const Text('Delete routine?'),
                    content: Text('Remove “${routine.name}” permanently?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(d, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(d, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  await ref
                      .read(customRoutineRepositoryProvider)
                      .delete(routine.id);
                  ref.read(customRoutinesTickProvider.notifier).state++;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.routine, required this.onTap});

  final CustomRoutine routine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
  return SizedBox(
      width: 156,
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.format_list_bulleted, color: scheme.primary),
                const Spacer(),
                Text(
                  routine.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${routine.exerciseIds.length} moves',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
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