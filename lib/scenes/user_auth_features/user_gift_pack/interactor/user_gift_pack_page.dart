/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 23:22
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_auth_features/user_gift_pack/interactor/user_gift_pack_event_state.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_gift_pack/interactor/user_gift_pack_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/i18n/locale_keys.g.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class UserGiftPackPage extends AppCubitStateFulWidget<UserGiftPackInteractor, UserGiftPackState> {
  UserGiftPackPage({super.key, required super.interactor});

  @override
  State<UserGiftPackPage> createState() => _UserGiftPackPageState();
}

class _UserGiftPackPageState extends AppCubitState<UserGiftPackPage, UserGiftPackInteractor, UserGiftPackState> {

  @override
  String? getTitle() => LocaleKeys.user_auth_features_user_gift_pack_title.tr();

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => const CoffeeAppBarStyleConfig(
    backIcon: Icons.close,
    foregroundColor: Colors.black,
  );

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<UserGiftPackInteractor, UserGiftPackState>(
      listener: _onStateListener,
      builder: (context, state) => _buildMainContent(context, state),
    );
  }

  // region UI Builders

  void _onStateListener(BuildContext context, UserGiftPackState state) {
    if (state is UserGiftPackInProgress) {
      showLoading();
    } else {
      hideLoading();
      if (state is UserGiftPackSuccess) {
        // Xử lý thành công
      } else if (state is UserGiftPackError) {
        _showError(state.message);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildMainContent(BuildContext context, UserGiftPackState state) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF2EFED), // Màu nền giống trong hình
        // Nếu có hình nền, bạn có thể dùng:
        // image: DecorationImage(image: AssetImage("assets/images/gift_pack_bg.png"), fit: BoxFit.cover),
      ),
      child: SafeArea(
        top: false, // Để background tràn lên status bar
        child: Column(
          children: [
            const Spacer(flex: 3),
            _buildCenterContent(),
            const Spacer(flex: 4),
            _buildBottomButtons(state),
            const SizedBox(height: 20), // Cách cạnh dưới 20px
          ],
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Graphic hình tròn ở giữa
        Container(
          width: 160,
          height: 160,
          decoration: const BoxDecoration(
            color: Color(0xFFF9D9CD),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          LocaleKeys.user_auth_features_user_gift_pack_congratulations.tr(),
          style: TMLabsTextStyle.title,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            LocaleKeys.user_auth_features_user_gift_pack_gift_pack_hint.tr(),
            style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(UserGiftPackState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          AppButton(
            text: LocaleKeys.user_auth_features_user_gift_pack_btn_view_gift_pack.tr(),
            isLoading: state is UserGiftPackInProgress,
            onPressed: () => _handleButtonClick(LocaleKeys.user_auth_features_user_gift_pack_btn_view_gift_pack.tr()),
          ),
          const SizedBox(height: 10), // Cách nhau 10px
          AppButton(
            text: LocaleKeys.user_auth_features_user_gift_pack_btn_back.tr(),
            style: TMLabsButtonStyle.outline,
            onPressed: () => _handleButtonClick(LocaleKeys.user_auth_features_user_gift_pack_btn_back.tr()),
          ),
        ],
      ),
    );
  }

  // endregion

  // region Logic Handlers

  void _handleButtonClick(String buttonName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.user_auth_features_user_gift_pack_msg_clicked.tr(namedArgs: {'name': buttonName})),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // endregion
}
