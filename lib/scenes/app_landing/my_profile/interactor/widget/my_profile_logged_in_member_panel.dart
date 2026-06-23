import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/member_card_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/app_selection_row.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/shared/service/notify_app_upgrade/app_upgrade_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyProfileLoggedInMemberPanel extends StatelessWidget {
  final MyProfileInteractor interactor;

  const MyProfileLoggedInMemberPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final userInfo = interactor.state.userInfo;
    
    return Container(
      color: TMLabsColor.bgMain,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: topPadding),
                      MemberCardWidget(
                        style: MemberCardStyle.fromRank(userInfo?.memberRank ?? MemberRank.bronze),
                        name: userInfo?.nickname ?? 'MEMBER',
                        id: userInfo?.id.toString() ?? '---',
                        voucherCount: '0', // TODO: Cần API voucher
                        points: userInfo?.point.toString() ?? '0',
                        rankName: userInfo?.level?.name ?? '---',
                        className: '---', // TODO: Cần API class
                        avatarUrl: userInfo?.avatar,
                        padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
                      ),
                      const SizedBox(height: 16),
                      _buildActionBarButtons(),
                      const SizedBox(height: 16),
                      _buildActionsList(),
                      const SizedBox(height: 16),
                      _buildUserProfileActionsList(),
                      const SizedBox(height: 16),
                      AppSelectionRow(
                        leadingIcon: AppAssets.icons.icStoreService,
                        title: 'Dịch vụ tại cửa hàng',
                        trailingIcon: AppAssets.icons.icArrowRightNone,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        onTap: () {
                          interactor.doMainAction("STORE_SERVICE");
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildLogoutButton(context),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:50, bottom: 10),
                    child: _buildVersionInfo(),
                  ),
                ],
              ),
            ),
          );
        },
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
          _buildActionButton("ORDERS", AppAssets.icons.icDonHang, 'Đơn hàng'),
          _buildActionButton("APPOINTMENTS", AppAssets.icons.icLichDatHen, 'Lịch đặt hẹn'),
          _buildActionButton("COURSES", AppAssets.icons.icDonKhoaHoc, 'Đơn khóa học'),
          _buildActionButton("MY_EVENTS", AppAssets.icons.icMyEvent, 'Sự kiện của tôi'),
        ],
      ),
    );
  }

  Widget _buildActionButton(String key, String icon, String label) {
    return TapEffect(
      onTap: () {
        interactor.doMainAction(key);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: TMLabsColor.bgLight, shape: BoxShape.circle),
            child: AppIcon(
              icon,
              size: 20,
              color: TMLabsColor.secondary,
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
            _buildActionRow("COURSES", AppAssets.icons.icKhoaHocNone, 'Khóa học'),
            _buildActionRow("SAVED", AppAssets.icons.icSaved, 'Đã lưu'),
            _buildActionRow("INVITE_FRIENDS", AppAssets.icons.icInviteFriend, 'Mời bạn bè'),
            _buildActionRow("SUPPORT", AppAssets.icons.icCustomerSupport, 'CSKH'),
            _buildActionRow("FEEDBACK", AppAssets.icons.icFeedback, 'Đóng góp ý kiến'),
            _buildActionRow("SETTINGS", AppAssets.icons.icSystem, 'Cài đặt'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileActionsList() {
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
            _buildActionRow("CHANGE_MOBILE", AppAssets.icons.icSystem, 'Thay đổi số điện thoại'),
            // _buildActionRow("CHANGE_MOBILE", AppAssets.icons.icSaved, 'Đã lưu'),
          ],
        ),
      ),
    );
  }


  Widget _buildActionRow(String actionKey, String icon, String title, {double height = 48, BorderRadius? borderRadius}) {
    return InkWell(
      onTap: () {
        interactor.doMainAction(actionKey);
      },
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
                child: AppIcon(
                  icon,
                  size: 20,
                  color: TMLabsColor.secondary,
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
            const SizedBox(width: 8),
            SizedBox(
              width: 14,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppIcon(
                  AppAssets.icons.icArrowRightNone,
                  size: 18,
                  color: TMLabsColor.deepNavy.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppButton(
        text: 'Đăng xuất',
        style: TMLabsButtonStyle.outline,
        onPressed: () async {
          final res = await FlashDialogHelper.show<bool>(
            context: context,
            title: 'Xác nhận',
            content: 'Bạn có chắc chắn muốn đăng xuất?',
            actions: [
              FlashDialogAction(label: 'Hủy', value: false, color: TMLabsColor.grey),
              FlashDialogAction(label: 'Đăng xuất', value: true, color: TMLabsColor.error),
            ],
          );
          if (res == true) {
            interactor.doLogout();
          }
        },
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Nút check update gọi thẳng Firebase Remote Config qua EventBus
        GestureDetector(
          onTap: () {
            locator<DbEventBus>().fire(CheckAppUpgradeRequestEvent());
          },
          child: Text(
            "Kiểm tra cập nhật",
            style: TMLabsTextStyle.caption.copyWith(
              color: TMLabsColor.secondary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final version = snapshot.data?.version ?? "1.0.0";
            return Text(
              "Phiên bản $version",
              style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
            );
          },
        ),
      ],
    );
  }
}
