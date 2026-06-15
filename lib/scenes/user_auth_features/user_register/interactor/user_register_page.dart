/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';
import 'package:db_core/utils/logger.dart';
import 'package:db_core/utils/keyboard_visibility.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_event_state.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar_ext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/underline_input_field.dart';
import 'package:db_core/utils/app_button.dart';

//ignore: must_be_immutable
class UserRegisterPage extends AppCubitStateFulWidget<UserRegisterInteractor, UserRegisterState> {
  UserRegisterPage({super.key, required super.interactor});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends AppCubitState<UserRegisterPage, UserRegisterInteractor, UserRegisterState> {

  late RegisterController _registerController;
  bool _isKeyboardVisible = false;

  // Logic Countdown cho SMS
  int _start = 60;
  bool _isCountingDown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _registerController = RegisterController();
    // Set default values for testing
    _registerController.phoneController.text = "0988123456";
    _registerController.smsController.text = "9999";
    _registerController.countryCode = "+84";
    _registerController.isAgreed = true;
  }

  @override
  void dispose() {
    _registerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  String? getTitle() => "Register";

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: TMLabsColor.white,
      appBar: appBar,
      resizeToAvoidBottomInset: true, // Để Scaffold tự động xử lý khoảng trống bàn phím
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DbKeyboardVisibility(
          onChanged: (info) {
            if (mounted && _isKeyboardVisible != info.isVisible) {
              setState(() => _isKeyboardVisible = info.isVisible);
            }
          },
          child: body,
        ),
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<UserRegisterInteractor, UserRegisterState>(
      listener: _onRegisterStateChanged,
      builder: (context, state) {
        return Column(
          children: [
            // Phần nội dung cuộn được (Sliver)
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildLogo()),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverToBoxAdapter(child: _buildInputs()),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverToBoxAdapter(child: _buildFooterLinks()),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  // Register button placed below the "Already have an account..." link
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverToBoxAdapter(
                      child: AppButton(
                        text: "Register",
                        style: TMLabsButtonStyle.primary,
                        isLoading: state is UserRegisterInProgress,
                        onPressed: () {
                          _registerController.validateRegister(interactor, _showError);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Sticky Footer: Only contains the Policy Agreement
            _buildStickyFooter(state),
          ],
        );
      },
    );
  }

  Widget _buildStickyFooter(UserRegisterState state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: _buildPolicyAgreement(),
    );
  }

  // region Private functions

  void _onRegisterStateChanged(BuildContext context, UserRegisterState state) {
    if (state is UserRegisterSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register Success!"), backgroundColor: Colors.green),
      );
    } else if (state is UserRegisterError) {
      _showError(state.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: EdgeInsets.only(
        top: _isKeyboardVisible ? 30.0 : 60.0,
        bottom: _isKeyboardVisible ? 20.0 : 60.0,
      ),
      child: Center(
        child: Text(
          "TMLabs Coffee",
          style: _isKeyboardVisible ? TMLabsTextStyle.h2 : TMLabsTextStyle.h1,
        ),
      ),
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        PhoneInputField(
          controller: _registerController.phoneController,
          countryCodes: const ["+86", "+84", "+156"],
          initialCountryCode: _registerController.countryCode,
          onChanged: (val) => _registerController.countryCode = val.countryCode,
        ),
        const SizedBox(height: 20),
        UnderlineInputField(
          controller: _registerController.smsController, 
          hint: "Verification Code", 
          suffix: _buildCountdownButton(),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        UnderlineInputField(
          controller: _registerController.invitationController, 
          hint: "Invitation Code (Optional)",
        ),
      ],
    );
  }

  Widget _buildCountdownButton() {
    return InkWell(
      onTap: _isCountingDown ? null : () {
        final phoneError = _registerController.validatePhoneNumber();
        if (phoneError != null) {
          _showError(phoneError);
          return;
        }
        _startCountdown();
        interactor.sendSmsCode(_registerController.formattedPhoneNumber);
      },
      child: Text(
        _isCountingDown ? "Resend (${_start}s)" : "Send Code",
        style: TMLabsTextStyle.bodyBold.copyWith(
          color: _isCountingDown ? TMLabsColor.lightGrey : TMLabsColor.primary,
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ", style: TMLabsTextStyle.body),
        InkWell(
          onTap: () {
            iLog("Tap: Go to Login");
          },
          child: Text(
            "Go to Login",
            style: TMLabsTextStyle.bodyBold,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyAgreement() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() => _registerController.isAgreed = !_registerController.isAgreed),
          child: Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _registerController.isAgreed ? TMLabsColor.primary : TMLabsColor.lightGrey, width: 1.5),
              color: _registerController.isAgreed ? TMLabsColor.primary : Colors.transparent,
            ),
            child: _registerController.isAgreed ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TMLabsTextStyle.caption.copyWith(height: 1.5),
              children: [
                const TextSpan(text: "I have read and agree to the "),
                TextSpan(
                  text: "User Agreement",
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    interactor.router?.navigate(UserAgreementRoute());
                  },
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    interactor.router?.navigate(PrivacyPolicyRoute());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

class RegisterController {
  final phoneController = TextEditingController();
  final smsController = TextEditingController();
  final invitationController = TextEditingController();

  String countryCode = "+84";
  bool isAgreed = false;

  String get formattedPhoneNumber {
    String phone = phoneController.text.trim();
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    return "$countryCode$phone";
  }

  String? validatePhoneNumber() {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return "Please enter phone number";
    }
    String checkPhone = phone.startsWith('0') ? phone.substring(1) : phone;
    if (checkPhone.length <= 8) {
      return "Phone number must be more than 8 digits";
    }
    return null;
  }

  void validateRegister(UserRegisterInteractor interactor, Function(String) onError) {
    if (!isAgreed) {
      onError("Please agree to the User Agreement and Privacy Policy");
      return;
    }

    final phoneError = validatePhoneNumber();
    if (phoneError != null) {
      onError(phoneError);
      return;
    }

    if (smsController.text.isEmpty) {
      onError("Please enter verification code");
      return;
    }
    interactor.doRegister(formattedPhoneNumber, smsController.text, invitationController.text);
  }

  void dispose() {
    phoneController.dispose();
    smsController.dispose();
    invitationController.dispose();
  }
}
