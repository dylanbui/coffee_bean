import 'package:flutter/material.dart';

class DbSelectionTable extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool showShadow;
  final Color? dividerColor;
  final double? dividerIndent;
  final bool showDivider;

  const DbSelectionTable({
    super.key,
    required this.children,
    this.margin,
    this.borderRadius,
    this.showShadow = true,
    this.dividerColor,
    this.dividerIndent = 52,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(20);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Column(
          children: List.generate(children.length, (index) {
            return Column(
              children: [
                children[index],
                if (showDivider && index < children.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: dividerIndent,
                    endIndent: 16,
                    color: dividerColor ?? const Color(0xFFF5F5F5),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
