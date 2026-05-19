/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';
import 'package:coffee_bean/core/custom_app_bar.dart';
import 'package:coffee_bean/core/utils/logger.dart';
import 'package:coffee_bean/core/utils/keyboard_visibility.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/user_login_builder.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/shared/widget/password_field.dart';
import 'package:coffee_bean/shared/widget/phone_input_field.dart';
import 'package:coffee_bean/shared/widget/underline_input_field.dart';
import 'package:coffee_bean/shared/widget/app_button.dart';

//ignore: must_be_immutable
class UserLoginPage extends CubitStateFulWidget<UserLoginInteractor, UserLoginState> {
  UserLoginPage({super.key, required super.interactor});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends CubitState<UserLoginPage, UserLoginInteractor, UserLoginState>
    with SingleTickerProviderStateMixin {
  late LoginController _loginController;
  late TabController _tabController;
  bool _isKeyboardVisible = false;

  // Logic Countdown cho SMS
  int _start = 60;
  bool _isCountingDown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _loginController.dispose();
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) => "Login";

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    var appBar = getAppBar(context);
    if (appBar is String) {
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction());
    }

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
    return BlocConsumer<UserLoginInteractor, UserLoginState>(
      listener: _onLoginStateChanged,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Return loading all widget
            if (state is UserLoginInitial) {
              return const Center(child: LoadingView(width: 150, height: 150));
            }

            final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            final double availableHeight = constraints.maxHeight - keyboardHeight;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                height: availableHeight,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildLogo(),
                    _buildTabBar(),
                    const SizedBox(height: 30),
                    _buildTabBarView(),
                    const SizedBox(height: 10),
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

  // --- LOGIC HỖ TRỢ ---

  void _onLoginStateChanged(BuildContext context, UserLoginState state) {
    if (state is UserLoginInitial) {
      eLog("UserLoginInitial");
      showPageLoading();
    } else if (state is UserLoginStarted) {
      iLog("UserLoginStarted");
      hidePageLoading();
    } else if (state is UserLoginInProgress) {
      iLog(state.message);
      showLoading(text: state.message);
    } else {
      hideLoading();
      if (state is UserLoginSuccess) {
        interactor.router?.navigate(LoginSuccessRoute());
      } else if (state is UserLoginFailure) {
        _showError(state.error);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
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

  // --- WIDGET HỖ TRỢ ---

  Widget _buildLogo() {
    return Padding(
      padding: EdgeInsets.only(top: _isKeyboardVisible ? 20.0 : 50.0, bottom: _isKeyboardVisible ? 15.0 : 40.0),
      child: Text(
        "TMLabs Coffee",
        style: TextStyle(fontSize: _isKeyboardVisible ? 22 : 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      indicatorColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3,
      tabs: const [
        Tab(text: "Password Login"),
        Tab(text: "SMS Login"),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildPasswordTab(), _buildSMSTab()],
      ),
    );
  }

  Widget _buildPasswordTab() {
    return Column(
      children: [
        PhoneInputField(
          controller: _loginController.phonePwLogin,
          countryCodes: const ["+86", "+84", "+1"],
          initialCountryCode: _loginController.countryCode1,
          errorText: _loginController.phonePwError,
          onChanged: (val) => _loginController.countryCode1 = val.countryCode,
        ),
        const SizedBox(height: 20),
        PasswordField(controller: _loginController.passwordController, hint: "Enter Password"),
        const SizedBox(height: 30),
        AppButton(
          text: "Login",
          onPressed: () {
            setState(() {
              _loginController.validatePwLogin(interactor, _showError);
            });
          },
        ),
        const SizedBox(height: 20),
        _buildFooterLinks(),
      ],
    );
  }

  Widget _buildSMSTab() {
    return Column(
      children: [
        PhoneInputField(
          controller: _loginController.phoneSmsLogin,
          countryCodes: const ["+86", "+84", "+1"],
          initialCountryCode: _loginController.countryCode2,
          errorText: _loginController.phoneSmsError,
          onChanged: (val) => _loginController.countryCode2 = val.countryCode,
        ),
        const SizedBox(height: 20),
        UnderlineInputField(
          controller: _loginController.smsController,
          hint: "SMS Code",
          suffix: _buildCountdownButton(),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 30),
        AppButton(
          text: "Login",
          onPressed: () {
            setState(() {
              _loginController.validateSmsLogin(interactor, _showError);
            });
          },
        ),
        const SizedBox(height: 20),
        _buildFooterLinks(hideForgotPw: true),
      ],
    );
  }

  Widget _buildCountdownButton() {
    return InkWell(
      onTap: _isCountingDown
          ? null
          : () {
              if (_loginController.phoneSmsLogin.text.isEmpty) {
                _showError("Please enter phone number");
                return;
              }
              _startCountdown();
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

  Widget _buildFooterLinks({bool hideForgotPw = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("No account? ", style: TextStyle(fontSize: 14, color: Colors.grey)),
            InkWell(
              onTap: () => interactor.router?.navigate(UserRegisterRoute()),
              child: const Text("Register Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
        if (!hideForgotPw)
          InkWell(
            onTap: () => interactor.router?.navigate(ForgotPasswordRoute()),
            child: const Text("Forgot Password", style: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
      ],
    );
  }

  Widget _buildPolicyAgreement() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() => _loginController.isAgreed = !_loginController.isAgreed),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _loginController.isAgreed ? Colors.black : Colors.grey.shade300, width: 1.5),
              color: _loginController.isAgreed ? Colors.black : Colors.transparent,
            ),
            child: _loginController.isAgreed ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
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
                  recognizer: TapGestureRecognizer()..onTap = () => interactor.router?.navigate(UserAgreementRoute()),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => interactor.router?.navigate(PrivacyPolicyRoute()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoginController {
  final phonePwLogin = TextEditingController();
  final passwordController = TextEditingController();
  final phoneSmsLogin = TextEditingController();
  final smsController = TextEditingController();

  String countryCode1 = "+86";
  String countryCode2 = "+86";
  bool isAgreed = false;

  String? phonePwError;
  String? phoneSmsError;

  void validatePwLogin(UserLoginInteractor interactor, Function(String) onError) {
    phonePwError = null;
    if (!isAgreed) {
      onError("Please agree to the User Agreement and Privacy Policy");
      return;
    }
    if (phonePwLogin.text.isEmpty) {
      phonePwError = "Please enter phone number";
      return;
    }
    if (passwordController.text.isEmpty) {
      onError("Please enter password");
      return;
    }
    interactor.doLoginWithPw("$countryCode1${phonePwLogin.text}", passwordController.text);
  }

  void validateSmsLogin(UserLoginInteractor interactor, Function(String) onError) {
    phoneSmsError = null;
    if (!isAgreed) {
      onError("Please agree to the User Agreement and Privacy Policy");
      return;
    }
    if (phoneSmsLogin.text.isEmpty) {
      phoneSmsError = "Please enter phone number";
      return;
    }
    if (smsController.text.isEmpty) {
      onError("Please enter SMS code");
      return;
    }
    interactor.doLoginWithSms("$countryCode2${phoneSmsLogin.text}", smsController.text);
  }

  void dispose() {
    phonePwLogin.dispose();
    passwordController.dispose();
    phoneSmsLogin.dispose();
    smsController.dispose();
  }
}
