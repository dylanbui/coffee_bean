import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneValue {
  final String countryCode;
  final String number;
  final bool isValid;

  PhoneValue({
    required this.countryCode,
    required this.number,
    required this.isValid,
  });

  String get fullNumber => "$countryCode$number";
}

class PhoneInputField extends StatefulWidget {
  final List<String>? countryCodes;
  final String initialCountryCode;
  final String hintText;
  final TextEditingController? controller;
  final String? errorText;
  final bool enabled;
  final Function(PhoneValue)? onChanged;

  // UI Customization
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? underlineColor;
  final Color? activeUnderlineColor;
  final double underlineWidth;

  const PhoneInputField({
    super.key,
    this.countryCodes,
    this.initialCountryCode = "+84",
    this.hintText = "Phone Number",
    this.controller,
    this.errorText,
    this.enabled = true,
    this.onChanged,
    this.style,
    this.hintStyle,
    this.underlineColor,
    this.activeUnderlineColor,
    this.underlineWidth = 1.0,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late String _selectedCode;
  late TextEditingController _internalController;

  // Map mã vùng -> emoji cờ
  final Map<String, String> countryFlags = {
    "+84": "🇻🇳", // Việt Nam
    "+86": "🇨🇳", // Trung Quốc
    "+65": "🇸🇬", // Singapore
    "+1": "🇺🇸", // Mỹ
    "+44": "🇬🇧", // Anh
  };

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.initialCountryCode;
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(_handleChanged);
  }

  void _handleChanged() {
    final String originalText = _internalController.text;
    String text = originalText.trim();
    final TextSelection oldSelection = _internalController.selection;

    bool hasPrefixChanged = false;

    // 1. Nhận diện Prefix thông minh hơn
    // Chỉ tự động nhảy mã vùng nếu:
    // - Bắt đầu bằng dấu '+'
    // - Hoặc dán một chuỗi dài (độ dài > 5) bắt đầu bằng mã vùng hợp lệ
    if (text.startsWith('+') || text.length > 5) {
      final prefixPattern = RegExp(r'^\+?\d{1,3}');
      final match = prefixPattern.firstMatch(text);
      if (match != null) {
        final prefix = match.group(0)!;
        final normalizedPrefix = prefix.startsWith('+') ? prefix : '+$prefix';

        if (widget.countryCodes != null && widget.countryCodes!.contains(normalizedPrefix)) {
          if (_selectedCode != normalizedPrefix) {
            setState(() => _selectedCode = normalizedPrefix);
          }
          text = text.substring(match.end).trim();
          hasPrefixChanged = true;
        }
      }
    }

    // 2. Tự động xóa số '0' ở đầu (sau khi đã bóc tách prefix)
    int leadingZerosCount = 0;
    if (text.startsWith('0')) {
      final match = RegExp(r'^0+').firstMatch(text);
      if (match != null) {
        leadingZerosCount = match.group(0)!.length;
        text = text.replaceFirst(RegExp(r'^0+'), '');
      }
    }

    // 3. Xử lý con trỏ (Cursor handling)
    // Chỉ cập nhật value nếu text thực tế có thay đổi (bị cắt prefix hoặc xóa số 0)
    if (text != originalText || hasPrefixChanged) {
      int newOffset = oldSelection.end;

      if (hasPrefixChanged) {
        // Nếu bóc prefix, con trỏ thường nhảy về cuối phần số còn lại
        newOffset = text.length;
      } else {
        // Nếu chỉ xóa số 0, lùi con trỏ lại tương ứng
        newOffset = (oldSelection.end - leadingZerosCount).clamp(0, text.length);
      }

      _internalController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: newOffset),
      );
    }

    // 4. Validate
    final bool showSelectBox = widget.countryCodes != null && widget.countryCodes!.isNotEmpty;
    bool isValid = text.length > 8;

    widget.onChanged?.call(PhoneValue(
      countryCode: showSelectBox ? _selectedCode : "",
      number: text,
      isValid: isValid,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bool showSelectBox = widget.countryCodes != null && widget.countryCodes!.isNotEmpty;
    final Color effectiveUnderlineColor = widget.errorText != null
        ? Colors.red
        : (widget.activeUnderlineColor ?? Colors.black);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.errorText != null
                    ? Colors.red
                    : (widget.underlineColor ?? Colors.grey.shade200),
                width: widget.errorText != null ? 2.0 : widget.underlineWidth,
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
                    items: widget.countryCodes!.map((code) {
                      final flag = countryFlags[code] ?? "🌐";
                      return DropdownMenuItem(
                        value: code,
                        child: Text("$flag $code"),
                      );
                    }).toList(),
                    onChanged: widget.enabled
                        ? (val) {
                            if (val != null) {
                              setState(() => _selectedCode = val);
                              _handleChanged();
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 15),
              ],
              Expanded(
                child: TextField(
                  controller: _internalController,
                  keyboardType: TextInputType.phone,
                  enabled: widget.enabled,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  style: widget.style ?? const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    hintStyle: widget.hintStyle ?? TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
            ],
          ),
        ),
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
