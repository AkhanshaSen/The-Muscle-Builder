import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/core/constants/app_constants.dart';

void main() {
  test('app name constant is set', () {
    expect(AppConstants.appName, 'The Muscle Builder');
  });
}
