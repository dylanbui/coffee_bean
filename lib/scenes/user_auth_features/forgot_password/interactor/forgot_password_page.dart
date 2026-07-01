/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';

import 'package:coffee_bean/scenes/user_auth_features/forgot_password/interactor/forgot_password_event_state.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/interactor/forgot_password_interactor.dart';
import 'package:coffee_bean/shared/i18n/locale_keys.g.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/underline_input_field.dart';
import 'package:db_core/utils/app_button.dart';

//ignore: must_be_immutable
class ForgotPasswordPage extends AppCubitStateFulWidget<ForgotPasswordInteractor, ForgotPasswordState> {
  ForgotPasswordPage({super.key, required super.interactor});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends AppCubitState<ForgotPasswordPage, ForgotPasswordInteractor, ForgotPasswordState> {
  late ForgotPasswordController _forgotPwController;

  // Logic Countdown for SMS
  int _start = 90;
  bool _isCountingDown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _forgotPwController = ForgotPasswordController();
    
    // Nhập số điện thoại mặc định
    _forgotPwController.phoneController.text = "0988123457";
  }

  @override
  void dispose() {
    _forgotPwController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  String? getTitle() => LocaleKeys.user_auth_features_forgot_password_title.tr();

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: body,
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<ForgotPasswordInteractor, ForgotPasswordState>(
      listener: _onStateListener,
      builder: (context, state) => _buildMainContent(context, state),
    );
  }

  // region UI Builders

  void _onStateListener(BuildContext context, ForgotPasswordState state) {
    if (state is ForgotPasswordError) {
      _showError(state.message);
    }
  }

  void _showError(String message) {
    context.showFlashError(message, title: LocaleKeys.general_label_error.tr());
  }

  Widget _buildMainContent(BuildContext context, ForgotPasswordState state) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionText(),
                _buildInputs(),
                const SizedBox(height: 50),
                AppButton(
                  text: LocaleKeys.user_auth_features_forgot_password_btn_reset_password.tr(),
                  style: TMLabsButtonStyle.primary,
                  isLoading: state is ForgotPasswordInProgress,
                  onPressed: () => _forgotPwController.validateAndSubmit(
                    interactor,
                    _showError,
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Text(
        LocaleKeys.user_auth_features_forgot_password_instruction.tr(),
        style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
      ),
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        PhoneInputField(
          controller: _forgotPwController.phoneController,
          countryCodes: const ["+86", "+84", "+196"],
          initialCountryCode: _forgotPwController.countryCode,
          onChanged: (val) {
            _forgotPwController.countryCode = val.countryCode;
            _forgotPwController.isPhoneValid = val.isValid;
          },
        ),
        const SizedBox(height: 20),
        UnderlineInputField(
          controller: _forgotPwController.smsController,
          hint: LocaleKeys.user_auth_features_user_register_verification_code_hint.tr(),
          suffix: _buildCountdownButton(),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildCountdownButton() {
    return InkWell(
      onTap: _isCountingDown ? null : _handleSendSms,
      child: Text(
        _isCountingDown
            ? LocaleKeys.user_auth_features_user_login_resend_btn.tr(namedArgs: {'start': '$_start'})
            : LocaleKeys.user_auth_features_user_login_send_code_btn.tr(),
        style: TMLabsTextStyle.bodyBold.copyWith(
          color: _isCountingDown ? TMLabsColor.lightGrey : TMLabsColor.primary,
        ),
      ),
    );
  }

  // endregion

  // region Logic Handlers

  void _handleSendSms() {
    if (!_forgotPwController.isPhoneValid) {
      _showError(LocaleKeys.user_auth_features_user_login_msg_phone_invalid.tr());
      return;
    }
    _startCountdown();
    interactor.sendSmsCode(_forgotPwController.formattedPhoneNumber);
  }

  void _startCountdown() {
    if (_isCountingDown) return;
    setState(() {
      _isCountingDown = true;
      _start = 90;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        if (mounted) setState(() => _isCountingDown = false);
        _timer?.cancel();
      } else {
        if (mounted) setState(() => _start--);
      }
    });
  }

  // endregion
}

class ForgotPasswordController {
  final phoneController = TextEditingController();
  final smsController = TextEditingController();

  String countryCode = "+84";
  bool isPhoneValid = false;

  String get formattedPhoneNumber => "$countryCode${phoneController.text}";

  void validateAndSubmit(ForgotPasswordInteractor interactor, Function(String) onError) {
    if (!isPhoneValid) {
      onError(LocaleKeys.user_auth_features_user_login_msg_phone_invalid.tr());
      return;
    }
    if (smsController.text.isEmpty) {
      onError(LocaleKeys.user_auth_features_user_login_msg_enter_sms_code.tr());
      return;
    }
    interactor.forgotPassword(formattedPhoneNumber, smsController.text);
  }

  void dispose() {
    phoneController.dispose();
    smsController.dispose();
  }
}
