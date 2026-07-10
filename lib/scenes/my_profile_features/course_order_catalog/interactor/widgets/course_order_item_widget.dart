import 'package:db_core/utils/app_countdown_timer.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/course_order_model.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

class CourseOrderItemWidget extends StatelessWidget {
  final CourseOrderModel order;
  final VoidCallback? onPay;
  final VoidCallback? onReview;
  final VoidCallback? onLearn;
  final VoidCallback? onExpired;
  final VoidCallback? onTap;

  const CourseOrderItemWidget({
    super.key,
    required this.order,
    this.onPay,
    this.onReview,
    this.onLearn,
    this.onExpired,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumbnail(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfo()),
                ],
              ),
            ),
            const Divider(height: 24),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return DbCachedImageWidget(
      imageUrl: order.imageUrl,
      width: 100,
      height: 70,
      borderRadius: 8,
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          order.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              order.price.toFormatPrice(),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Thực trả: ",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            Text(
              order.discountPrice.toFormatPrice(),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Row(
      children: [
        _buildStatusTag(),
        const Spacer(),
        ..._buildActions(),
      ],
    );
  }

  Widget _buildStatusTag() {
    String text = "";
    Color color = Colors.grey;
    IconData? icon;

    if (order.status == CourseOrderStatus.pending && order.expiredAt != null) {
      return Row(
        children: [
          AppIcon(AppAssets.icons.icDonHang, size: 20, color: Colors.orange),
          const SizedBox(width: 8),
          AppCountdownTimer(
            expiryDate: order.expiredAt,
            textStyle: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
            onFinished: onExpired,
          ),
        ],
      );
    }

    switch (order.status) {
      case CourseOrderStatus.pending:
        text = "Chờ thanh toán";
        color = Colors.orange;
        icon = Icons.access_time;
        break;
      case CourseOrderStatus.completed:
        text = "Đã hoàn thành";
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case CourseOrderStatus.cancelled:
        text = "Đã hủy";
        color = Colors.grey;
        icon = Icons.remove_circle_outline;
        break;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  List<Widget> _buildActions() {
    if (order.status == CourseOrderStatus.pending) {
      return [
        AppButton(
          text: "Thanh toán ngay",
          onPressed: onPay,
          style: TMLabsButtonStyle.primary,
          height: 32,
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ];
    }

    if (order.status == CourseOrderStatus.completed) {
      return [
        AppButton(
          text: "Đánh giá",
          onPressed: onReview,
          style: TMLabsButtonStyle.outline,
          height: 32,
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        const SizedBox(width: 8),
        AppButton(
          text: "Học ngay",
          onPressed: onLearn,
          style: TMLabsButtonStyle.primary,
          height: 32,
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ];
    }

    return [];
  }
}
