import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? labelText;
  final AppInputStyleConfig config;
  final String? errorText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const PasswordField({
    super.key,
    required this.controller,
    this.hint = "Enter Password",
    this.labelText,
    this.config = const AppInputStyleConfig(),
    this.errorText,
    this.validator,
    this.textInputAction,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: widget.controller,
      hintText: widget.hint,
      labelText: widget.labelText,
      obscureText: _obscureText,
      config: widget.config,
      errorText: widget.errorText,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 18,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
