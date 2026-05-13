/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 6/5/26 - 09:58
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneValue {
    final String countryCode;
    final String number;
    final bool isValid;

    PhoneValue({required this.countryCode, required this.number, required this.isValid});

    String get fullNumber => "$countryCode$number";
}

class PhoneInputField extends StatefulWidget {
    final List<String>? countryCodes;
    final String initialCountryCode;
    final String hintText;
    final TextEditingController? controller;
    final String? errorText; // Receive error message from outside
    final Function(PhoneValue)? onChanged;

    const PhoneInputField({
        super.key,
        this.countryCodes,
        this.initialCountryCode = "+84",
        this.hintText = "Phone Number",
        this.controller,
        this.errorText,
        this.onChanged,
    });

    @override
    State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
    late String _selectedCode;
    late TextEditingController _internalController;

    @override
    void initState() {
        super.initState();
        _selectedCode = widget.initialCountryCode;
        _internalController = widget.controller ?? TextEditingController();
        _internalController.addListener(_handleChanged);
    }

    void _handleChanged() {
        String text = _internalController.text.trim();
        final bool showSelectBox = widget.countryCodes != null && widget.countryCodes!.isNotEmpty;

        // Automatically remove leading '0' ONLY IF the country code select box is shown
        if (showSelectBox && text.startsWith('0')) {
            text = text.replaceFirst(RegExp(r'^0+'), '');
            _internalController.value = TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
            );
            return;
        }

        bool isValid = false;
        if (showSelectBox) {
            // Case 1: Select box is shown
            // 1. Remove leading '0' (already handled above if it started with '0')
            // 2. Head number (digits only, no '+') + number A
            String codeDigits = _selectedCode.replaceAll(RegExp(r'[^0-9]'), '');
            int totalLength = (codeDigits + text).length;
            isValid = text.isNotEmpty && totalLength >= 10 && totalLength <= 11;
        } else {
            // Case 2: No select box
            isValid = text.isNotEmpty && text.length >= 10 && text.length <= 11;
        }

        widget.onChanged?.call(PhoneValue(
            countryCode: showSelectBox ? _selectedCode : "",
            number: text,
            isValid: isValid,
        ));
    }

    @override
    Widget build(BuildContext context) {
        final bool showSelectBox = widget.countryCodes != null && widget.countryCodes!.isNotEmpty;
        final Color activeColor = widget.errorText != null ? Colors.red : Colors.black;

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: widget.errorText != null ? Colors.red : Colors.grey.shade200,
                                width: widget.errorText != null ? 2.0 : 1.0,
                            ),
                        ),
                    ),
                    child: Row(
                        children: [
                            if (showSelectBox) ...[
                                DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        value: _selectedCode,
                                        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                                        items: widget.countryCodes!
                                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                            .toList(),
                                        onChanged: (val) {
                                            if (val != null) {
                                                setState(() => _selectedCode = val);
                                                _handleChanged();
                                            }
                                        },
                                    ),
                                ),
                                const SizedBox(width: 15),
                            ],
                            Expanded(
                                child: TextField(
                                    controller: _internalController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly, // Block non-digit characters
                                        LengthLimitingTextInputFormatter(10),   // Limit maximum length
                                    ],
                                    style: const TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        hintText: widget.hintText,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: Colors.grey.shade400),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
                // Display Error Text right below the underline
                if (widget.errorText != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                            widget.errorText!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ),
            ],
        );
    }
}