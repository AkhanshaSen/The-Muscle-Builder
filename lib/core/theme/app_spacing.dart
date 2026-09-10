import 'package:flutter/material.dart';

/// Shared spacing scale for a denser, consistent layout across screens.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;

  static const page = EdgeInsets.fromLTRB(12, 8, 12, 16);
  static const card = EdgeInsets.all(12);
  static const cardTight = EdgeInsets.fromLTRB(12, 10, 12, 10);
}
