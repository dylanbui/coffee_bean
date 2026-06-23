import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/member_card_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/shared/service/notify_app_upgrade/app_upgrade_service.dart';
import 'package:flutter/material.dart';
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

                      DbSelectionRow(
                        leading: SizedBox(
                          width: 24,
                          child: Center(
                            child: AppIcon(AppAssets.icons.icStoreService, size: 20, color: TMLabsColor.secondary),
                          ),
                        ),
                        title: 'Dịch vụ tại cửa hàng',
                        titleStyle: TMLabsTextStyle.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TMLabsColor.primary,
                        ),
                        trailing: SizedBox(
                          width: 14,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AppIcon(AppAssets.icons.icArrowRightNone, size: 14, color: TMLabsColor.deepNavy.withValues(alpha: 0.8)),
                          ),
                        ),
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
          SizedBox(height: 5,),
          Text(label, style: TMLabsTextStyle.small.copyWith(fontSize: 10, color: TMLabsColor.primary)),
        ],
      ),
    );
  }

  Widget _buildActionsList() {
    return DbSelectionTable(
      children: [
        _buildDbSelectionRow("COURSES", AppAssets.icons.icKhoaHocNone, 'Khóa học'),
        _buildDbSelectionRow("SAVED", AppAssets.icons.icSaved, 'Đã lưu'),
        _buildDbSelectionRow("INVITE_FRIENDS", AppAssets.icons.icInviteFriend, 'Mời bạn bè'),
        _buildDbSelectionRow("SUPPORT", AppAssets.icons.icCustomerSupport, 'CSKH'),
        _buildDbSelectionRow("FEEDBACK", AppAssets.icons.icFeedback, 'Đóng góp ý kiến'),
        _buildDbSelectionRow("SETTINGS", AppAssets.icons.icSystem, 'Cài đặt'),
      ],
    );
  }

  Widget _buildUserProfileActionsList() {
    return DbSelectionTable(
      children: [
        _buildDbSelectionRow("CHANGE_MOBILE", AppAssets.icons.icSystem, 'Thay đổi số điện thoại'),
        // _buildDbSelectionRow("CHANGE_MOBILE", AppAssets.icons.icSaved, 'Đã lưu'),
      ],
    );
  }

  Widget _buildDbSelectionRow(String actionKey, String icon, String title) {
    return DbSelectionRow(
      title: title,
      titleStyle: TMLabsTextStyle.body.copyWith(
        fontWeight: FontWeight.w500,
        color: TMLabsColor.primary,
      ),
      leading: SizedBox(
        width: 24,
        child: Center(
          child: AppIcon(icon, size: 20, color: TMLabsColor.secondary),
        ),
      ),
      trailing: SizedBox(
        width: 14,
        child: Align(
          alignment: Alignment.centerRight,
          child: AppIcon(AppAssets.icons.icArrowRightNone, size: 14, color: TMLabsColor.deepNavy.withValues(alpha: 0.8)),
        ),
      ),
      onTap: () => interactor.doMainAction(actionKey),
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      showShadow: false,
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
