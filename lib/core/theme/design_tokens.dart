import 'package:flutter/material.dart';

/// Warm neutral palette — no Material `fromSeed` purple bleed.
abstract final class AppNeutrals {
  static const canvas = Color(0xFF0C0C0B);
  static const surface = Color(0xFF141412);
  static const surfaceRaised = Color(0xFF1C1B18);
  static const border = Color(0xFF2E2D28);
  static const textPrimary = Color(0xFFEDEBE6);
  static const textMuted = Color(0xFF8A8780);
  static const textFaint = Color(0xFF5C5A55);

  static const success = Color(0xFF3D9A6A);
  static const warning = Color(0xFFC9A227);
  static const error = Color(0xFFD64545);
}

@immutable
class AppCraftColors extends ThemeExtension<AppCraftColors> {
  const AppCraftColors({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.textMuted,
    required this.textFaint,
    required this.accentDim,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color textMuted;
  final Color textFaint;
  final Color accentDim;

  @override
  AppCraftColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceRaised,
    Color? border,
    Color? textMuted,
    Color? textFaint,
    Color? accentDim,
  }) {
    return AppCraftColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      accentDim: accentDim ?? this.accentDim,
    );
  }

  @override
  AppCraftColors lerp(ThemeExtension<AppCraftColors>? other, double t) {
    if (other is! AppCraftColors) return this;
    return AppCraftColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      border: Color.lerp(border, other.border, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
    );
  }

  static AppCraftColors dark(Color accent) => AppCraftColors(
        canvas: AppNeutrals.canvas,
        surface: AppNeutrals.surface,
        surfaceRaised: AppNeutrals.surfaceRaised,
        border: AppNeutrals.border,
        textMuted: AppNeutrals.textMuted,
        textFaint: AppNeutrals.textFaint,
        accentDim: accent.withValues(alpha: 0.14),
      );

  static AppCraftColors light(Color accent) => AppCraftColors(
        canvas: const Color(0xFFF4F3F0),
        surface: const Color(0xFFFFFFFF),
        surfaceRaised: const Color(0xFFF0EFEC),
        border: const Color(0xFFD8D6D0),
        textMuted: const Color(0xFF6B6860),
        textFaint: const Color(0xFF9C9890),
        accentDim: accent.withValues(alpha: 0.12),
      );
}

extension AppCraftContext on BuildContext {
  AppCraftColors get craft =>
      Theme.of(this).extension<AppCraftColors>() ??
      AppCraftColors.dark(Theme.of(this).colorScheme.primary);
}

/// Edge-state opacity for disabled controls.
abstract final class AppEdgeStates {
  static const disabledOpacity = 0.38;
  static const focusBorderWidth = 2.0;
  static const errorBarWidth = 3.0;
}