import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/providers.dart';
import '../domain/models/enums.dart';
import '../domain/models/models.dart';
import '../features/home/home_screen.dart';
import '../features/mood_checkin/checkin_screen.dart';
import '../features/nutrition/nutrition_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/progress/day_detail_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/progress/guides_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/workout/session_screen.dart';
import '../features/workout/workout_plan_screen.dart';
import '../features/fox_chat/fox_chat_screen.dart';
import '../features/workout/workout_tab_screen.dart';
import '../core/widgets/idle_mascot_host.dart';
import '../core/logging/app_log.dart';
import '../core/logging/app_nav_observer.dart';
import '../core/logging/go_router_log.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  final routeLog = GoRouterLog();
  final router = GoRouter(
    navigatorKey: appNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: refresh,
    observers: [AppNavObserver()],
    redirect: (context, state) => _redirect(ref, state),
    routes: _appRoutes,
  );
  routeLog.attach(router);
  ref.onDispose(routeLog.detach);
  return router;
});

List<RouteBase> get _appRoutes => [
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/workout',
                builder: (context, state) => const WorkoutTabScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/nutrition',
                builder: (context, state) {
                  final timing = state.uri.queryParameters['timing'];
                  final initial = timing == 'post'
                      ? MealTiming.postWorkout
                      : timing == 'pre'
                          ? MealTiming.preWorkout
                          : null;
                  return NutritionScreen(
                    key: ValueKey('nutrition-${timing ?? 'default'}'),
                    initialTiming: initial,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/checkin',
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/plan/:planId',
        builder: (context, state) {
          final id = state.pathParameters['planId']!;
          return WorkoutPlanScreen(planId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/session/:sessionId',
        builder: (context, state) {
          final id = state.pathParameters['sessionId']!;
          return SessionScreen(sessionId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/day/:date',
        builder: (context, state) {
          final raw = state.pathParameters['date']!;
          final parts = raw.split('-');
          final date = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          return DayDetailScreen(date: date);
        },
      ),
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/fox-chat',
        builder: (context, state) => const FoxChatScreen(),
      ),
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/guides',
        builder: (context, state) => const GuidesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: appNavigatorKey,
        path: '/day-history',
        builder: (context, state) => const DayHistoryScreen(),
      ),
    ];

String? _redirect(Ref ref, GoRouterState state) {
  final bypassRedirect =
      state.matchedLocation.startsWith('/onboarding') ||
      state.matchedLocation == '/splash';
  final profileAsync = ref.read(profileProvider);
  final profile = profileAsync.asData?.value;
  final loading = profileAsync.isLoading && !profileAsync.hasValue;

  if (loading) {
    AppLog.info(
      'Navigation',
      'Waiting for profile before routing',
      {'path': state.matchedLocation},
    );
    return null;
  }

  final onboarded = profile?.onboardingComplete == true;
  String? target;
  if (!onboarded && !bypassRedirect) {
    target = '/onboarding';
  } else if (onboarded && state.matchedLocation.startsWith('/onboarding')) {
    target = '/home';
  }

  if (target != null && target != state.matchedLocation) {
    AppLog.info(
      'Navigation',
      'Redirecting for onboarding',
      {'from': state.matchedLocation, 'to': target},
    );
  }
  return target;
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    _sub = ref.listen<AsyncValue<UserProfile?>>(profileProvider, (_, _) {
      notifyListeners();
    });
  }

  final Ref ref;
  late final ProviderSubscription<AsyncValue<UserProfile?>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IdleMascotHost(
      child: Scaffold(
      body: navigationShell,
      bottomNavigationBar: Material(
        color: scheme.surfaceContainer,
        elevation: 3,
        child: SafeArea(
          top: false,
          maintainBottomViewPadding: true,
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              const tabs = [
                'Home',
                'Workout',
                'Nutrition',
                'Progress',
                'Profile',
              ];
              AppLog.tap(
                'Bottom tab: ${tabs[index]}',
                screen: tabs[navigationShell.currentIndex],
                details: {'tabIndex': index},
              );
              navigationShell.goBranch(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Workout',
              ),
              NavigationDestination(
                icon: Icon(Icons.restaurant_outlined),
                selectedIcon: Icon(Icons.restaurant),
                label: 'Nutrition',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights),
                label: 'Progress',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
