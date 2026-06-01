import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSelectionRow extends StatelessWidget {
  final String title;
  final String? value;
  final String? trailingText;
  final dynamic leadingIcon; // String (SVG) hoặc IconData
  final dynamic trailingIcon; // Để hỗ trợ AppAssets.icons.icArrowRightNone của Profile
  final bool showArrow;
  final bool showCheck;
  final VoidCallback? onTap;
  final double height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const AppSelectionRow({
    super.key,
    required this.title,
    this.value,
    this.trailingText,
    this.leadingIcon,
    this.trailingIcon,
    this.showArrow = true,
    this.showCheck = false,
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
                if (leadingIcon != null) ...[
                  _buildIcon(leadingIcon, color: TMLabsColor.secondary, size: 20),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TMLabsTextStyle.body.copyWith(
                      fontWeight: leadingIcon != null ? FontWeight.w500 : FontWeight.bold,
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
                const SizedBox(width: 8),
                _buildTrailingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(dynamic icon, {required Color color, double size = 20, bool isLeading = true}) {
    if (icon is String) {
      return SizedBox(
        width: isLeading ? size + 4 : null, // Chỉ áp dụng width 24 cho icon bên trái
        child: Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset(
            icon,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      );
    }
    if (icon is IconData) {
      return Icon(icon, color: color, size: size);
    }
    return const SizedBox.shrink();
  }

  Widget _buildTrailingIndicator() {
    if (showCheck) {
      return const Icon(Icons.check_circle, color: TMLabsColor.primary, size: 20);
    }
    if (showArrow) {
      if (trailingIcon != null) {
        return SizedBox(
          width: 14, // Đồng bộ width 14 như yêu cầu
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildIcon(
              trailingIcon, 
              color: TMLabsColor.deepNavy.withValues(alpha: 0.8), 
              size: 18,
              isLeading: false,
            ),
          ),
        );
      }
      return const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey);
    }
    return const SizedBox.shrink();
  }
}
