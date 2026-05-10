import 'package:flutter/material.dart';
import '../../../core/theme/neubrutalism_theme.dart';

/// Neubrutalism button with press animation:
/// shadow collapses + translate on tap, simulating physical press.
class NeuButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final bool isLoading;

  const NeuButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = NeuColors.pink,
    this.textColor = NeuColors.black,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.icon,
    this.isLoading = false,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? NeuDimens.shadowX : 0,
          _pressed ? NeuDimens.shadowY : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
          borderRadius: NeuDimens.radius,
          boxShadow: _pressed
              ? []
              : [
                  const BoxShadow(
                    color: NeuColors.black,
                    offset: Offset(NeuDimens.shadowX, NeuDimens.shadowY),
                    blurRadius: 0,
                  ),
                ],
        ),
        padding: widget.padding,
        child: widget.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: NeuColors.black,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: neuText(
                      size: widget.fontSize,
                      color: widget.textColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
