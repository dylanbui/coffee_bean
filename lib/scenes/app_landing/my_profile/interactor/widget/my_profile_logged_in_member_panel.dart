import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/member_card_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfileLoggedInMemberPanel extends StatelessWidget {
  final MyProfileInteractor interactor;

  const MyProfileLoggedInMemberPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final user = interactor.state.user;
    
    return Container(
      color: TMLabsColor.bgMain,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: topPadding),
            MemberCardWidget(
              style: MemberCardStyle.diamond,
              name: user?.fullName ?? user?.userName ?? 'MEMBER',
              id: user?.id.toString() ?? '---',
              voucherCount: '5', // Mock data, should be from user or separate service
              points: '1998',    // Mock data
              rankName: 'Hạng Lục Bảo', // Mock data
              className: 'Class A',    // Mock data
              avatarUrl: user?.avatarUrl,
              padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
            ),
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
