import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:flutter/material.dart';

/// AppLabelStyleConfig: Configuration for AppLabel styling.
class AppLabelStyleConfig {
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double minFontSize;
  final double stepGranularity;
  final int? maxLines;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;

  const AppLabelStyleConfig({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.minFontSize = 8,
    this.stepGranularity = 1,
    this.maxLines = 1,
    this.shadows,
    this.gradient,
  });
}

/// AppLabel: Widget hiển thị text có khả năng tự thu nhỏ font chữ.
/// Được thiết kế để dùng làm Badge, Tag hoặc nhãn trạng thái.
class AppLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Alignment alignment;
  final double? minFontSize;
  final double? stepGranularity;
  final MainAxisSize mainAxisSize;

  /// Icons
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double iconSpacing;

  /// Decoration nâng cao
  final List<BoxShadow>? shadows;
  final Gradient? gradient;

  final AppLabelStyleConfig config;

  const AppLabel(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.minFontSize,
    this.stepGranularity,
    this.mainAxisSize = MainAxisSize.min,
    this.leadingIcon,
    this.trailingIcon,
    this.iconSpacing = 4.0,
    this.shadows,
    this.gradient,
    this.config = const AppLabelStyleConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Xử lý màu sắc mặc định từ Theme nếu không có config/params
    final effectiveBgColor = backgroundColor ?? config.backgroundColor ?? (gradient == null && config.gradient == null ? theme.primaryColor : null);
    final effectiveTextStyle = (style ?? const TextStyle()).copyWith(
      color: style?.color ?? (effectiveBgColor != null ? _getContrastColor(effectiveBgColor) : null),
    );

    return Container(
      width: width,
      height: height,
      padding: padding ?? config.padding,
      alignment: width != null || height != null ? alignment : null,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        gradient: gradient ?? config.gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? config.borderRadius),
        border: (borderColor ?? config.borderColor) != null
            ? Border.all(color: (borderColor ?? config.borderColor)!, width: 1)
            : null,
        boxShadow: shadows ?? config.shadows,
      ),
      child: Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: _getMainAxisAlignment(alignment),
        children: [
          if (leadingIcon != null) ...[
            leadingIcon!,
            SizedBox(width: iconSpacing),
          ],
          if (mainAxisSize == MainAxisSize.max)
            Expanded(child: _buildText(effectiveTextStyle))
          else
            Flexible(child: _buildText(effectiveTextStyle)),
          if (trailingIcon != null) ...[
            SizedBox(width: iconSpacing),
            trailingIcon!,
          ],
        ],
      ),
    );
  }

  Widget _buildText(TextStyle textStyle) {
    return AutoSizeText(
      text,
      style: textStyle,
      maxLines: maxLines ?? config.maxLines,
      minFontSize: minFontSize ?? config.minFontSize,
      stepGranularity: stepGranularity ?? config.stepGranularity,
      overflow: TextOverflow.ellipsis,
      textAlign: _getTextAlign(alignment),
    );
  }

  TextAlign _getTextAlign(Alignment alignment) {
    if (alignment == Alignment.center) return TextAlign.center;
    if (alignment == Alignment.centerLeft) return TextAlign.left;
    if (alignment == Alignment.centerRight) return TextAlign.right;
    return TextAlign.start;
  }

  MainAxisAlignment _getMainAxisAlignment(Alignment alignment) {
    if (alignment == Alignment.center) return MainAxisAlignment.center;
    if (alignment == Alignment.centerLeft) return MainAxisAlignment.start;
    if (alignment == Alignment.centerRight) return MainAxisAlignment.end;
    return MainAxisAlignment.start;
  }

  Color _getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}
