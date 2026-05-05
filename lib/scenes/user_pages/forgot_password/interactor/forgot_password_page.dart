/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';

import 'package:coffee_bean/scenes/user_pages/forgot_password/interactor/forgot_password_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/forgot_password/interactor/forgot_password_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/base_cubit_statefull_widget.dart';

//ignore: must_be_immutable
class ForgotPasswordPage extends BaseCubitStateFulWidget with ViewControllable {
  ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends BaseCubitState<ForgotPasswordPage, ForgotPasswordInteractor, ForgotPasswordState> {
  late ForgotPasswordController _forgotPwController;

  // Logic Countdown for SMS
  int _start = 60;
  bool _isCountingDown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _forgotPwController = ForgotPasswordController();
  }

  @override
  void dispose() {
    _forgotPwController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) => "Forgot Password";

  @override
  Widget getBody(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Instruction Text
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0),
                        child: Text(
                          "To ensure account security, please verify your identity first.",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                
                      // Inputs
                      _buildPhoneInput(
                        controller: _forgotPwController.phoneController,
                        selectedCode: _forgotPwController.countryCode,
                        onCodeChanged: (val) => setState(() => _forgotPwController.countryCode = val!),
                      ),
                
                      const SizedBox(height: 20),
                
                      _buildUnderlineInput(
                        controller: _forgotPwController.smsController,
                        hint: "Verification Code",
                        suffix: _buildCountdownButton(),
                      ),
                
                      const SizedBox(height: 50),
                
                      // 4. Submit Button
                      _buildSubmitButton(),
                
                      // VÙNG ĐỆM: Chiếm toàn bộ khoảng trống còn lại để nhận sự kiện tap
                      const Expanded(child: SizedBox.shrink()),
                
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // region Private functions

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          void onError(String message) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
          }

          _forgotPwController.validateAndSubmit(interactor, onError);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCountdownButton() {
    return InkWell(
      onTap: _isCountingDown
          ? null
          : () {
              if (_forgotPwController.phoneController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter phone number"), backgroundColor: Colors.red));
                return;
              }
              _startCountdown();
              interactor.sendSmsCode("${_forgotPwController.countryCode}${_forgotPwController.phoneController.text}");
            },
      child: Text(
        _isCountingDown ? "Resend (${_start}s)" : "Send Code",
        style: TextStyle(color: _isCountingDown ? Colors.grey : Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildPhoneInput({required TextEditingController controller, required String selectedCode, required ValueChanged<String?> onCodeChanged}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
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
              decoration: const InputDecoration(
                hintText: "Phone Number", // Phone number
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
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
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        suffixIcon: suffix != null ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [suffix]) : null,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
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
