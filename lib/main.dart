import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/constants/app_constants.dart';
import 'core/logging/app_log_bootstrap.dart';
import 'core/logging/app_provider_observer.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  bootstrapAppLogging();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  if (AppConstants.hasSupabaseKey) {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,
    );
  } else if (kDebugMode) {
    debugPrint(
      'MuscleBuilder: SUPABASE_ANON_KEY not set — using bundled assets. '
      'Pass --dart-define=SUPABASE_ANON_KEY=... to fetch reference data.',
    );
  }

  runApp(
    ProviderScope(
      observers: [AppProviderObserver()],
      child: const MuscleBuilderApp(),
    ),
  );
}
