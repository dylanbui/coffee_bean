import 'package:flutter/material.dart';

class DiagonalStripesWidget extends StatelessWidget {
  final Color stripeColor;
  final double stripeWidth;
  final double gap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? child;
  final Color? backgroundColor;

  const DiagonalStripesWidget({
    super.key,
    this.stripeColor = const Color(0x1A000000), // Mặc định đen mờ (10%)
    this.stripeWidth = 1.5,
    this.gap = 10.0,
    this.width,
    this.height,
    this.borderRadius,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = CustomPaint(
      painter: _DiagonalStripePainter(
        stripeColor: stripeColor,
        stripeWidth: stripeWidth,
        gap: gap,
      ),
      child: child,
    );

    if (backgroundColor != null || borderRadius != null) {
      content = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
        child: content,
      );
    } else {
      content = SizedBox(
        width: width,
        height: height,
        child: content,
      );
    }

    return content;
  }
}

class _DiagonalStripePainter extends CustomPainter {
  final Color stripeColor;
  final double stripeWidth;
  final double gap;

  _DiagonalStripePainter({
    required this.stripeColor,
    required this.stripeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke;

    // Vẽ các đường chéo từ trái qua phải
    // Bắt đầu từ tọa độ âm để phủ kín góc trên bên trái
    for (double i = -size.height; i < size.width; i += gap) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DiagonalStripePainter oldDelegate) {
    return oldDelegate.stripeColor != stripeColor ||
        oldDelegate.stripeWidth != stripeWidth ||
        oldDelegate.gap != gap;
  }
}
