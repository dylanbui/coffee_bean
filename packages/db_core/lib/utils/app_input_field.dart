import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppInputBorderStyle { underline, outline, filled, none }

/// Configuration class for AppInputField styling.
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

/// A highly customizable input field that follows the project's design system.
/// Features a "Smart Error" system that avoids constant layout shifts by
/// only expanding the error message when focused or toggled.
class AppInputField extends StatefulWidget {
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
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  /// Optional list of formatters to apply to the input (e.g., filtering digits).
  final List<TextInputFormatter>? inputFormatters;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Called when the user submits the form (e.g., pressing "Done" or "Enter").
  final ValueChanged<String>? onFieldSubmitted;

  /// Called when editing is complete (alternative to onFieldSubmitted).
  final VoidCallback? onEditingComplete;

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
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.onFieldSubmitted,
    this.onEditingComplete,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late FocusNode _focusNode;
  bool _isErrorExpanded = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    widget.controller?.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTextChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && widget.errorText != null) {
      setState(() => _isErrorExpanded = true);
    } else if (!_focusNode.hasFocus) {
      setState(() => _isErrorExpanded = false);
    }
  }

  void _handleTextChange() {
    if (_isErrorExpanded && _focusNode.hasFocus) {
      setState(() => _isErrorExpanded = false);
    }
  }

  @override
  void didUpdateWidget(AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleTextChange);
      widget.controller?.addListener(_handleTextChange);
    }

    // If a new error appears while focused, expand it
    if (widget.errorText != oldWidget.errorText && widget.errorText != null && _focusNode.hasFocus) {
      setState(() => _isErrorExpanded = true);
    }
    // If error is cleared, collapse
    if (widget.errorText == null) {
      setState(() => _isErrorExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: widget.customLabelStyle ?? widget.config.labelStyle,
          ),
          SizedBox(height: widget.config.labelSpacing),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onChanged: (value) {
            _handleTextChange();
            widget.onChanged?.call(value);
          },
          validator: widget.validator,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          focusNode: _focusNode,
          inputFormatters: widget.inputFormatters,
          textAlign: widget.textAlign,
          onFieldSubmitted: widget.onFieldSubmitted,
          onEditingComplete: widget.onEditingComplete,
          style: widget.style,
          decoration: _buildDecoration(context),
        ),
        _buildErrorWidget(),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: _isErrorExpanded && widget.errorText != null
          ? Padding(
              key: ValueKey(widget.errorText),
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12, height: 1.2),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    // The error is considered "active" if there's error text AND it's either expanded
    // OR the field is not focused (to maintain the error border when not interacting).
    final hasError = widget.errorText != null &&
        widget.errorText!.isNotEmpty &&
        (_isErrorExpanded || !_focusNode.hasFocus);

    return InputDecoration(
      hintText: widget.hintText,
      errorText: null,
      hintStyle: widget.style?.copyWith(color: widget.style?.color?.withValues(alpha: 0.5)) ??
          const TextStyle(color: Colors.grey),
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(hasError, theme),
      contentPadding: widget.config.contentPadding ??
          (widget.config.borderStyle == AppInputBorderStyle.outline
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              : const EdgeInsets.symmetric(vertical: 8)),
      filled: widget.config.borderStyle == AppInputBorderStyle.filled || widget.config.backgroundColor != null,
      fillColor: widget.config.backgroundColor,
      border: _getBorder(),
      enabledBorder: _getBorder(
          color: hasError ? (widget.config.errorBorderColor) : (widget.config.enabledBorderColor ?? theme.dividerColor)),
      focusedBorder: _getBorder(
          color: hasError ? (widget.config.errorBorderColor) : (widget.config.focusedBorderColor ?? theme.primaryColor),
          width: 1.5),
      errorBorder: _getBorder(color: widget.config.errorBorderColor),
      focusedErrorBorder: _getBorder(color: widget.config.errorBorderColor, width: 1.5),
      disabledBorder: _getBorder(color: widget.config.disabledBorderColor ?? theme.disabledColor.withValues(alpha: 0.1)),
      counterText: "",
    );
  }

  Widget? _buildSuffixIcon(bool hasError, ThemeData theme) {
    // If no error, just return the user-provided suffixIcon
    if (!hasError) return widget.suffixIcon;

    // If there is an error, we show an error icon that can be tapped to toggle the error text
    final errorIcon = GestureDetector(
      onTap: () => setState(() => _isErrorExpanded = !_isErrorExpanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            _isErrorExpanded ? Icons.close : Icons.error,
            key: ValueKey(_isErrorExpanded),
            color: Colors.red,
            size: 20,
          ),
        ),
      ),
    );

    if (widget.suffixIcon == null) return errorIcon;

    // If there's already a suffixIcon (e.g., eye icon), we show both
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        errorIcon,
        widget.suffixIcon!,
      ],
    );
  }

  InputBorder _getBorder({Color? color, double width = 1.0}) {
    final borderSide = color != null ? BorderSide(color: color, width: width) : BorderSide.none;

    switch (widget.config.borderStyle) {
      case AppInputBorderStyle.underline:
        return UnderlineInputBorder(borderSide: borderSide);
      case AppInputBorderStyle.outline:
      case AppInputBorderStyle.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.config.borderRadius),
          borderSide: borderSide,
        );
      case AppInputBorderStyle.none:
        return InputBorder.none;
    }
  }
}
