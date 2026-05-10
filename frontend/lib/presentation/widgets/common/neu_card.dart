import 'package:flutter/material.dart';
import '../../../core/theme/neubrutalism_theme.dart';

/// Reusable Neubrutalism card container.
/// Sharp corners, thick black border, hard offset shadow.
class NeuCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double shadowX;
  final double shadowY;
  final double borderWidth;
  final VoidCallback? onTap;

  const NeuCard({
    super.key,
    required this.color,
    required this.child,
    this.padding,
    this.shadowX = NeuDimens.shadowXLarge,
    this.shadowY = NeuDimens.shadowYLarge,
    this.borderWidth = NeuDimens.borderWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: neuDecoration(
          color: color,
          borderWidth: borderWidth,
          shadowX: shadowX,
          shadowY: shadowY,
        ),
        child: child,
      ),
    );
  }
}
