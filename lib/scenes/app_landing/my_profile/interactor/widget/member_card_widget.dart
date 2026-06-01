import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MemberCardStyle {
  final String bgAsset;
  final String rankAsset;
  final String classAsset;
  final Color primaryColor;
  final Color labelColor;

  const MemberCardStyle({
    required this.bgAsset,
    required this.rankAsset,
    required this.classAsset,
    required this.primaryColor,
    required this.labelColor,
  });

  static MemberCardStyle get gold => MemberCardStyle(
        bgAsset: AppAssets.images.imgBgGold,
        rankAsset: AppAssets.images.imgBgGoldRank,
        classAsset: AppAssets.images.imgBgGoldClass,
        primaryColor: TMLabsColor.primary,
        labelColor: TMLabsColor.primary,
      );

  static MemberCardStyle get bronze => MemberCardStyle(
        bgAsset: AppAssets.images.imgBgBronze,
        rankAsset: AppAssets.images.imgBgBronzeRank,
        classAsset: AppAssets.images.imgBgBronzeClass,
        primaryColor: Colors.white,
        labelColor: Colors.white, // Màu đồng đậm
      );

  static MemberCardStyle get silver => MemberCardStyle(
        bgAsset: AppAssets.images.imgBgSilver,
        rankAsset: AppAssets.images.imgBgSilverRank,
        classAsset: AppAssets.images.imgBgSilverClass,
        primaryColor: Colors.white,
        labelColor: const Color(0xFF4A4A4A), // Màu bạc đậm
      );

  static MemberCardStyle get platinum => MemberCardStyle(
        bgAsset: AppAssets.images.imgBgPlatinum,
        rankAsset: AppAssets.images.imgBgPlatinumRank,
        classAsset: AppAssets.images.imgBgPlatinumClass,
        primaryColor: TMLabsColor.primary,
        labelColor: TMLabsColor.primary,
      );

  static MemberCardStyle get emerald => MemberCardStyle(
        bgAsset: AppAssets.images.imgBgEmerald,
        rankAsset: AppAssets.images.imgBgEmeraldRank,
        classAsset: AppAssets.images.imgBgEmeraldClass,
        primaryColor: Colors.white,
        labelColor: const Color(0xFF004D40), // Màu xanh lục bảo đậm
      );

  static MemberCardStyle get diamond => MemberCardStyle(
        bgAsset: AppAssets.images.imgBgDiamond,
        rankAsset: AppAssets.images.imgBgDiamondRank,
        classAsset: AppAssets.images.imgBgDiamondClass,
        primaryColor: Colors.white,
        labelColor: const Color(0xFF0D47A1), // Màu xanh kim cương đậm
      );

  static MemberCardStyle get vip => MemberCardStyle(
        bgAsset: AppAssets.images.imgBgVip,
        rankAsset: AppAssets.images.imgBgVipRank,
        classAsset: AppAssets.images.imgBgVipClass,
        primaryColor: Colors.white,
        labelColor: Colors.red.shade900, // Màu đỏ VIP
      );
}

class MemberCardWidget extends StatelessWidget {
  final MemberCardStyle style;
  final String name;
  final String id;
  final String voucherCount;
  final String points;
  final String? avatarUrl;
  final String rankName;
  final String className;
  final EdgeInsetsGeometry? padding;

  const MemberCardWidget({
    super.key,
    required this.style,
    required this.name,
    required this.id,
    required this.voucherCount,
    required this.points,
    this.avatarUrl,
    required this.rankName,
    required this.className,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // Thay thế height cố định bằng constraints hoặc để tự giãn
        constraints: const BoxConstraints(minHeight: 162), 
        padding: padding ?? EdgeInsets.zero,
        child: Stack(
          children: [
            // Background - dùng Positioned.fill để tự khớp theo size của nội dung
            Positioned.fill(child: SvgPicture.asset(style.bgAsset, fit: BoxFit.fill)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Để column co theo nội dung
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 63,
                        height: 63,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(avatarUrl ?? 'https://i.pravatar.cc/150?u=gigi'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      // User Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: TMLabsTextStyle.title.copyWith(color: style.primaryColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  _buildCardLabel(className, style.classAsset),
                                  const SizedBox(width: 4),
                                  AppIcon(AppAssets.icons.icArrowRight, size: 14, color: style.primaryColor),
                                ],
                              ),
                              Text('ID: $id', style: TMLabsTextStyle.caption.copyWith(fontSize: 10, color: style.primaryColor)),
                            ],
                          ),
                        ),
                      ),
                      // Member Level Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Trung tâm hội viên', style: TMLabsTextStyle.small.copyWith(color: style.primaryColor)),
                          const SizedBox(height: 2),
                          _buildCardLabel(rankName, style.rankAsset),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Voucher & Points
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildInfoItem('Voucher', voucherCount, 'Sử dụng ngay'),
                      const SizedBox(width: 50),
                      _buildInfoItem('Điểm tích lũy', points, null),
                    ],
                  ),
                ],
              ),
            ),
            // My Page button
            Positioned(
              right: 20,
              bottom: 15,
              child: AppLabel(
                'Trang của tôi',
                style: TMLabsTextStyle.small.copyWith(color: style.primaryColor),
                backgroundColor: style.primaryColor.withValues(alpha: 0.2),
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                borderColor: style.primaryColor.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLabel(String text, String bgAsset) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(child: SvgPicture.asset(bgAsset, fit: BoxFit.fill)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            text,
            style: TMLabsTextStyle.small.copyWith(fontSize: 8, fontStyle: FontStyle.italic, color: style.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, String? subText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TMLabsTextStyle.title.copyWith(height: 1.1,color: style.primaryColor)),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TMLabsTextStyle.h1.copyWith(color: style.primaryColor, height: 1.0)),
              if (subText != null) ...[
                const SizedBox(width: 4),
                Text(
                  subText,
                  style: TMLabsTextStyle.small.copyWith(fontSize: 8, fontWeight: FontWeight.normal, height: 1.0,color: style.primaryColor),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
