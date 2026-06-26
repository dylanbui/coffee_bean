import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/interactor/settings_app_event_state.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/interactor/settings_app_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsAppPage extends AppCubitStateFulWidget<SettingsAppInteractor, SettingsAppState> {
  SettingsAppPage({super.key, required super.interactor});

  @override
  State<SettingsAppPage> createState() => _SettingsAppPageState();
}

class _SettingsAppPageState extends AppCubitState<SettingsAppPage, SettingsAppInteractor, SettingsAppState> {
  @override
  String? getTitle() => "Cài đặt";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return wrapTapToUnfocus(
      Scaffold(
        backgroundColor: TMLabsColor.bgMain,
        appBar: appBar,
        body: body,
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<SettingsAppInteractor, SettingsAppState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    DbSelectionRow(
                      title: "Cài đặt ngôn ngữ & giá tiền",
                      value: SettingsAppManager().getLocaleName(),
                      titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w500),
                      valueStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
                      trailing: const Icon(Icons.chevron_right, color: TMLabsColor.lightGrey, size: 20),
                      onTap: () => interactor.routeToLanguageSetting(),
                    ),
                    const SizedBox(height: 12),
                    DbSelectionRow(
                      title: "Điều khoản người dùng",
                      titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w500),
                      trailing: const Icon(Icons.chevron_right, color: TMLabsColor.lightGrey, size: 20),
                      onTap: () => interactor.routeToUserAgreement(),
                    ),
                    const SizedBox(height: 12),
                    DbSelectionRow(
                      title: "Chính sách bảo mật",
                      titleStyle: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w500),
                      trailing: const Icon(Icons.chevron_right, color: TMLabsColor.lightGrey, size: 20),
                      onTap: () => interactor.routeToPrivacyPolicy(),
                    ),
                  ],
                ),
              ),
            ),
            if (UserManager().isLogin) _buildLogoutButton(context),
          ],
        );
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 50),
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
            showLoading();
            Utils.delay(second: 2);
            interactor.doLogout(onSuccess: () {
              hideLoading();
            });
          }
        },
      ),
    );
  }
}
