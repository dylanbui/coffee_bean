import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';

class PointStoreHeader extends StatelessWidget {
  final double points;
  final VoidCallback onDetailTap;
  final VoidCallback onMoreTap;

  const PointStoreHeader({
    super.key,
    required this.points,
    required this.onDetailTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: const BoxDecoration(
        color: TMLabsColor.white,
      ),
      child: Column(
        children: [
          // Points Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon(AppAssets.icons.icGoldCoin, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _formatPoints(points),
                          style: TMLabsTextStyle.h2.copyWith(fontSize: 24),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Điểm",
                          style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28), // 20 (icon) + 8 (gap)
                      child: Text(
                        "268 điểm sẽ hết hạn vào ngày 31/12/2026",
                        style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey.withValues(alpha: 0.5)),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: onDetailTap,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: TMLabsColor.lightGrey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Chi tiết", style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey, fontSize: 10)),
                    const Icon(Icons.chevron_right, size: 16, color: TMLabsColor.grey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Reward Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TMLabsColor.bgLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TMLabsColor.lightGrey.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nhận thêm điểm thưởng",
                        style: TMLabsTextStyle.title.copyWith(fontSize: 16),
                      ),
                      Text(
                        "Hoàn thành nhiệm vụ để nhận thêm điểm thưởng",
                        style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey.withValues(alpha: 0.5)),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: "Xem thêm",
                  onPressed: onMoreTap,
                  style: TMLabsButtonStyle.primary.copyWith(
                    borderRadius: 20,
                    textStyle: TMLabsTextStyle.small.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  height: 32,
                  width: 100,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPoints(double pts) {
    return pts.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
