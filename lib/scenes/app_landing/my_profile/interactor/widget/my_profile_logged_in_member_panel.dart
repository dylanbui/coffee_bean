import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfileLoggedInMemberPanel extends StatelessWidget {
  final MyProfileInteractor interactor;

  const MyProfileLoggedInMemberPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TMLabsColor.bgMain,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildMemberCard(context),
            const SizedBox(height: 16),
            _buildActionBarButtons(),
            const SizedBox(height: 16),
            _buildActionsList(),
            const SizedBox(height: 16),
            _buildStoreServiceRow(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Center(
      child: Container(
        width: 373,
        height: 162 + topPadding,
        padding: EdgeInsets.only(top: topPadding + 24),
        child: Stack(
          children: [
            // Background Gold
            Positioned.fill(child: SvgPicture.asset(AppAssets.images.imgBgGold, fit: BoxFit.fill)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
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
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/150?u=gigi'), // Placeholder
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
                                  Text('GIGI', style: TMLabsTextStyle.title),
                                  const SizedBox(width: 4),
                                  _buildCardLabel('Class A', AppAssets.images.imgBgGoldClass),
                                  const SizedBox(width: 4),
                                  AppIcon(AppAssets.icons.icArrowRight, size: 14, color: TMLabsColor.primary),
                                ],
                              ),
                              Text('ID: 123456789', style: TMLabsTextStyle.caption.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                      // Member Level Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Trung tâm hội viên', style: TMLabsTextStyle.small),
                          const SizedBox(height: 2),
                          _buildCardLabel('Hạng Vàng', AppAssets.images.imgBgGoldRank),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Voucher & Points
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildInfoItem('Voucher', '5', 'Sử dụng ngay'),
                      SizedBox(width: 50),
                      _buildInfoItem('Điểm tích lũy', '1998', null),
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
                style: TMLabsTextStyle.small,
                backgroundColor: TMLabsColor.primary.withValues(alpha: 0.2),
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                borderColor: TMLabsColor.primary.withValues(alpha: 0.2),
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
            style: TMLabsTextStyle.small.copyWith(fontSize: 8, fontStyle: FontStyle.italic, color: TMLabsColor.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, String? subText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TMLabsTextStyle.title.copyWith(height: 1.1)),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TMLabsTextStyle.h1.copyWith(color: TMLabsColor.primary, height: 1.1)),
              if (subText != null) ...[
                const SizedBox(width: 4),
                Text(
                  subText,
                  style: TMLabsTextStyle.small.copyWith(fontSize: 8, fontWeight: FontWeight.normal, height: 1.1),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBarButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(AppAssets.icons.icDonHang, 'Đơn hàng'),
          _buildActionButton(AppAssets.icons.icLichDatHen, 'Lịch đặt hẹn'),
          _buildActionButton(AppAssets.icons.icDonKhoaHoc, 'Đơn khóa học'),
          _buildActionButton(AppAssets.icons.icMyEvent, 'Sự kiện của tôi'),
        ],
      ),
    );
  }

  Widget _buildActionButton(String icon, String label) {
    return TapEffect(
      onTap: () {}, // Cho phép hiệu ứng bấm
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: TMLabsColor.bgLight, shape: BoxShape.circle),
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(TMLabsColor.secondary, BlendMode.srcIn),
            ),
          ),
          Text(label, style: TMLabsTextStyle.small.copyWith(fontSize: 10, color: TMLabsColor.primary)),
        ],
      ),
    );
  }

  Widget _buildActionsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _buildActionRow(AppAssets.icons.icKhoaHocNone, 'Khóa học'),
            _buildActionRow(AppAssets.icons.icSaved, 'Đã lưu'),
            _buildActionRow(AppAssets.icons.icInviteFriend, 'Mời bạn bè'),
            _buildActionRow(AppAssets.icons.icCustomerSupport, 'CSKH'),
            _buildActionRow(AppAssets.icons.icFeedback, 'Đóng góp ý kiến'),
            _buildActionRow(AppAssets.icons.icSystem, 'Cài đặt'),
          ],
        ),
      ),
    );
  }

  // Widget _buildDivider() {
  //   return const Padding(
  //     padding: EdgeInsets.only(left: 48),
  //     child: Divider(height: 1, thickness: 0.5, color: TMLabsColor.bgLight),
  //   );
  // }

  Widget _buildStoreServiceRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: _buildActionRow(
          AppAssets.icons.icStoreService,
          'Dịch vụ tại cửa hàng',
          height: 56,
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }

  Widget _buildActionRow(String icon, String title, {double height = 48, BorderRadius? borderRadius}) {
    return InkWell(
      onTap: () {}, // Thêm hiệu ứng loang khi tap
      borderRadius: borderRadius,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(TMLabsColor.secondary, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.w500),
              ),
            ),
            AppIcon(AppAssets.icons.icArrowRightNone, size: 20, color: TMLabsColor.deepNavy.withValues(alpha: 0.8)),
          ],
        ),
      ),
    );
  }
}
