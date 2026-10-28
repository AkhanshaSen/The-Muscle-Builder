import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/constants/app_constants.dart';
import 'core/logging/app_log_bootstrap.dart';
import 'core/logging/app_provider_observer.dart';
import 'data/services/supabase_seeder.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  bootstrapAppLogging();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseAnonKey,
  );

  // Best-effort one-time upsert of reference data; never blocks launch.
  try {
    await SupabaseSeeder(Supabase.instance.client).seedIfNeeded();
  } catch (e, st) {
    debugPrint('Supabase seed skipped: $e\n$st');
  }

  runApp(
    ProviderScope(
      observers: [AppProviderObserver()],
      child: const MuscleBuilderApp(),
    ),
  );
}
