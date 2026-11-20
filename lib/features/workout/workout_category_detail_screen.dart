import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/exercise_catalog.dart';
import '../../domain/models/workout_category.dart';
import 'session_exercise_panel.dart';

class WorkoutCategoryDetailScreen extends ConsumerWidget {
  const WorkoutCategoryDetailScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = WorkoutCategory.byId(categoryId);
    final profile = ref.watch(profileProvider).asData?.value;
    final bankAsync = ref.watch(exercisesForProfileProvider);

    if (cat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Category')),
        body: const Center(child: Text('Unknown category')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(cat.title),
        leading: const NestedBackButton(fallbackLocation: '/workout/categories'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.pageCraft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryCta(
                label: 'Use in today\'s check-in',
                icon: Icons.bolt_outlined,
                onPressed: () {
                  ref.read(workoutCategoryDraftProvider.notifier).state =
                      WorkoutCategoryDraft(categoryId: categoryId);
                  context.push('/checkin');
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  final muscles = cat.prefillMuscles.map((m) => m.name).join(',');
                  context.push(
                    '/custom-routine/new?muscles=$muscles&fromCategory=$categoryId',
                  );
                },
                child: const Text('Build custom routine from category'),
              ),
            ],
          ),
        ),
      ),
      body: bankAsync.when(
        loading: () => const Center(child: LinearProgressIndicator(minHeight: 2)),
        error: (e, _) => Center(child: Text('$e')),
        data: (bank) {
          final list = ExerciseCatalog.dedupeByDisplayName(
            ExerciseCatalog.filterByCategory(
              bank,
              categoryId,
              gender: profile?.gender,
            ),
          );
          return ListView(
            padding: AppSpacing.pageCraft,
            children: [
              Text(cat.subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.s4),
              Text(
                '${list.length} exercises',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.s3),
              ...list.map(
                (ex) => CatalogExerciseRow(
                  exercise: ex,
                  selected: false,
                  onPreviewTap: () {
                    context.push(
                      '/custom-routine/new?search=${Uri.encodeComponent(ex.name)}&fromCategory=$categoryId',
                    );
                  },
                  onTogglePick: () {
                    context.push(
                      '/custom-routine/new?search=${Uri.encodeComponent(ex.name)}&fromCategory=$categoryId',
                    );
                  },
                  legacyOnTap: () {
                    context.push(
                      '/custom-routine/new?search=${Uri.encodeComponent(ex.name)}&fromCategory=$categoryId',
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}