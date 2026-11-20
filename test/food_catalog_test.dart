import 'package:flutter_test/flutter_test.dart';
import 'package:the_muscle_builder/domain/engines/food_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(FoodCatalog.invalidate);

  test('BREAD matches catalog bread entries', () async {
    final bank = await FoodCatalog.load();
    final hits = FoodCatalog.search(bank, 'BREAD');
    expect(hits, isNotEmpty);
    expect(
      hits.any((f) => f.name.toLowerCase().contains('bread')),
      isTrue,
    );
  });

  test('whole wheat bread matches atta / brown variants', () async {
    final bank = await FoodCatalog.load();
    final hits = FoodCatalog.search(bank, 'whole wheat bread');
    expect(hits, isNotEmpty);
    final best = FoodCatalog.bestMatch(bank, 'brown bread');
    expect(best, isNotNull);
    expect(best!.name.toLowerCase(), contains('bread'));
  });
}