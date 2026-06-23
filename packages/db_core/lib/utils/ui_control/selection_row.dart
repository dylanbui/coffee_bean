import 'package:db_core/utils/common_style.dart';
import 'package:flutter/material.dart';

class DbSelectionRow extends StatelessWidget {
  final String title;
  final String? value;
  final String? trailingText;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool showShadow;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final TextStyle? trailingTextStyle;

  const DbSelectionRow({
    super.key,
    required this.title,
    this.value,
    this.trailingText,
    this.leading,
    this.trailing,
    this.onTap,
    this.height = 52,
    this.margin,
    this.borderRadius,
    this.showShadow = true,
    this.backgroundColor,
    this.titleStyle,
    this.valueStyle,
    this.trailingTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(28);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Material(
        color: backgroundColor ?? Colors.white,
        borderRadius: effectiveBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: titleStyle ??
                        DbCommonStyle.defaultTextStyle.copyWith(
                          fontWeight: leading != null ? FontWeight.w500 : FontWeight.bold,
                          color: DbCommonStyle.primaryColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    value!,
                    style: valueStyle ?? DbCommonStyle.defaultTextStyle.copyWith(color: DbCommonStyle.primaryColor),
                  ),
                ],
                if (trailingText != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    trailingText!,
                    style: trailingTextStyle ??
                        DbCommonStyle.defaultTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: trailingText!.startsWith('-') ? DbCommonStyle.errorColor : DbCommonStyle.primaryColor,
                        ),
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
