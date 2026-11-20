import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/models/workout_category.dart';

class WorkoutCategoriesScreen extends ConsumerWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout categories'),
        leading: const NestedBackButton(fallbackLocation: '/workout'),
      ),
      body: ListView(
        padding: AppSpacing.pageCraft,
        children: [
          Text(
            'Choose a focus. Sort and filter inside each category.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.s4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.s4,
              crossAxisSpacing: AppSpacing.s4,
              childAspectRatio: 0.92,
            ),
            itemCount: WorkoutCategory.catalog.length,
            itemBuilder: (context, i) {
              final cat = WorkoutCategory.catalog[i];
              return _CategoryTile(
                category: cat,
                onTap: () => context.push('/workout/categories/${cat.id}'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final WorkoutCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final craft = context.craft;
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: craft.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: CachedNetworkImage(
                  imageUrl: category.heroImageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => ColoredBox(
                    color: craft.surfaceRaised,
                    child: const Icon(Icons.fitness_center),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}