import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import '../features/home/home_screen.dart';
import '../features/mood_checkin/checkin_screen.dart';
import '../features/nutrition/nutrition_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/progress/day_detail_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/progress/guides_screen.dart';
import '../features/workout/session_screen.dart';
import '../features/workout/workout_plan_screen.dart';
import '../features/workout/workout_tab_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation.startsWith('/onboarding');
      // Read (don't watch) so profile chip saves don't recreate GoRouter
      // and bounce the shell back to /home.
      final profileAsync = ref.read(profileProvider);
      final profile = profileAsync.asData?.value;
      final loading = profileAsync.isLoading && !profileAsync.hasValue;

      if (loading) return null;

      final onboarded = profile?.onboardingComplete == true;
      if (!onboarded && !loggingIn) return '/onboarding';
      if (onboarded && loggingIn) return '/home';
      return null;
    },
    routes: [
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
        parentNavigatorKey: _rootKey,
        path: '/checkin',
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/plan/:planId',
        builder: (context, state) {
          final id = state.pathParameters['planId']!;
          return WorkoutPlanScreen(planId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/session/:sessionId',
        builder: (context, state) {
          final id = state.pathParameters['sessionId']!;
          return SessionScreen(sessionId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
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
        parentNavigatorKey: _rootKey,
        path: '/guides',
        builder: (context, state) => const GuidesScreen(),
      ),
    ],
  );
});

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
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Material(
        color: scheme.surfaceContainer,
        elevation: 3,
        child: SafeArea(
          top: false,
          maintainBottomViewPadding: true,
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
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
    );
  }
}
