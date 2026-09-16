import 'package:flutter/material.dart';

import 'app_log.dart';

/// Logs route pushes, pops, and replacements in plain language.
final class AppNavObserver extends NavigatorObserver {
  String _name(Route<dynamic>? route) {
    if (route == null) return '(unknown)';
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) return name;
    return route.settings.arguments?.toString() ?? route.runtimeType.toString();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    AppLog.info(
      'Navigation',
      'Opened screen: ${_name(route)}',
      {
        'from': _name(previousRoute),
        'route': _name(route),
      },
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    AppLog.info(
      'Navigation',
      'Back from: ${_name(route)}',
      {
        'to': _name(previousRoute),
        'route': _name(route),
      },
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    AppLog.info(
      'Navigation',
      'Replaced screen',
      {
        'from': _name(oldRoute),
        'to': _name(newRoute),
      },
    );
  }
}
