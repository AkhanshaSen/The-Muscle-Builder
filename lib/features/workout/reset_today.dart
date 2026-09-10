import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

/// Shows a confirm dialog, then clears today's check-in/plan via
/// [WorkoutRepository.resetToday] and invalidates the related providers.
/// Returns `true` when the reset ran.
Future<bool> confirmResetToday(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reset today\'s routine?'),
      content: const Text(
        'Your plan and check-in answers for today are cleared. '
        'Finished workouts and your logged day stay.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;

  await ref.read(workoutRepositoryProvider).resetToday();
  ref.invalidate(todaysCheckInProvider);
  ref.invalidate(todaysPlanProvider);
  ref.invalidate(muscleRecoveryProvider);
  return true;
}
