import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';

class AppColors {
  static const defaultAccent = Color(0xFFFF6B35);
  static const success = AppNeutrals.success;
  static const warning = AppNeutrals.warning;

  static const hydrationLow = Color(0xFFE53935);
  static const hydrationModerate = Color(0xFFFB8C00);
  static const hydrationGood = Color(0xFF1E88E5);

  static Color hydrationColor(double progress) {
    if (progress < 0.4) return hydrationLow;
    if (progress < 0.8) return hydrationModerate;
    return hydrationGood;
  }

  static String hydrationLevelLabel(double progress) {
    if (progress < 0.4) return 'Low';
    if (progress < 0.8) return 'Moderate';
    return 'Good';
  }
}

class AppTheme {
  static ColorScheme _darkScheme(Color accent) {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: accent,
      onPrimary: Colors.black,
      secondary: AppNeutrals.textMuted,
      onSecondary: AppNeutrals.textPrimary,
      error: AppNeutrals.error,
      onError: Colors.white,
      surface: AppNeutrals.surface,
      onSurface: AppNeutrals.textPrimary,
      onSurfaceVariant: AppNeutrals.textMuted,
      outline: AppNeutrals.border,
      outlineVariant: AppNeutrals.border,
      surfaceContainerHighest: AppNeutrals.surfaceRaised,
      surfaceContainerHigh: AppNeutrals.surfaceRaised,
      surfaceContainer: AppNeutrals.surface,
      surfaceContainerLow: AppNeutrals.canvas,
      surfaceContainerLowest: AppNeutrals.canvas,
      primaryContainer: accent.withValues(alpha: 0.14),
      onPrimaryContainer: AppNeutrals.textPrimary,
      tertiary: AppNeutrals.textFaint,
      onTertiary: AppNeutrals.textPrimary,
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: AppNeutrals.textPrimary,
      onInverseSurface: AppNeutrals.canvas,
      inversePrimary: accent,
    );
  }

  static ColorScheme _lightScheme(Color accent) {
    const onSurf = Color(0xFF1A1917);
    return ColorScheme(
      brightness: Brightness.light,
      primary: accent,
      onPrimary: Colors.white,
      secondary: const Color(0xFF6B6860),
      onSecondary: onSurf,
      error: AppNeutrals.error,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: onSurf,
      onSurfaceVariant: const Color(0xFF6B6860),
      outline: const Color(0xFFD8D6D0),
      outlineVariant: const Color(0xFFE8E6E0),
      surfaceContainerHighest: const Color(0xFFF0EFEC),
      surfaceContainerHigh: const Color(0xFFF0EFEC),
      surfaceContainer: Colors.white,
      surfaceContainerLow: const Color(0xFFF4F3F0),
      surfaceContainerLowest: const Color(0xFFF4F3F0),
      primaryContainer: accent.withValues(alpha: 0.12),
      onPrimaryContainer: onSurf,
      tertiary: const Color(0xFF9C9890),
      onTertiary: onSurf,
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: onSurf,
      onInverseSurface: Colors.white,
      inversePrimary: accent,
    );
  }

  static TextTheme _textTheme(ColorScheme scheme, {required bool dark}) {
    final body = GoogleFonts.sourceSans3(
      color: scheme.onSurface,
      fontWeight: FontWeight.w400,
    );
    final display = GoogleFonts.barlowSemiCondensed(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
    );
    final mono = GoogleFonts.ibmPlexMono(
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return TextTheme(
      displayLarge: display.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
      displayMedium: display.copyWith(fontSize: 26, fontWeight: FontWeight.w700),
      displaySmall: display.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
      headlineLarge: display.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      headlineMedium: display.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      headlineSmall: display.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      titleLarge: display.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: body.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: body.copyWith(fontSize: 16),
      bodyMedium: body.copyWith(fontSize: 15),
      bodySmall: body.copyWith(fontSize: 13, color: scheme.onSurfaceVariant),
      labelLarge: body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: mono.copyWith(fontSize: 12),
      labelSmall: mono.copyWith(
        fontSize: 11,
        color: scheme.onSurfaceVariant.withValues(alpha: dark ? 1 : 0.85),
      ),
    );
  }

  static ThemeData dark(Color accent) {
    final scheme = _darkScheme(accent);
    final textTheme = _textTheme(scheme, dark: true);
    final craft = AppCraftColors.dark(accent);
    final navLabel = GoogleFonts.ibmPlexMono(fontWeight: FontWeight.w500);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: craft.canvas,
      extensions: [craft],
      visualDensity: VisualDensity.compact,
      splashFactory: NoSplash.splashFactory,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: craft.canvas,
        foregroundColor: AppNeutrals.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        shape: const Border(
          bottom: BorderSide(color: AppNeutrals.border, width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        color: craft.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppNeutrals.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppNeutrals.border,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: textTheme.labelLarge,
          elevation: 0,
          overlayColor: accent.withValues(alpha: 0.16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          side: const BorderSide(color: AppNeutrals.border),
          overlayColor: accent.withValues(alpha: 0.08),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          overlayColor: accent.withValues(alpha: 0.08),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: craft.surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppNeutrals.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppNeutrals.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: accent, width: AppEdgeStates.focusBorderWidth),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: craft.surface,
        indicatorColor: Colors.transparent,
        elevation: 0,
        height: 62,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return navLabel.copyWith(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? accent : AppNeutrals.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? accent : AppNeutrals.textMuted,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppNeutrals.border),
        ),
        backgroundColor: craft.surface,
        selectedColor: craft.accentDim,
        checkmarkColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        labelStyle: textTheme.labelMedium,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        thumbColor: accent,
        inactiveTrackColor: craft.surfaceRaised,
      ),
    );
  }

  static ThemeData light(Color accent) {
    final scheme = _lightScheme(accent);
    final textTheme = _textTheme(scheme, dark: false);
    final craft = AppCraftColors.light(accent);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: craft.canvas,
      extensions: [craft],
      visualDensity: VisualDensity.compact,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        shape: Border(
          bottom: BorderSide(color: craft.border, width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: craft.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        indicatorColor: Colors.transparent,
        height: 62,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: craft.border),
        ),
      ),
    );
  }

  static Color parseAccent(String hex) {
    try {
      final cleaned = hex.replaceFirst('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return AppColors.defaultAccent;
    }
  }
}