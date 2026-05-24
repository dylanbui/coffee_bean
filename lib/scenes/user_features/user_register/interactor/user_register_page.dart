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
import 'package:coffee_bean/scenes/user_features/user_register/interactor/user_register_event_state.dart';
import 'package:coffee_bean/scenes/user_features/user_register/interactor/user_register_interactor.dart';
import 'package:coffee_bean/scenes/user_features/user_register/user_register_builder.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar_ext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/underline_input_field.dart';
import 'package:db_core/utils/app_button.dart';

//ignore: must_be_immutable
class UserRegisterPage extends CubitStateFulWidget<UserRegisterInteractor, UserRegisterState> {
  UserRegisterPage({super.key, required super.interactor});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends CubitState<UserRegisterPage, UserRegisterInteractor, UserRegisterState> {

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
  }

  @override
  void dispose() {
    _registerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) => coffeeAppBar("Register");

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
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: DbKeyboardVisibility(
            onChanged: (info) {
              if (mounted && _isKeyboardVisible != info.isVisible) {
                setState(() => _isKeyboardVisible = info.isVisible);
              }
            },
            child: getBody(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<UserRegisterInteractor, UserRegisterState>(
      listener: _onRegisterStateChanged,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            double availableHeight = constraints.maxHeight - keyboardHeight;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                height: availableHeight,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    _buildLogo(),
                    _buildInputs(),
                    const SizedBox(height: 40),
                    AppButton(
                      text: "Register",
                      isLoading: state is UserRegisterInProgress,
                      onPressed: () {
                        _registerController.validateRegister(interactor, _showError);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildFooterLinks(),
                    const Expanded(child: SizedBox.shrink()),
                    _buildPolicyAgreement(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // region Private functions

  void _onRegisterStateChanged(BuildContext context, UserRegisterState state) {
    if (state is UserRegisterInProgress) {
      showLoading();
    } else {
      hideLoading();
      if (state is UserSetPassword) {
        // Dang chuyen trang qua set password
      } else if (state is UserRegisterSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Register Success!"), backgroundColor: Colors.green),
        );
      } else if (state is UserRegisterError) {
        _showError(state.message);
      }
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
      child: Text(
        "TMLabs Coffee",
        style: TextStyle(
          fontSize: _isKeyboardVisible ? 22 : 28, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        PhoneInputField(
          controller: _registerController.phoneController,
          countryCodes: const ["+86", "+84", "+1"],
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
        if (_registerController.phoneController.text.isEmpty) {
          _showError("Please enter phone number");
          return;
        }
        _startCountdown();
        interactor.sendSmsCode("${_registerController.countryCode}${_registerController.phoneController.text}");
      },
      child: Text(
        _isCountingDown ? "Resend (${_start}s)" : "Send Code",
        style: TextStyle(
          color: _isCountingDown ? Colors.grey : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ", style: TextStyle(fontSize: 14)),
        InkWell(
          onTap: () {
            iLog("Tap: Go to Login - khong cho phep o day, se bi cycle app");
            // interactor.router?.navigate(UserLoginRoute());
          },
          child: const Text(
            "Go to Login",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
              border: Border.all(color: _registerController.isAgreed ? Colors.black : Colors.grey.shade300, width: 1.5),
              color: _registerController.isAgreed ? Colors.black : Colors.transparent,
            ),
            child: _registerController.isAgreed ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
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

class RegisterController {
  final phoneController = TextEditingController();
  final smsController = TextEditingController();
  final invitationController = TextEditingController();

  String countryCode = "+86";
  bool isAgreed = false;

  void validateRegister(UserRegisterInteractor interactor, Function(String) onError) {
    if (!isAgreed) {
      onError("Please agree to the User Agreement and Privacy Policy");
      return;
    }
    if (phoneController.text.isEmpty) {
      onError("Please enter phone number");
      return;
    }
    if (smsController.text.isEmpty) {
      onError("Please enter verification code");
      return;
    }
    interactor.doRegister("$countryCode${phoneController.text}", smsController.text, invitationController.text);
  }

  void dispose() {
    phoneController.dispose();
    smsController.dispose();
    invitationController.dispose();
  }
}
