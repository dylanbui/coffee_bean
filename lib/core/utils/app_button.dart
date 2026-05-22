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
  final bool applyIconColor;

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
    this.applyIconColor = true,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Xác định trạng thái vô hiệu hóa thực tế
    final bool effectivelyDisabled = isDisabled || isLoading || onPressed == null;
    final effectiveMainAxisSize = mainAxisSize ?? style.mainAxisSize;
    final double targetHeight = height ?? style.height ?? 48.0;

    // 2. Tính toán màu Foreground thực tế (dùng cho Text, Icon, Loading)
    final Color currentForegroundColor = effectivelyDisabled
        ? (style.disabledTextColor ?? Colors.grey.shade500)
        : style.textColor;

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return style.disabledBackgroundColor ?? Colors.grey.shade300;
        }
        return style.backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.all(currentForegroundColor),
      side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
        final color = states.contains(WidgetState.disabled)
            ? (style.disabledBorderColor ?? Colors.transparent)
            : (style.borderColor ?? Colors.transparent);
        return BorderSide(color: color, width: 1.5);
      }),
      elevation: WidgetStateProperty.all(0),
      // Để Material tự tính toán hoặc dùng padding người dùng truyền vào
      padding: WidgetStateProperty.all(padding ?? const EdgeInsets.symmetric(horizontal: 12)),
      // Khóa chiều cao tối thiểu bằng targetHeight
      minimumSize: WidgetStateProperty.all(Size(
        width ?? (effectiveMainAxisSize == MainAxisSize.min ? 0 : double.infinity),
        targetHeight,
      )),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.borderRadius)),
      ),
      // Luôn tắt Splash của Material nếu dùng TapEffect hoặc khi Loading/Disabled
      splashFactory: NoSplash.splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
    );

    // 3. Xử lý Logic Tap để tránh Double Click nhưng vẫn giữ Visual Active
    // Bỏ AbsorbPointer vì nó làm mất hit-test vùng nút, khiến click bị xuyên thấu.
    // Thay vào đó, ElevatedButton với onPressed: () {} sẽ tự chiếm quyền ưu tiên 
    // trong Gesture Arena, giúp ngăn sự kiện truyền ra ngoài.
    Widget current = ElevatedButton(
      onPressed: effectivelyDisabled ? null : (useTapEffect ? () {} : onPressed),
      style: buttonStyle,
      child: isLoading
          ? (loadingWidget ?? _buildDefaultLoading(currentForegroundColor))
          : _buildContent(currentForegroundColor),
    );

    // 4. Bọc TapEffect để giữ hiệu ứng scale cũ, chỉ áp dụng khi không bị disabled
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

  Widget _buildContent(Color foregroundColor) {
    final bool hasLeftIcon = leftIcon != null;
    final bool hasRightIcon = rightIcon != null;
    final bool hasText = text != null && text!.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasLeftIcon) _buildIconWrapper(leftIcon!, foregroundColor),
        if (hasLeftIcon && hasText) const SizedBox(width: 8),
        if (hasText)
          Flexible(
            child: Text(
              text!,
              style: (style.textStyle ?? const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              )).copyWith(color: foregroundColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (hasText && hasRightIcon) const SizedBox(width: 8),
        if (hasRightIcon) _buildIconWrapper(rightIcon!, foregroundColor),
      ],
    );
  }

  Widget _buildIconWrapper(Widget icon, Color color) {
    Widget currentIcon = IconTheme(
      data: IconThemeData(color: color, size: 18),
      child: icon,
    );

    if (applyIconColor) {
      currentIcon = ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: currentIcon,
      );
    }

    return currentIcon;
  }
}
