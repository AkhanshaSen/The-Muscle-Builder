import 'package:flutter/foundation.dart';

/// User-facing error copy. Never dump raw exceptions in release builds.
String userSafeError([Object? error]) {
  if (kDebugMode && error != null) return '$error';
  return 'Something went wrong. Try again.';
}
