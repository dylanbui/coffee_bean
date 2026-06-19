import 'dart:async';
import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/underline_input_field.dart';

class CodeInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Future<bool> Function() onSendCode;
  final int countdownSeconds;

  const CodeInputField({
    super.key,
    required this.controller,
    this.hint = "Mã xác thực SMS",
    required this.onSendCode,
    this.countdownSeconds = 60,
  });

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  int _start = 0;
  bool _isCountingDown = false;
  Timer? _timer;
  bool _isSending = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _start = widget.countdownSeconds;
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

  Future<void> _handleSendCode() async {
    if (_isCountingDown || _isSending) return;
    
    setState(() => _isSending = true);
    final success = await widget.onSendCode();
    if (mounted) {
      setState(() => _isSending = false);
      if (success) {
        _startCountdown();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnderlineInputField(
      controller: widget.controller,
      hint: widget.hint,
      keyboardType: TextInputType.number,
      suffix: InkWell(
        onTap: _handleSendCode,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            _isCountingDown ? "Gửi lại (${_start}s)" : (_isSending ? "..." : "Gửi mã"),
            style: TMLabsTextStyle.bodyBold.copyWith(
              color: _isCountingDown || _isSending ? TMLabsColor.lightGrey : TMLabsColor.primary,
            ),
          ),
        ),
      ),
    );
  }
}
