import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_log.dart';

/// Logs Riverpod provider failures in readable form.
final class AppProviderObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLog.error(
      'Provider',
      'Provider failed: ${provider.name ?? provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
