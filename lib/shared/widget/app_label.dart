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

  const AppLabelStyleConfig({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.minFontSize = 8,
    this.stepGranularity = 1,
    this.maxLines = 1,
  });
}

/// AppLabel: Widget hiển thị text có khả năng tự thu nhỏ font chữ sử dụng thư viện flutter_auto_size_text.
///
/// Widget này kết hợp khả năng tự co giãn font chữ của AutoSizeText với các thuộc tính
/// của một Container để tạo ra các Badge hoặc Label linh hoạt.
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
    this.config = const AppLabelStyleConfig(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? config.padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor ?? config.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? config.borderRadius),
        border: (borderColor ?? config.borderColor) != null 
            ? Border.all(color: (borderColor ?? config.borderColor)!, width: 1) 
            : null,
      ),
      child: AutoSizeText(
        text,
        style: style,
        maxLines: maxLines ?? config.maxLines,
        minFontSize: minFontSize ?? config.minFontSize,
        stepGranularity: stepGranularity ?? config.stepGranularity,
        overflow: TextOverflow.ellipsis,
        textAlign: _getTextAlign(alignment),
      ),
    );
  }

  TextAlign _getTextAlign(Alignment alignment) {
    if (alignment == Alignment.center) return TextAlign.center;
    if (alignment == Alignment.centerLeft) return TextAlign.left;
    if (alignment == Alignment.centerRight) return TextAlign.right;
    return TextAlign.start;
  }
}
