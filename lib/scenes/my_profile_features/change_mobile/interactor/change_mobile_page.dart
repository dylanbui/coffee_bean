import 'dart:async';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_interactor.dart';
import 'package:coffee_bean/shared/base/tap_to_unfocus_mixin.dart';
import 'package:coffee_bean/shared/base/keyboard_unfocus_mixin.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/code_input_field.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeMobilePage extends CubitStateFulWidget<ChangeMobileInteractor, ChangeMobileState> {
  ChangeMobilePage({super.key, required super.interactor});

  @override
  State<ChangeMobilePage> createState() => _ChangeMobilePageState();
}

class _ChangeMobilePageState extends CubitState<ChangeMobilePage, ChangeMobileInteractor, ChangeMobileState>
    with WidgetsBindingObserver, TapToUnfocusMixin, KeyboardUnfocusMixin {
  
  @override
  bool get tapToUnfocus => true;

  @override
  bool get unfocusOnHide => true;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  
  String _countryCode = "+84";
  bool _isPhoneValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return CoffeeAppBar(
      title: 'Thay đổi số điện thoại',
      style: TmLabAppBarStyle.whiteStyle,
      onBackTap: () => interactor.router?.pop(),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return wrapTapToUnfocus(
      BlocConsumer<ChangeMobileInteractor, ChangeMobileState>(
        listener: (context, state) {
          if (state.error != null) {
            context.showFlashError(state.error!);
          }
          if (state.isUpdateSuccess) {
            context.showFlashSuccess("Cập nhật số điện thoại thành công");
            Future.delayed(const Duration(seconds: 1), () {
              interactor.router?.pop();
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nhập số điện thoại mới",
                  style: TMLabsTextStyle.h2,
                ),
                const SizedBox(height: 8),
                Text(
                  "Vui lòng nhập số điện thoại mới bạn muốn thay đổi. Mã xác thực sẽ được gửi đến số điện thoại này.",
                  style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
                ),
                const SizedBox(height: 32),
                PhoneInputField(
                  controller: _phoneController,
                  enabled: true,
                  countryCodes: const ["+84", "+86", "+65"],
                  initialCountryCode: _countryCode,
                  onChanged: (val) {
                    _countryCode = val.countryCode;
                    _isPhoneValid = val.isValid;
                  },
                ),
                const SizedBox(height: 16),
                CodeInputField(
                  controller: _codeController,
                  onSendCode: () async {
                    if (!_isPhoneValid) {
                      context.showFlashError("Vui lòng nhập số điện thoại mới hợp lệ");
                      return false;
                    }
                    final phone = _getFullPhone();
                    await interactor.sendSmsCode(phone);
                    return interactor.state.error == null;
                  },
                ),
                const SizedBox(height: 40),
                AppButton(
                  text: "Cập Nhật",
                  isLoading: state.isLoading,
                  style: TMLabsButtonStyle.primary,
                  onPressed: _onUpdate,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getFullPhone() {
    String phone = _phoneController.text.trim();
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    return "$_countryCode$phone";
  }

  void _onUpdate() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      context.showFlashError("Vui lòng nhập mã xác thực");
      return;
    }

    if (!_isPhoneValid) {
      context.showFlashError("Vui lòng nhập số điện thoại mới hợp lệ");
      return;
    }
    
    interactor.updateMobile(_getFullPhone(), code);
  }
}
