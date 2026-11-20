import '../models/models.dart';
import 'exercise_catalog.dart';

class ExerciseVisualSection {
  const ExerciseVisualSection({required this.imageUrl, required this.caption});

  final String imageUrl;
  final String caption;
}

class ExerciseVisuals {
  ExerciseVisuals._();

  static List<String> resolveFrameUrls(Exercise e) {
    if (e.demoFrames.isNotEmpty) {
      return e.demoFrames.take(5).toList();
    }
    if (e.demoImages.isNotEmpty) {
      return e.demoImages.take(5).toList();
    }
  final url = e.demoUrl;
    if (url == null || url.isEmpty) return const [];
    return [url];
  }

  static List<ExerciseVisualSection> sections(Exercise e) {
    final frames = resolveFrameUrls(e);
    final steps = ExerciseCatalog.quickSteps(e);
    if (frames.isEmpty) {
      return [
        for (var i = 0; i < steps.length; i++)
          ExerciseVisualSection(
            imageUrl: '',
            caption: 'Step ${i + 1}: ${steps[i]}',
          ),
      ];
    }
    final out = <ExerciseVisualSection>[];
    for (var i = 0; i < frames.length && i < 5; i++) {
      final cap = i < steps.length
          ? 'Step ${i + 1}: ${steps[i]}'
          : 'Frame ${i + 1}';
      out.add(ExerciseVisualSection(imageUrl: frames[i], caption: cap));
    }
    return out;
  }
}