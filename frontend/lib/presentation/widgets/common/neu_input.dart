import 'package:flutter/material.dart';
import '../../../core/theme/neubrutalism_theme.dart';

/// Neubrutalism text input — thick black border, zero radius.
class NeuInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final Widget? suffixIcon;

  const NeuInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: neuText(size: 13, letterSpacing: 1.0)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: neuText(size: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: neuText(size: 15, weight: FontWeight.w500, color: Colors.black38),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: NeuColors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(
                color: NeuColors.black,
                width: NeuDimens.borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(
                color: NeuColors.black,
                width: NeuDimens.borderWidth + 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: NeuColors.pink,
                width: NeuDimens.borderWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: NeuColors.pink,
                width: NeuDimens.borderWidth + 1,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}
