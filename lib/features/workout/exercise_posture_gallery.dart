import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/design_tokens.dart';

/// Side-by-side start/end posture frames from free-exercise-db (Unlicense).
class ExercisePostureGallery extends StatelessWidget {
  const ExercisePostureGallery({
    super.key,
    required this.imageUrls,
    this.height = 100,
    this.showHeader = true,
  });

  final List<String> imageUrls;
  final double height;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final craft = context.craft;

    if (imageUrls.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: craft.surfaceRaised,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: craft.border),
        ),
        child: Center(
          child: Text(
            'Form visuals unavailable offline',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }

    final labels = imageUrls.length >= 2
        ? const ['Start', 'Finish']
        : const ['Form'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Text(
            'How it should look',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.s3),
        ],
        SizedBox(
          height: height,
          child: Row(
            children: [
              for (var i = 0; i < imageUrls.take(2).length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: _PostureTile(
                    url: imageUrls[i],
                    label: labels[i.clamp(0, labels.length - 1)],
                    borderColor: craft.border,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          'Public-domain form photos · free-exercise-db',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 10,
            color: craft.textFaint,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PostureTile extends StatelessWidget {
  const _PostureTile({
    required this.url,
    required this.label,
    required this.borderColor,
  });

  final String url;
  final String label;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.craft.surfaceRaised,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              fadeInDuration: const Duration(milliseconds: 180),
              placeholder: (_, _) => const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, _, _) => ColoredBox(
                color: context.craft.surface,
                child: Icon(
                  Icons.fitness_center,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    label,
                    style: GoogleFonts.barlowSemiCondensed(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}