import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/design_tokens.dart';
import '../../domain/engines/exercise_catalog.dart';
import '../../domain/engines/exercise_visuals.dart';
import '../../domain/models/models.dart';
import 'exercise_silent_video.dart';

class ExercisePreviewExpandable extends StatelessWidget {
  const ExercisePreviewExpandable({
    super.key,
    required this.exercise,
    required this.selected,
    required this.onAdd,
    required this.onRemove,
  });

  final Exercise exercise;
  final bool selected;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final craft = context.craft;
    final sections = ExerciseVisuals.sections(exercise);
    final steps = ExerciseCatalog.quickSteps(exercise);
    final video = exercise.demoVideoUrl;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: craft.surfaceRaised,
          border: Border.all(color: craft.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (video != null && video.isNotEmpty) ...[
                ExerciseSilentVideo(url: video),
                const SizedBox(height: AppSpacing.s3),
              ],
              if (sections.any((s) => s.imageUrl.isNotEmpty))
                SizedBox(
                  height: 118,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: sections.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final s = sections[i];
                      return SizedBox(
                        width: 132,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: CachedNetworkImage(
                                  imageUrl: s.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) =>
                                      ColoredBox(color: craft.surface),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              else
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Step ${i + 1}: ${steps[i]}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              const SizedBox(height: AppSpacing.s3),
              Row(
                children: [
                  Expanded(
                    child: selected
                        ? OutlinedButton(
                            onPressed: onRemove,
                            child: const Text('Remove from routine'),
                          )
                        : FilledButton(
                            onPressed: onAdd,
                            child: const Text('Add to routine'),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}