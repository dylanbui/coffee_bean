/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/user_login_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/base_cubit_statefull_widget.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:url_launcher/url_launcher.dart'; // Cần thêm vào pubspec.yaml
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

  // Logic Countdown cho SMS
  int _start = 60;
  bool _isCountingDown = false;
  Timer? _timer;

  @override
  dynamic getAppBar(BuildContext context) => "Login";

  @override
  void initState() {
    super.initState();
    _loginController = LoginController();
    _tabController = TabController(length: 2, vsync: this);
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
        return _buildMainLayout(context);
      },
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // region Private functions

  Widget _buildMainLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              "TMLabs Coffee",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
            ),
          ),

          // Tab Bar - Cố định
          TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Password Login"),
              Tab(text: "SMS Login"),
            ],
          ),

          const SizedBox(height: 30),

          // Vùng nội dung trượt: Chiếm toàn bộ không gian còn lại
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPasswordTab(), // Tab 1
                _buildSMSTab(),      // Tab 2
              ],
            ),
          ),

          const SizedBox(height: 20),
          _buildPolicyAgreement(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- WIDGET HỖ TRỢ ---
  Widget _buildSubmitButton({required int tabIndex}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: const Text("Login", style: TextStyle(color: Colors.white)),
      ),
    );
  }

// --- TAB 1: PASSWORD LOGIN ---
  Widget _buildPasswordTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Ô nhập SDT riêng của Tab 1
          _buildPhoneInput(
            controller: _loginController.phonePwLogin,
            selectedCode: _loginController.countryCode1,
            onCodeChanged: (val) => setState(() => _loginController.countryCode1 = val!),
          ),
          const SizedBox(height: 15),
          PasswordField(
            controller: _loginController.passwordController,
            hint: "Enter Password",
          ),
          const SizedBox(height: 30),
          _buildSubmitButton(tabIndex: 0),

          const SizedBox(height: 15),
          _buildFooterLinks(),
        ],
      ),
    );
  }

  // --- TAB 2: SMS LOGIN ---
  Widget _buildSMSTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Ô nhập SDT riêng của Tab 2
          _buildPhoneInput(
            controller: _loginController.phoneSmsLogin,
            selectedCode: _loginController.countryCode2,
            onCodeChanged: (val) => setState(() => _loginController.countryCode2 = val!),
          ),
          const SizedBox(height: 15),
          _buildUnderlineInput(
            controller: _loginController.smsController,
            hint: "SMS Code",
            //suffix: _buildCountdownButton(),
          ),
          const SizedBox(height: 30),
          _buildSubmitButton(tabIndex: 1),

          const SizedBox(height: 15),
          _buildFooterLinks(hideForgotPw: true),
        ],
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
              items: ["+86", "+84", "+1"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onCodeChanged,
            ),
          ),
          const SizedBox(width: 10),
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

  Widget _buildUnderlineInput({required TextEditingController controller, required String hint, bool isPassword = false, Widget? suffix}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye_outlined, size: 18) : null,
        suffix: suffix,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
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
            const Text("No account? ", style: TextStyle(fontSize: 14)),
            InkWell(
              onTap: () {
                iLog("Tap: Register Now");
                interactor.router?.navigate(UserRegisterRoute());
              },
              child: const Text(
                "Register Now",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
        if (!hideForgotPw)
          InkWell(
            onTap: () {
              iLog("Tap: Forgot Password");
              interactor.router?.navigate(ForgotPasswordRoute());
            },
            child: const Text(
              "Forgot Password",
              style: TextStyle(color: Colors.grey, fontSize: 14),
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
          onTap: () => setState(() => _loginController.isAgreed = !_loginController.isAgreed),
          child: Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _loginController.isAgreed ? Colors.black : Colors.grey),
              color: _loginController.isAgreed ? Colors.black : Colors.transparent,
            ),
            child: _loginController.isAgreed ? Icon(Icons.check, size: 10, color: Colors.white) : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 12, color: Colors.grey),
              children: [
                TextSpan(text: "I have read and agree to the "),
                TextSpan(
                  text: "User Agreement",
                  style: TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('https://example.com/terms')),
                ),
                TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('https://example.com/privacy')),
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => _isCountingDown = false);
        _timer?.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }
  // endregion


}

// --- CẬP NHẬT CONTROLLER ---
class LoginController {
  final formKey = GlobalKey<FormState>();

  // Tab 1: Password Login
  final phonePwLogin = TextEditingController(); // Số điện thoại Tab 1
  final passwordController = TextEditingController();

  // Tab 2: SMS Login
  final phoneSmsLogin = TextEditingController(); // Số điện thoại Tab 2
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
