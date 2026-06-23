import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
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

  const DbSelectionRow({
    super.key,
    required this.title,
    this.value,
    this.trailingText,
    this.leading,
    this.trailing,
    this.onTap,
    this.height = 56,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(28);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.white,
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
                    style: TMLabsTextStyle.body.copyWith(
                      fontWeight: leading != null ? FontWeight.w500 : FontWeight.bold,
                      color: TMLabsColor.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    value!,
                    style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.primary),
                  ),
                ],
                if (trailingText != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    trailingText!,
                    style: TMLabsTextStyle.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: trailingText!.startsWith('-') ? Colors.red : TMLabsColor.primary,
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
