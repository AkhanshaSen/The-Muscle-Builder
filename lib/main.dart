import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/logging/app_log_bootstrap.dart';
import 'core/logging/app_provider_observer.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  bootstrapAppLogging();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  runApp(
    ProviderScope(
      observers: [AppProviderObserver()],
      child: const MuscleBuilderApp(),
    ),
  );
}
