/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';
import 'package:coffee_bean/commons/custom_app_bar.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/commons/utils/keyboard_visibility.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/user_login_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/base_cubit_statefull_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coffee_bean/widget/password_field.dart';

//ignore: must_be_immutable
class UserLoginPage extends BaseCubitStateFulWidget with ViewControllable {
  UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends BaseCubitState<UserLoginPage, UserLoginInteractor, UserLoginState> with SingleTickerProviderStateMixin {

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
  Widget? getLayout(BuildContext context) {
    var appBar = getAppBar(context);
    if (appBar is String) {
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction());
    }

    return Scaffold(
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
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<UserLoginInteractor, UserLoginState>(
      listener: (context, state) {
        if (state is UserLoginInProgress) {
          iLog(state.message);
          showLoading(text: state.message);
        } else {
          hideLoading();
          if (state is UserLoginSuccess) {
            // Xử lý khi đăng nhập thành công
            interactor.router?.navigate(LoginSuccessRoute());
          } else if (state is UserLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            final double availableHeight = constraints.maxHeight - keyboardHeight;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                height: availableHeight,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Logo - Responsive height & size
                    Padding(
                      padding: EdgeInsets.only(
                        top: _isKeyboardVisible ? 20.0 : 50.0,
                        bottom: _isKeyboardVisible ? 15.0 : 40.0,
                      ),
                      child: Text(
                        "TMLabs Coffee",
                        style: TextStyle(
                          fontSize: _isKeyboardVisible ? 22 : 28, 
                          fontWeight: FontWeight.bold, 
                        ),
                      ),
                    ),

                    // Tab Bar
                    TabBar(
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
                    ),

                    const SizedBox(height: 30),

                    // Content Area (Expanded will shrink/expand to fit available space)
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildPasswordTab(),
                          _buildSMSTab(),
                        ],
                      ),
                    ),

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

  // --- WIDGET HỖ TRỢ ---
  Widget _buildSubmitButton({required int tabIndex}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          void onError(String message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          }

          if (tabIndex == 0) {
            _loginController.validatePwLogin(interactor, onError);
          } else {
            _loginController.validateSmsLogin(interactor, onError);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPasswordTab() {
    return Column(
      children: [
        _buildPhoneInput(
          controller: _loginController.phonePwLogin,
          selectedCode: _loginController.countryCode1,
          onCodeChanged: (val) => setState(() => _loginController.countryCode1 = val!),
        ),
        const SizedBox(height: 20),
        PasswordField(
          controller: _loginController.passwordController,
          hint: "Enter Password",
        ),
        const SizedBox(height: 30),
        _buildSubmitButton(tabIndex: 0),
        const SizedBox(height: 20),
        _buildFooterLinks(),
      ],
    );
  }

  Widget _buildSMSTab() {
    return Column(
      children: [
        _buildPhoneInput(
          controller: _loginController.phoneSmsLogin,
          selectedCode: _loginController.countryCode2,
          onCodeChanged: (val) => setState(() => _loginController.countryCode2 = val!),
        ),
        const SizedBox(height: 20),
        _buildUnderlineInput(
          controller: _loginController.smsController,
          hint: "SMS Code",
          suffix: _buildCountdownButton(),
        ),
        const SizedBox(height: 30),
        _buildSubmitButton(tabIndex: 1),
        const SizedBox(height: 20),
        _buildFooterLinks(hideForgotPw: true),
      ],
    );
  }

  Widget _buildCountdownButton() {
    return InkWell(
      onTap: _isCountingDown ? null : () {
        if (_loginController.phoneSmsLogin.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter phone number"), backgroundColor: Colors.red),
          );
          return;
        }
        _startCountdown();
        // interactor.sendSmsCode...
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

  // Hàm Build Phone Input tùy biến để dùng cho cả 2 tab
  Widget _buildPhoneInput({
    required TextEditingController controller,
    required String selectedCode,
    required ValueChanged<String?> onCodeChanged,
  }) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCode,
              icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
              items: ["+86", "+84", "+1"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onCodeChanged,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(hintText: "Phone Number", border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderlineInput({required TextEditingController controller, required String hint, Widget? suffix}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: suffix != null ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [suffix]) : null,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
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
            width: 18, height: 18,
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
}

class LoginController {
  final phonePwLogin = TextEditingController();
  final passwordController = TextEditingController();
  final phoneSmsLogin = TextEditingController();
  final smsController = TextEditingController();

  String countryCode1 = "+86";
  String countryCode2 = "+86";
  bool isAgreed = false;

  void validatePwLogin(UserLoginInteractor interactor, Function(String) onError) {
    if (!isAgreed) {
      onError("Please agree to the User Agreement and Privacy Policy");
      return;
    }
    if (phonePwLogin.text.isEmpty) {
      onError("Please enter phone number");
      return;
    }
    if (passwordController.text.isEmpty) {
      onError("Please enter password");
      return;
    }
    interactor.doLoginWithPw("$countryCode1${phonePwLogin.text}", passwordController.text);
  }

  void validateSmsLogin(UserLoginInteractor interactor, Function(String) onError) {
    if (!isAgreed) {
      onError("Please agree to the User Agreement and Privacy Policy");
      return;
    }
    if (phoneSmsLogin.text.isEmpty) {
      onError("Please enter phone number");
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
