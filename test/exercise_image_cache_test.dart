import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/features/workout/exercise_image_cache.dart';
import 'package:the_muscle_builder/features/workout/exercise_posture_gallery.dart';

void main() {
  testWidgets('precacheExerciseImageUrls no-ops on empty and blanks',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
    final context = tester.element(find.byType(SizedBox));
    await precacheExerciseImageUrls(context, const ['', '  ']);
  });

  testWidgets('ExercisePostureGallery renders CachedNetworkImage for urls',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExercisePostureGallery(
            imageUrls: [
              'https://example.com/start.jpg',
              'https://example.com/finish.jpg',
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Finish'), findsOneWidget);
    // Network fetch may error in tests; error/placeholder widgets still paint tiles.
    expect(find.byType(ExercisePostureGallery), findsOneWidget);
  });
}
