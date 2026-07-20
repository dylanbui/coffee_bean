import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';

/// AppBottomActionArea: Widget chuẩn để ghim các nút bấm ở cạnh dưới màn hình.
/// Bao gồm nền trắng, bóng đổ phía trên và tự động xử lý SafeArea.
class AppBottomActionArea extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;

  const AppBottomActionArea({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor = TMLabsColor.white,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
