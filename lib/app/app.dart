import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../domain/models/enums.dart';
import 'providers.dart';
import 'router.dart';

class MuscleBuilderApp extends ConsumerWidget {
  const MuscleBuilderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final profileAsync = ref.watch(profileProvider);

    final accentHex = profileAsync.asData?.value?.themeColorHex ??
        AppConstants.defaultAccentHex;
    final accent = AppTheme.parseAccent(accentHex);
    final preference =
        profileAsync.asData?.value?.themePreference ?? ThemePreference.dark;

    final mode = switch (preference) {
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
      ThemePreference.system => ThemeMode.system,
    };

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(accent),
      darkTheme: AppTheme.dark(accent),
      themeMode: mode,
      // Prevents Android stretch-overscroll from vertically elongating UI.
      scrollBehavior: const NoStretchScrollBehavior(),
      routerConfig: router,
    );
  }
}
