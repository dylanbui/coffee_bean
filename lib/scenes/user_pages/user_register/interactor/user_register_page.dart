/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/scenes/user_pages/user_register/interactor/user_register_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/user_register/interactor/user_register_interactor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/base_cubit_statefull_widget.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class UserRegisterPage extends BaseCubitStateFulWidget with ViewControllable {
  UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends BaseCubitState<UserRegisterPage, UserRegisterInteractor, UserRegisterState> {

  late RegisterController _registerController;

  // Logic Countdown cho SMS
  int _start = 60;
  bool _isCountingDown = false;
  Timer? _timer;

  @override
  dynamic getAppBar(BuildContext context) => "Register";

  @override
  void initState() {
    super.initState();
    _registerController = RegisterController();
  }

  @override
  Widget getBody(BuildContext context) {
    // 1. Lấy các thông số kích thước (như ý tưởng của bạn)
    final double screenHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double appBarHeight = kToolbarHeight; // Chiều cao chuẩn của AppBar

    // 2. Tính toán chiều cao khả dụng linh hoạt
    // TRỪ THÊM keyboardHeight để Container tự co lại khi bàn phím hiện
    double availableHeight = screenHeight - statusBarHeight - appBarHeight - keyboardHeight;

    return BlocConsumer<UserRegisterInteractor, UserRegisterState>(
      listener: (context, state) {
        if (state is UserRegisterInProgress) {
          showLoading();
        } else {
          hideLoading();
          if (state is UserRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Register Success!"), backgroundColor: Colors.green),
            );
          } else if (state is UserRegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          // Tắt tính năng tự đẩy của Scaffold để Container tự quản lý bằng availableHeight
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              // Đây là mấu chốt: Chiều cao sẽ thay đổi realtime khi bàn phím hiện/ẩn
              height: availableHeight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  // --- PHẦN NỘI DUNG TRÊN ---
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      "TMLabs Coffee",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildPhoneInput(
                    controller: _registerController.phoneController,
                    selectedCode: _registerController.countryCode,
                    onCodeChanged: (val) => setState(() => _registerController.countryCode = val!),
                  ),
                  const SizedBox(height: 15),
                  _buildUnderlineInput(controller: _registerController.smsController, hint: "Verification code"),
                  const SizedBox(height: 15),
                  _buildUnderlineInput(controller: _registerController.invitationController, hint: "Invitation code"),

                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                  const SizedBox(height: 15),
                  _buildFooterLinks(),

                  // --- PHẦN CO GIÃN ---
                  // Lúc này Expanded sẽ hoạt động cực chuẩn vì Container cha đã co lại
                  const Expanded(child: SizedBox.shrink()),

                  // --- PHẦN POLICY Ở ĐÁY ---
                  _buildPolicyAgreement(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _registerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // region Private functions

  Widget _buildSubmitButton() {
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
          _registerController.validateRegister(interactor, onError);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: const Text("Register", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCountdownButton() {
    return InkWell(
      onTap: _isCountingDown ? null : () {
        if (_registerController.phoneController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter phone number"), backgroundColor: Colors.red),
          );
          return;
        }
        _startCountdown();
        interactor.sendSmsCode("${_registerController.countryCode}${_registerController.phoneController.text}");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          _isCountingDown ? "Resend in ${_start}s" : "Send Code",
          style: TextStyle(
            color: _isCountingDown ? Colors.grey : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

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

  Widget _buildUnderlineInput({required TextEditingController controller, required String hint, Widget? suffix}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffix: suffix,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
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
            iLog("Tap: Go to Login");
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
            width: 16, height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _registerController.isAgreed ? Colors.black : Colors.grey),
              color: _registerController.isAgreed ? Colors.black : Colors.transparent,
            ),
            child: _registerController.isAgreed ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              children: [
                const TextSpan(text: "I have read and agree to the "),
                TextSpan(
                  text: "User Agreement",
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse('https://example.com/terms')),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(decoration: TextDecoration.underline),
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
