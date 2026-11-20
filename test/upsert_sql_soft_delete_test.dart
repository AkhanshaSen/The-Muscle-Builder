import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated upserts do not reset is_deleted on conflict', () {
    final meals = File('supabase/seed/meals_upsert.sql').readAsStringSync();
    final exercises =
        File('supabase/seed/exercises_upsert_full.sql').readAsStringSync();
    expect(meals, isNot(contains('is_deleted = false,')));
    expect(exercises, isNot(contains('is_deleted = false,')));
    expect(
      meals,
      contains('is_deleted omitted on conflict: preserves admin soft-delete'),
    );
  });
}