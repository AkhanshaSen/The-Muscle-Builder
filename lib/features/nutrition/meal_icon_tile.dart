import 'dart:ui';

import 'package:flutter/material.dart';

/// Meal tile icons for Nutrition cards (no network images required).
class MealVisual {
  const MealVisual({
    required this.emoji,
    required this.tint,
    this.assetPath,
  });

  final String emoji;
  final Color tint;
  /// Optional custom art; when set, [MealIconTile] shows this instead of emoji.
  final String? assetPath;

  /// Custom sticker / illustration assets keyed by meal id.
  static const Map<String, String> _assetByMealId = {
    'pre_banana_almonds': 'assets/images/meals/banana_soaked_almonds.png',
    'pre_poha': 'assets/images/meals/poha_with_peanuts.png',
    'pre_chilla': 'assets/images/meals/moong_dal_chilla.png',
    'pre_idli': 'assets/images/meals/idli_with_sambar.png',
    'pre_upma': 'assets/images/meals/rava_upma.png',
    'pre_toast_pb': 'assets/images/meals/whole_wheat_toast_peanut_butter.png',
    'pre_curd_rice': 'assets/images/meals/curd_rice.png',
    'pre_fruit_curd': 'assets/images/meals/fruit_bowl_curd.png',
  };

  static const Map<String, String> _fallbackEmojiByMealId = {
    'pre_banana_almonds': '🍌',
    'pre_poha': '🥣',
    'pre_chilla': '🫓',
    'pre_idli': '🫓',
    'pre_upma': '🥣',
    'pre_toast_pb': '🍞',
    'pre_curd_rice': '🥛',
    'pre_fruit_curd': '🫐',
  };

  static MealVisual forMeal(String id, String name) {
    final asset = _assetByMealId[id];
    if (asset != null) {
      return MealVisual(
        emoji: _fallbackEmojiByMealId[id] ?? '🍽️',
        tint: const Color(0xFF121212),
        assetPath: asset,
      );
    }

    final key = '${id}_$name'.toLowerCase();
    if (key.contains('ragi') || key.contains('millet') || key.contains('bajra')) {
      return const MealVisual(emoji: '🌾', tint: Color(0xFF3A3428));
    }
    if (key.contains('spinach') ||
        key.contains('palak') ||
        key.contains('saag') ||
        key.contains('greens')) {
      return const MealVisual(emoji: '🥬', tint: Color(0xFF2A3F2E));
    }
    if (key.contains('pomegranate') || key.contains('anar')) {
      return const MealVisual(emoji: '🍎', tint: Color(0xFF4A2A32));
    }
    if (key.contains('papaya') || key.contains('mango')) {
      return const MealVisual(emoji: '🥭', tint: Color(0xFF4A3A28));
    }
    if (key.contains('apple') || key.contains('berry') || key.contains('berries')) {
      return const MealVisual(emoji: '🫐', tint: Color(0xFF2E3A4A));
    }
    if (key.contains('date') || key.contains('khajoor') || key.contains('khajur')) {
      return const MealVisual(emoji: '🌴', tint: Color(0xFF3A2E22));
    }
    if (key.contains('banana') || key.contains('fruit')) {
      return const MealVisual(emoji: '🍌', tint: Color(0xFF3D5A2E));
    }
    if (key.contains('poha') || key.contains('upma') || key.contains('oats')) {
      return const MealVisual(emoji: '🥣', tint: Color(0xFF4A3B2A));
    }
    if (key.contains('chilla') || key.contains('dosa') || key.contains('idli')) {
      return const MealVisual(emoji: '🫓', tint: Color(0xFF3A3428));
    }
    if (key.contains('toast') || key.contains('bread') || key.contains('paratha')) {
      return const MealVisual(emoji: '🍞', tint: Color(0xFF4A3728));
    }
    if (key.contains('shake') || key.contains('whey') || key.contains('smoothie')) {
      return const MealVisual(emoji: '🥤', tint: Color(0xFF2E3A4A));
    }
    if (key.contains('cake') || key.contains('pancake') || key.contains('mug')) {
      return const MealVisual(emoji: '🧁', tint: Color(0xFF4A3A2E));
    }
    if (key.contains('curd') ||
        key.contains('dahi') ||
        key.contains('yogurt') ||
        key.contains('yoghurt') ||
        key.contains('chaas') ||
        key.contains('buttermilk') ||
        key.contains('raita') ||
        key.contains('doi')) {
      return const MealVisual(emoji: '🥛', tint: Color(0xFF2A3A45));
    }
    if (key.contains('egg') || key.contains('omelette')) {
      return const MealVisual(emoji: '🥚', tint: Color(0xFF4A4530));
    }
    if (key.contains('paneer') || key.contains('tofu')) {
      return const MealVisual(emoji: '🧀', tint: Color(0xFF3A4030));
    }
    if (key.contains('sprout') || key.contains('salad') || key.contains('chana')) {
      return const MealVisual(emoji: '🥗', tint: Color(0xFF2E4A35));
    }
    if (key.contains('rajma') ||
        key.contains('dal') ||
        key.contains('khichdi') ||
        key.contains('sambar')) {
      return const MealVisual(emoji: '🍛', tint: Color(0xFF4A3028));
    }
    if (key.contains('chicken') || key.contains('fish')) {
      return const MealVisual(emoji: '🍗', tint: Color(0xFF4A2E2E));
    }
    if (key.contains('rice') || key.contains('chawal')) {
      return const MealVisual(emoji: '🍚', tint: Color(0xFF353530));
    }
    if (key.contains('whey') || key.contains('protein') || key.contains('soya')) {
      return const MealVisual(emoji: '💪', tint: Color(0xFF2E3A4A));
    }
    return const MealVisual(emoji: '🍽️', tint: Color(0xFF333333));
  }
}

class MealIconTile extends StatelessWidget {
  const MealIconTile({
    super.key,
    required this.mealId,
    required this.mealName,
    this.size = 72,
    this.bordered = true,
    this.softGlow = false,
    /// Zooms sticker art inside the tile (crops empty PNG margins).
    this.contentScale = 1,
  });

  final String mealId;
  final String mealName;
  final double size;
  final bool bordered;
  final bool softGlow;
  final double contentScale;

  Widget _artImage(String path, {required double extent}) {
    return Image.asset(
      path,
      width: extent,
      height: extent,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => Text(
        MealVisual.forMeal(mealId, mealName).emoji,
        style: TextStyle(fontSize: extent > 56 ? 40 : 22),
      ),
    );
  }

  /// Soft halo that follows the sticker silhouette (not a square box glow).
  Widget _silhouetteGlow({
    required String path,
    required Color glowColor,
  }) {
    Widget scaledArt({double extra = 1}) {
      return Transform.scale(
        scale: contentScale * extra,
        child: _artImage(path, extent: size),
      );
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          child: Opacity(
            opacity: 0.5,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                glowColor,
                BlendMode.srcATop,
              ),
              child: scaledArt(extra: 1.02),
            ),
          ),
        ),
        scaledArt(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visual = MealVisual.forMeal(mealId, mealName);
    final scheme = Theme.of(context).colorScheme;
    final hasArt = visual.assetPath != null;
    final radius = size > 56 ? 20.0 : 12.0;
    final glowTint = Color.lerp(scheme.primary, Colors.white, 0.25)!;

    if (softGlow && hasArt) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRect(
          child: _silhouetteGlow(
            path: visual.assetPath!,
            glowColor: glowTint,
          ),
        ),
      );
    }

    final content = hasArt
        ? Transform.scale(
            scale: contentScale,
            child: _artImage(visual.assetPath!, extent: size),
          )
        : Text(
            visual.emoji,
            style: TextStyle(fontSize: size > 56 ? 40 : 22),
          );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: visual.tint.withValues(alpha: softGlow ? 0.85 : 1),
        borderRadius: BorderRadius.circular(radius),
        border: bordered
            ? Border.all(color: scheme.primary.withValues(alpha: 0.35))
            : null,
        boxShadow: softGlow
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.22),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: softGlow
          ? content
          : Padding(
              padding: EdgeInsets.all(size > 80 ? 4 : 2),
              child: content,
            ),
    );
  }
}

