import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../domain/models/models.dart';
import 'use_custom_routine_today.dart';

/// Entry to build or use a saved custom routine (Workout tab + daily check-in).
///
/// When [onPickForCheckIn] is set, choosing a routine returns to the check-in
/// flow instead of jumping straight to today's plan.
Future<void> showCustomRoutinePickerSheet(
  BuildContext context,
  WidgetRef ref, {
  void Function(CustomRoutine routine)? onPickForCheckIn,
}) {
  final forCheckIn = onPickForCheckIn != null;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final routinesAsync = ref.watch(customRoutinesProvider);
      final scheme = Theme.of(ctx).colorScheme;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  'Custom routine',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: scheme.primaryContainer.withValues(alpha: 0.35),
                leading: Icon(Icons.add_circle_outline, color: scheme.primary),
                title: const Text('Create new routine'),
                subtitle: Text(
                  forCheckIn
                      ? 'Save a template, then pick it below to continue check-in'
                      : 'Pick exercises, save, use any day',
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/custom-routine/new').then((_) {
                    if (forCheckIn) {
                      ref.read(customRoutinesTickProvider.notifier).state++;
                    }
                  });
                },
              ),
              routinesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('$e'),
                ),
                data: (routines) {
                  if (routines.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: Text(
                        'No saved routines yet — create one above, then use it from here or Workout.',
                      ),
                    );
                  }
                  final maxH = MediaQuery.sizeOf(ctx).height * 0.45;
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxH),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: routines.length,
                      itemBuilder: (context, i) {
                        final r = routines[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: scheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          leading: Icon(
                            Icons.format_list_bulleted,
                            color: scheme.primary,
                          ),
                          title: Text(r.name),
                          subtitle: Text('${r.exerciseIds.length} exercises'),
                          trailing: Icon(
                            forCheckIn
                                ? Icons.check_circle_outline
                                : Icons.play_arrow_rounded,
                            color: scheme.primary,
                          ),
                          onTap: () {
                            Navigator.pop(ctx);
                            if (forCheckIn) {
                              onPickForCheckIn(r);
                            } else {
                              useCustomRoutineToday(context, ref, r);
                            }
                          },
                        ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}