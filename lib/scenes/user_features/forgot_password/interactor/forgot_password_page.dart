/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';

import 'package:coffee_bean/scenes/user_features/forgot_password/interactor/forgot_password_event_state.dart';
import 'package:coffee_bean/scenes/user_features/forgot_password/interactor/forgot_password_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/underline_input_field.dart';
import 'package:db_core/utils/app_button.dart';

//ignore: must_be_immutable
class ForgotPasswordPage extends CubitStateFulWidget<ForgotPasswordInteractor, ForgotPasswordState> {
  ForgotPasswordPage({super.key, required super.interactor});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends CubitState<ForgotPasswordPage, ForgotPasswordInteractor, ForgotPasswordState> {
  late ForgotPasswordController _forgotPwController;

  // Logic Countdown for SMS
  int _start = 60;
  bool _isCountingDown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _forgotPwController = ForgotPasswordController();
    
    // Nhập số điện thoại mặc định
    _forgotPwController.phoneController.text = "0901234567";
  }

  @override
  void dispose() {
    _forgotPwController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) => coffeeAppBar("Forgot Password");

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    var appBar = getAppBar(context);

    if (widget.showAppBar == false) {
      appBar = null;
    }

    return BlocProvider.value(
      value: interactor,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar as PreferredSizeWidget?,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: getBody(context),
        ),
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
    if (state is ForgotPasswordInProgress) {
      // showLoading(); // Use button loading
    } else if (state is ForgotPasswordSendCodeDone) {
      hideLoading();
    } else {
      hideLoading();
      if (state is ForgotPasswordSuccess) {
        // Handle success
      } else if (state is ForgotPasswordError) {
        _showError(state.message);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
                  text: "Reset Password",
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Text(
        "To ensure account security, please verify your identity first.",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        PhoneInputField(
          controller: _forgotPwController.phoneController,
          countryCodes: const ["+86", "+84", "+1"],
          initialCountryCode: _forgotPwController.countryCode,
          onChanged: (val) => _forgotPwController.countryCode = val.countryCode,
        ),
        const SizedBox(height: 20),
        UnderlineInputField(
          controller: _forgotPwController.smsController,
          hint: "Verification Code",
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
        _isCountingDown ? "Resend (${_start}s)" : "Send Code",
        style: TextStyle(
          fontFamily: 'Source Sans Pro',
          color: _isCountingDown ? Colors.grey : TMLabsColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // endregion

  // region Logic Handlers

  void _handleSendSms() {
    if (_forgotPwController.phoneController.text.isEmpty) {
      _showError("Please enter phone number");
      return;
    }
    _startCountdown();
    interactor.sendSmsCode("${_forgotPwController.countryCode}${_forgotPwController.phoneController.text}");
  }

  void _startCountdown() {
    if (_isCountingDown) return;
    setState(() {
      _isCountingDown = true;
      _start = 60;
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

  String countryCode = "+86";

  void validateAndSubmit(ForgotPasswordInteractor interactor, Function(String) onError) {
    if (phoneController.text.isEmpty) {
      onError("Please enter phone number");
      return;
    }
    if (smsController.text.isEmpty) {
      onError("Please enter verification code");
      return;
    }
    interactor.forgotPassword("$countryCode${phoneController.text}", smsController.text);
  }

  void dispose() {
    phoneController.dispose();
    smsController.dispose();
  }
}
