import 'dart:ui';
import 'package:coffee_bean/data/model/response/promotion/coupon_model.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';

class CouponCardWidget extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onTap;
  final VoidCallback onToggleExpand;

  const CouponCardWidget({
    super.key,
    required this.coupon,
    required this.onTap,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // VÙNG TRÊN: Vùng chọn (Selection Area)
              TapEffect(
                onTap: onTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left Section (30% approx)
                    _buildLeftSection(),
                    
                    // Middle Content (Title + Expiry)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 8, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.name,
                              style: TMLabsTextStyle.bodyBold.copyWith(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getExpiryText(),
                              style: TMLabsTextStyle.caption.copyWith(
                                color: TMLabsColor.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Checkbox (Selection Indicator)
                    _buildSelectionIndicator(),
                    const SizedBox(width: 16),
                  ],
                ),
              ),

              // VÙNG DƯỚI: Nút mở rộng và Nội dung chi tiết
              Padding(
                padding: const EdgeInsets.fromLTRB(112, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TapEffect(
                      onTap: onToggleExpand,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quy định chi tiết',
                            style: TMLabsTextStyle.caption.copyWith(
                              color: TMLabsColor.grey,
                            ),
                          ),
                          Icon(
                            coupon.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 16,
                            color: TMLabsColor.grey,
                          ),
                        ],
                      ),
                    ),
                    if (coupon.isExpanded) ...[
                      const SizedBox(height: 12),
                      _buildExpandedContent(),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          // Tag Badge at top right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFE8EAF0),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
              ),
              child: Text(
                _getCategoryText(),
                style: TMLabsTextStyle.caption.copyWith(
                  color: TMLabsColor.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getExpiryText() {
    final start = coupon.startDateTime;
    final end = coupon.endDateTime;
    if (start == null || end == null) return "Vĩnh viễn";
    return "${start.toDateTimeStr()} - ${end.toDateTimeStr()}";
  }

  String _getCategoryText() {
    return switch (coupon.productScope) {
      1 => "Toàn sàn",
      2 => "Sản phẩm",
      3 => "Danh mục",
      _ => "Khác",
    };
  }

  Widget _buildLeftSection() {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                coupon.displayValue,
                style: TMLabsTextStyle.h1.copyWith(
                  color: TMLabsColor.error,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                coupon.discountTypeUnit,
                style: TMLabsTextStyle.bodyBold.copyWith(
                  color: TMLabsColor.error,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Hạn mức khả dụng',
            style: TMLabsTextStyle.caption.copyWith(
              color: TMLabsColor.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return coupon.isSelected
        ? const Icon(Icons.check_circle, color: Colors.black, size: 24)
        : Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
            ),
          );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coupon.thresholdText,
          style: TMLabsTextStyle.caption.copyWith(
            color: TMLabsColor.grey,
            fontSize: 12,
          ),
        ),
        if (coupon.description != null && coupon.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildDashedContainer(),
        ],
      ],
    );
  }

  Widget _buildDashedContainer() {
    return CustomPaint(
      painter: DashedRectPainter(color: TMLabsColor.lightGrey),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(
          coupon.description!,
          style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey, fontSize: 13),
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({this.color = Colors.grey, this.strokeWidth = 1.0, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8)));

    final Path dashedPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(metric.extractPath(distance, distance + gap), Offset.zero);
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
