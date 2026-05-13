import 'package:flutter/material.dart';

class UnderlineInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffix;
  final TextInputType keyboardType;
  final bool obscureText;

  const UnderlineInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        suffixIcon: suffix != null 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [suffix!],
              ) 
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
