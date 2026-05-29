import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfileLoggedOutMemberPanel extends StatelessWidget {
  final MyProfileInteractor interactor;

  const MyProfileLoggedOutMemberPanel({super.key, required this.interactor});

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
    return Container(
      width: double.infinity,
      height: 165 + topPadding,
      padding: EdgeInsets.only(top: topPadding + 10),
      child: Stack(
        children: [
          // Background Gold (using a desaturated or generic one if possible, but keeping consistency)
          Positioned.fill(
            child: SvgPicture.asset(
              AppAssets.images.imgBgGold,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Placeholder
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.white24,
                      ),
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    // Guest Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xin chào!',
                            style: TMLabsTextStyle.h2.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          TapEffect(
                            onTap: () => interactor.router?.doLoginFlow(interactor),
                            child: Text(
                              'Đăng nhập để nhận ưu đãi >',
                              style: TMLabsTextStyle.caption.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Placeholder Voucher & Points
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildInfoItem('Voucher', '0', null),
                    const Spacer(),
                    _buildInfoItem('Điểm tích lũy', '0', null),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, String? subText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TMLabsTextStyle.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TMLabsTextStyle.h1.copyWith(fontSize: 26, color: TMLabsColor.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBarButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
      onTap: () => interactor.router?.doLoginFlow(interactor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: TMLabsColor.bgLight,
              shape: BoxShape.circle,
            ),
            child: AppIcon(icon, size: 24, color: TMLabsColor.secondary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TMLabsTextStyle.small.copyWith(fontSize: 11, color: TMLabsColor.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionRow(AppAssets.icons.icKhoaHocNone, 'Khóa học'),
          _buildDivider(),
          _buildActionRow(AppAssets.icons.icSaved, 'Đã lưu'),
          _buildDivider(),
          _buildActionRow(AppAssets.icons.icInviteFriend, 'Mời bạn bè'),
          _buildDivider(),
          _buildActionRow(AppAssets.icons.icCustomerSupport, 'CSKH'),
          _buildDivider(),
          _buildActionRow(AppAssets.icons.icFeedback, 'Đóng góp ý kiến'),
          _buildDivider(),
          _buildActionRow(AppAssets.icons.icSystem, 'Cài đặt'),
        ],
      ),
    );
  }

  Widget _buildStoreServiceRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildActionRow(AppAssets.icons.icStoreService, 'Dịch vụ tại cửa hàng'),
    );
  }

  Widget _buildActionRow(String icon, String title) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => interactor.router?.doLoginFlow(interactor),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              AppIcon(icon, size: 20, color: TMLabsColor.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TMLabsTextStyle.body.copyWith(
                    color: TMLabsColor.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 20, color: TMLabsColor.lightGrey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 48),
      child: Divider(height: 1, thickness: 0.5, color: TMLabsColor.bgLight),
    );
  }
}
