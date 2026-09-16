import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import 'app_log.dart';

/// Logs go_router location changes (shell + full-screen routes).
final class GoRouterLog {
  GoRouter? _router;
  String? _lastLocation;

  void attach(GoRouter router) {
    _router = router;
    router.routerDelegate.addListener(_onRouteChanged);
    // GoRouter has no matched route until the first frame; reading
    // [GoRouter.state] during [routerProvider] creation throws.
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _onRouteChanged(initial: true);
    });
  }

  void detach() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    _router = null;
  }

  void _onRouteChanged({bool initial = false}) {
    final router = _router;
    if (router == null) return;

    final loc = _matchedLocation(router);
    if (loc == null) return;
    if (loc == _lastLocation) return;

    if (initial || _lastLocation == null) {
      AppLog.info('Navigation', 'App started on: $loc');
    } else {
      AppLog.success(
        'Navigation',
        'Now on screen: $loc',
        {
          'from': _lastLocation ?? '(none)',
          'path': loc,
          'uri': _uri(router) ?? loc,
        },
      );
    }
    _lastLocation = loc;
  }

  static String? _matchedLocation(GoRouter router) {
    try {
      return router.state.matchedLocation;
    } on StateError {
      return null;
    }
  }

  static String? _uri(GoRouter router) {
    try {
      return router.state.uri.toString();
    } on StateError {
      return null;
    }
  }
}
