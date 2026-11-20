import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/models/models.dart';

void main() {
  test('scaledToQuantity doubles macros when quantity doubles', () {
    const item = MealLogLineItem(
      label: 'Chicken breast',
      quantity: 1,
      unit: '150 g',
      kcal: 248,
      proteinG: 47,
      carbsG: 0,
      fatG: 5,
    );
    final two = item.scaledToQuantity(2);
    expect(two.quantity, 2);
    expect(two.kcal, 496);
    expect(two.proteinG, 94);
  });
}