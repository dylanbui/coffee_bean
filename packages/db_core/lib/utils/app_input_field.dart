import 'package:flutter/material.dart';

enum AppInputBorderStyle { underline, outline, filled, none }

/// Configuration class for AppInputField styling.
/// This class is pure and doesn't depend on any project-specific styles.
class AppInputStyleConfig {
  final TextStyle? labelStyle;
  final double labelSpacing;
  final AppInputBorderStyle borderStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;

  const AppInputStyleConfig({
    this.labelStyle,
    this.labelSpacing = 8.0,
    this.borderStyle = AppInputBorderStyle.underline,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.contentPadding,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor = Colors.red,
    this.disabledBorderColor,
  });

  AppInputStyleConfig copyWith({
    TextStyle? labelStyle,
    double? labelSpacing,
    AppInputBorderStyle? borderStyle,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    Color? enabledBorderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    Color? disabledBorderColor,
  }) {
    return AppInputStyleConfig(
      labelStyle: labelStyle ?? this.labelStyle,
      labelSpacing: labelSpacing ?? this.labelSpacing,
      borderStyle: borderStyle ?? this.borderStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      enabledBorderColor: enabledBorderColor ?? this.enabledBorderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
    );
  }
}

class AppInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final AppInputStyleConfig config;
  final TextStyle? customLabelStyle;
  final TextStyle? style;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AppInputField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.config = const AppInputStyleConfig(),
    this.customLabelStyle,
    this.style,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: customLabelStyle ?? config.labelStyle,
          ),
          SizedBox(height: config.labelSpacing),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          autofocus: autofocus,
          textInputAction: textInputAction,
          focusNode: focusNode,
          style: style,
          decoration: _buildDecoration(context),
        ),
      ],
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    
    return InputDecoration(
      hintText: hintText,
      hintStyle: style?.copyWith(color: style?.color?.withValues(alpha: 0.5)) ?? 
                 const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: config.contentPadding ?? (config.borderStyle == AppInputBorderStyle.outline 
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : const EdgeInsets.symmetric(vertical: 8)),
      filled: config.borderStyle == AppInputBorderStyle.filled || config.backgroundColor != null,
      fillColor: config.backgroundColor,
      border: _getBorder(),
      enabledBorder: _getBorder(color: config.enabledBorderColor ?? theme.dividerColor),
      focusedBorder: _getBorder(color: config.focusedBorderColor ?? theme.primaryColor, width: 1.5),
      errorBorder: _getBorder(color: config.errorBorderColor),
      focusedErrorBorder: _getBorder(color: config.errorBorderColor, width: 1.5),
      disabledBorder: _getBorder(color: config.disabledBorderColor ?? theme.disabledColor.withValues(alpha: 0.1)),
      counterText: "",
    );
  }

  InputBorder _getBorder({Color? color, double width = 1.0}) {
    final borderSide = color != null ? BorderSide(color: color, width: width) : BorderSide.none;
    
    switch (config.borderStyle) {
      case AppInputBorderStyle.underline:
        return UnderlineInputBorder(borderSide: borderSide);
      case AppInputBorderStyle.outline:
      case AppInputBorderStyle.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
          borderSide: borderSide,
        );
      case AppInputBorderStyle.none:
        return InputBorder.none;
    }
  }
}
