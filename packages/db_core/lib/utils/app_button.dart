import 'package:flutter/material.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';

/*
 * AppButton Usage Guide:
 * 
 * 1. Basic usage:
 *    AppButton(text: "Submit", onPressed: () => print("Tapped"))
 * 
 * 2. Using different styles:
 *    AppButton(
 *      text: "Cancel",
 *      style: TMLabsStyle.outlineButton,
 *      onPressed: () => Navigator.pop(context)
 *    )
 *
 * 3. With Icons and Loading:
 *    AppButton(
 *      text: "Process",
 *      isLoading: _isLoading,
 *      leftIcon: Icon(Icons.send, color: Colors.white),
 *      onPressed: () => _handleProcess(),
 *    )
 */

class AppButtonStyleConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderRadius;
  final double? height;
  final TextStyle? textStyle;
  final MainAxisSize mainAxisSize;

  const AppButtonStyleConfig({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.height = 48.0,
    this.textStyle,
    this.mainAxisSize = MainAxisSize.max,
  });

  AppButtonStyleConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderRadius,
    double? height,
    TextStyle? textStyle,
    MainAxisSize? mainAxisSize,
  }) {
    return AppButtonStyleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
    );
  }
}

class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonStyleConfig style;

  final Widget? leftIcon;
  final Widget? rightIcon;
  final Widget? loadingWidget;
  final double? width;
  final double? height;
  final MainAxisSize? mainAxisSize;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.isLoading = false,
    this.style = TMLabsStyle.primaryButton,
    this.leftIcon,
    this.rightIcon,
    this.loadingWidget,
    this.width,
    this.height,
    this.mainAxisSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final effectiveMainAxisSize = mainAxisSize ?? style.mainAxisSize;

    return TapEffect(
      onClickScale: 0.96,
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: effectiveMainAxisSize == MainAxisSize.min ? width : (width ?? double.infinity),
        height: height ?? style.height,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: (onPressed == null)
              ? Colors.grey.shade300
              : style.backgroundColor,
          borderRadius: BorderRadius.circular(style.borderRadius),
          border: style.borderColor != null
              ? Border.all(color: style.borderColor!, width: 1.5)
              : null,
        ),
        child: Center(
          child: isLoading
              ? (loadingWidget ?? _buildDefaultLoading())
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildDefaultLoading() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(style.textColor),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftIcon != null) ...[
          leftIcon!,
          const SizedBox(width: 8),
        ],
        if (text != null)
          Flexible(
            child: Text(
              text!,
              style: style.textStyle ?? TextStyle(
                color: style.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (rightIcon != null) ...[
          const SizedBox(width: 8),
          rightIcon!,
        ],
      ],
    );
  }
}
