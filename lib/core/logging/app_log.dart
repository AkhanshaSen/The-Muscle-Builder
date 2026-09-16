import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Debug-only structured logs for `flutter run` / DevTools.
/// All lines are prefixed with `[MuscleBuilder]` for easy filtering.
abstract final class AppLog {
  static const _app = 'MuscleBuilder';

  static void info(String tag, String message, [Map<String, Object?>? details]) {
    _emit('INFO', tag, message, details);
  }

  static void success(String tag, String message, [Map<String, Object?>? details]) {
    _emit('OK', tag, message, details);
  }

  static void warn(String tag, String message, [Map<String, Object?>? details]) {
    _emit('WARN', tag, message, details);
  }

  static void error(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? details,
  }) {
    _emit('ERROR', tag, message, details, error: error, stackTrace: stackTrace);
  }

  /// User tapped a control (button, fox, tab, etc.).
  static void tap(
    String target, {
    String? screen,
    Map<String, Object?>? details,
  }) {
    final data = <String, Object?>{
      if (screen != null) 'screen': screen,
      ...?details,
    };
    _emit('TAP', 'UI', 'Tapped: $target', data.isEmpty ? null : data);
  }

  /// Visibility / presence of a UI element changed.
  static void visibility(
    String element, {
    required bool visible,
    String? screen,
    Map<String, Object?>? details,
  }) {
    final data = <String, Object?>{
      'visible': visible,
      if (screen != null) 'screen': screen,
      ...?details,
    };
    _emit(
      visible ? 'OK' : 'INFO',
      'UI',
      visible ? '$element is now visible' : '$element is now hidden',
      data,
    );
  }

  static void _emit(
    String level,
    String tag,
    String message,
    Map<String, Object?>? details, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer('[$level][$tag] $message');
    if (details != null && details.isNotEmpty) {
      buffer.write(' — ${_formatDetails(details)}');
    }
    if (error != null) {
      buffer.write(' | error: $error');
    }

    final line = '[$_app] ${buffer.toString()}';
    // Shows as `I/flutter` in `flutter run` (developer.log alone is easy to miss).
    debugPrint(line);
    if (stackTrace != null) {
      debugPrint('[$_app] stack: $stackTrace');
    }

    developer.log(
      buffer.toString(),
      name: _app,
      level: _levelValue(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static int _levelValue(String level) => switch (level) {
        'ERROR' => 1000,
        'WARN' => 900,
        'TAP' => 800,
        'OK' => 700,
        _ => 500,
      };

  static String _formatDetails(Map<String, Object?> details) {
    return details.entries.map((e) => '${e.key}=${e.value}').join(', ');
  }
}
