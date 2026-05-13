import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
  });

  // Factory methods for common styles
  factory AppButton.primary({
    required String text,
    required VoidCallback onPressed,
  }) => AppButton(text: text, onPressed: onPressed, style: AppButtonStyle.primary);

  factory AppButton.secondary({
    required String text,
    required VoidCallback onPressed,
  }) => AppButton(text: text, onPressed: onPressed, style: AppButtonStyle.secondary);

  factory AppButton.outline({
    required String text,
    required VoidCallback onPressed,
  }) => AppButton(text: text, onPressed: onPressed, style: AppButtonStyle.outline);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style ?? AppButtonStyle.primary,
        child: Text(text),
      ),
    );
  }
}
