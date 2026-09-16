import 'package:flutter/foundation.dart';

import 'app_log.dart';

/// Hooks global Flutter errors into [AppLog] (debug builds only).
void bootstrapAppLogging() {
  if (!kDebugMode) return;

  FlutterError.onError = (details) {
    AppLog.error(
      'Flutter',
      details.exceptionAsString(),
      error: details.exception,
      stackTrace: details.stack,
      details: {
        'library': details.library ?? '',
        'context': details.context?.toDescription() ?? '',
      },
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLog.error(
      'Platform',
      'Uncaught async error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  AppLog.success('App', 'Debug logging enabled — filter terminal with "MuscleBuilder"');
}
