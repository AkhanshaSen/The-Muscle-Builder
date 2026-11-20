import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/models.dart';
import '../db/app_database.dart';

class CustomFoodRepository {
  CustomFoodRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  static String normalizeLabel(String label) =>
      label.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  Stream<List<CustomFoodItem>> watchUserFoods() {
    final q = _db.select(_db.customFoodItems)
      ..where((t) => t.source.equals(MealFoodSource.userInputted.stored))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch().map((rows) => rows.map(_map).toList());
  }

  Future<List<CustomFoodItem>> listUserFoods() async {
    final rows = await (_db.select(_db.customFoodItems)
          ..where((t) => t.source.equals(MealFoodSource.userInputted.stored))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_map).toList();
  }

  Future<void> upsertFromLineItem(MealLogLineItem item) async {
    if (item.resolvedSource != MealFoodSource.userInputted) return;
    final normalized = normalizeLabel(item.label);
    if (normalized.isEmpty) return;

    final perServing = item.quantity <= 0 ? 1.0 : item.quantity;
    final existing = await (_db.select(_db.customFoodItems)
          ..where((t) => t.normalizedLabel.equals(normalized))
          ..where((t) => t.source.equals(MealFoodSource.userInputted.stored))
          ..limit(1))
        .getSingleOrNull();

    final kcal = item.kcal / perServing;
    final protein = item.proteinG / perServing;
    final carbs = item.carbsG / perServing;
    final fat = item.fatG / perServing;

    if (existing != null) {
      await (_db.update(_db.customFoodItems)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        CustomFoodItemsCompanion(
          label: Value(item.label.trim()),
          servingLabel: Value(item.unit),
          kcal: Value(kcal),
          proteinG: Value(protein),
          carbsG: Value(carbs),
          fatG: Value(fat),
        ),
      );
      return;
    }

    await _db.into(_db.customFoodItems).insert(
          CustomFoodItemsCompanion.insert(
            id: _uuid.v4(),
            label: item.label.trim(),
            normalizedLabel: normalized,
            source: MealFoodSource.userInputted.stored,
            systemFoodId: const Value.absent(),
            servingLabel: Value(item.unit),
            kcal: Value(kcal),
            proteinG: Value(protein),
            carbsG: Value(carbs),
            fatG: Value(fat),
            createdAt: DateTime.now(),
          ),
        );
  }

  CustomFoodItem _map(CustomFoodItemRow row) {
    return CustomFoodItem(
      id: row.id,
      label: row.label,
      source: MealFoodSource.fromStored(row.source),
      systemFoodId: row.systemFoodId,
      servingLabel: row.servingLabel,
      kcal: row.kcal,
      proteinG: row.proteinG,
      carbsG: row.carbsG,
      fatG: row.fatG,
      createdAt: row.createdAt,
    );
  }
}