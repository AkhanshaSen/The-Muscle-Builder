import 'package:flutter/material.dart';

class AppColors {
  static const charcoal = Color(0xFF121212);
  static const charcoalElevated = Color(0xFF1E1E1E);
  static const charcoalSurface = Color(0xFF2A2A2A);
  static const defaultAccent = Color(0xFFFF6B35);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFFB0B0B0);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);

  /// Hydration meter: low / moderate / adequate.
  static const hydrationLow = Color(0xFFE53935);
  static const hydrationModerate = Color(0xFFFB8C00);
  static const hydrationGood = Color(0xFF1E88E5);

  /// Progress fraction of daily goal (0–1).
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
  static ThemeData dark(Color accent) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      surface: AppColors.charcoalElevated,
    ).copyWith(
      primary: accent,
      onPrimary: Colors.black,
      surface: AppColors.charcoalElevated,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.charcoal,
      visualDensity: VisualDensity.compact,
    );

    final textTheme = base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ).copyWith(
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );

    return base.copyWith(
      splashFactory: NoSplash.splashFactory,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.charcoal,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.charcoalElevated,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          overlayColor: accent.withValues(alpha: 0.18),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          overlayColor: accent.withValues(alpha: 0.12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          overlayColor: accent.withValues(alpha: 0.12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.charcoalSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.charcoalElevated,
        indicatorColor: accent.withValues(alpha: 0.25),
        height: 64,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selectedColor: accent.withValues(alpha: 0.25),
        checkmarkColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        thumbColor: accent,
        inactiveTrackColor: AppColors.charcoalSurface,
      ),
    );
  }

  static ThemeData light(Color accent) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      visualDensity: VisualDensity.compact,
    );

    final textTheme = base.textTheme.copyWith(
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      navigationBarTheme: const NavigationBarThemeData(height: 64),
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
