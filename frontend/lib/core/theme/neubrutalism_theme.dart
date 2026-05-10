import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────
/// HealthSync Neubrutalism Design System
/// ─────────────────────────────────────────────
abstract class NeuColors {
  // Tri-color palette
  static const Color yellow = Color(0xFFFFF000);
  static const Color pink = Color(0xFFFF007F);
  static const Color mint = Color(0xFF00FF66);

  // Neutrals
  static const Color background = Color(0xFFFFFCF0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

abstract class NeuDimens {
  static const double borderWidth = 4.0;
  static const double shadowX = 6.0;
  static const double shadowY = 6.0;
  static const double shadowXLarge = 8.0;
  static const double shadowYLarge = 8.0;
  static const BorderRadius radius = BorderRadius.zero;
}

/// Returns the standard Neubrutalism box decoration.
BoxDecoration neuDecoration({
  required Color color,
  double borderWidth = NeuDimens.borderWidth,
  double shadowX = NeuDimens.shadowX,
  double shadowY = NeuDimens.shadowY,
}) =>
    BoxDecoration(
      color: color,
      border: Border.all(color: NeuColors.black, width: borderWidth),
      borderRadius: NeuDimens.radius,
      boxShadow: [
        BoxShadow(
          color: NeuColors.black,
          offset: Offset(shadowX, shadowY),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );

/// Standard bold black text style used throughout the app.
TextStyle neuText({
  double size = 16,
  FontWeight weight = FontWeight.w900,
  Color color = NeuColors.black,
  double? letterSpacing,
}) =>
    TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.1,
    );
