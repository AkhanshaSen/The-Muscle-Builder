import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const expandMs = 220;
  static const pressMs = 120;
  static const staggerMs = 40;
  static const skeletonMs = 1200;

  static const expandCurve = Curves.easeOutCubic;
  static const pressCurve = Curves.easeOut;
  static const skeletonCurve = Curves.easeOutCubic;

  static Duration expandDuration = const Duration(milliseconds: expandMs);
  static Duration pressDuration = const Duration(milliseconds: pressMs);
  static Duration staggerDuration(int index) =>
      Duration(milliseconds: (index.clamp(0, 4)) * staggerMs);
}