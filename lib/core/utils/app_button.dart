import 'package:flutter/material.dart';
import 'package:coffee_bean/core/utils/tap_effect.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';

/*
 * AppButton Usage Guide:
 * 
 * 1. Basic usage:
 *    AppButton(text: "Submit", onPressed: () => print("Tapped"))
 * 
 * 2. Using disabled state:
 *    AppButton(
 *      text: "Confirm",
 *      isDisabled: true,
 *      onPressed: () => print("Tap"),
 *    )
 * 
 * 3. Disable Tap Effect:
 *    AppButton(
 *      text: "Static Button",
 *      useTapEffect: false,
 *      onPressed: () => print("Tap"),
 *    )
 */

class AppButtonStyleConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  
  // Màu sắc cho trạng thái Disabled (Optional)
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final Color? disabledBorderColor;

  final double borderRadius;
  final double? height;
  final TextStyle? textStyle;
  final MainAxisSize mainAxisSize;

  const AppButtonStyleConfig({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.disabledBorderColor,
    this.borderRadius = 12.0,
    this.height = 48.0,
    this.textStyle,
    this.mainAxisSize = MainAxisSize.max,
  });

  AppButtonStyleConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    Color? disabledBackgroundColor,
    Color? disabledTextColor,
    Color? disabledBorderColor,
    double? borderRadius,
    double? height,
    TextStyle? textStyle,
    MainAxisSize? mainAxisSize,
  }) {
    return AppButtonStyleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
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
  final bool isDisabled; // Mặc định false
  final bool useTapEffect; // Mặc định true để giữ hiệu ứng "lún" cũ
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
    this.isDisabled = false,
    this.useTapEffect = true,
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
    // Trạng thái vô hiệu hóa
    final bool effectivelyDisabled = isDisabled || isLoading || onPressed == null;
    final effectiveMainAxisSize = mainAxisSize ?? style.mainAxisSize;

    // Cấu hình ButtonStyle tập trung
    final double targetHeight = height ?? style.height ?? 48.0;
    
    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return style.disabledBackgroundColor ?? Colors.grey.shade300;
        }
        return style.backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return style.disabledTextColor ?? Colors.grey.shade500;
        }
        return style.textColor;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
        final color = states.contains(WidgetState.disabled)
            ? (style.disabledBorderColor ?? Colors.transparent)
            : (style.borderColor ?? Colors.transparent);
        return BorderSide(color: color, width: 1.5);
      }),
      elevation: WidgetStateProperty.all(0),
      // Đặt vertical padding về 0 để không làm nở chiều cao của Button
      padding: WidgetStateProperty.all(padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 0)),
      // Khóa chiều cao cố định bằng cách set cả min và max size
      minimumSize: WidgetStateProperty.all(Size(
        effectiveMainAxisSize == MainAxisSize.min ? 0 : (width ?? double.infinity),
        targetHeight,
      )),
      maximumSize: WidgetStateProperty.all(Size(
        width ?? double.infinity,
        targetHeight,
      )),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.borderRadius)),
      ),
      splashFactory: useTapEffect ? NoSplash.splashFactory : InkRipple.splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard, // Quay lại standard để tránh bị thu nhỏ quá mức
    );

    Widget current = ElevatedButton(
      onPressed: effectivelyDisabled ? null : onPressed,
      style: buttonStyle,
      child: isLoading 
          ? (loadingWidget ?? _buildDefaultLoading(style.textColor)) 
          : _buildContent(),
    );

    // Bọc TapEffect để giữ hiệu ứng scale cũ, chỉ áp dụng khi không bị disabled
    if (useTapEffect && !effectivelyDisabled) {
      return TapEffect(
        onTap: onPressed,
        onClickScale: 0.96,
        child: current,
      );
    }

    return current;
  }

  Widget _buildDefaultLoading(Color color) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
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
              style: (style.textStyle ?? const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              )).copyWith(color: null), // Màu chữ sẽ lấy từ foregroundColor của ButtonStyle
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
