import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// Disk-backed precache for free-exercise-db demo / warm-up URLs.
Future<void> precacheExerciseImageUrls(
  BuildContext context,
  Iterable<String> urls, {
  int maxUrls = 24,
}) async {
  final seen = <String>{};
  final unique = <String>[];
  for (final url in urls) {
    final trimmed = url.trim();
    if (trimmed.isEmpty || !seen.add(trimmed)) continue;
    unique.add(trimmed);
    if (unique.length >= maxUrls) break;
  }
  if (unique.isEmpty) return;

  await Future.wait(
    unique.map((url) async {
      try {
        await precacheImage(
          CachedNetworkImageProvider(url),
          context,
        );
      } catch (_) {
        // Offline / 404 — widgets fall back to error UI.
      }
    }),
  );
}
