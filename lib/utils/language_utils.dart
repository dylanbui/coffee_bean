import 'package:flutter/material.dart';

enum Language {
  vi(code: 'vi', countryCode: 'VN', name: 'Tiếng Việt', flag: 'assets/icons/ic_flag_vn.svg'),
  en(code: 'en', countryCode: 'US', name: 'English', flag: 'assets/icons/ic_flag_en.svg');

  final String code;
  final String countryCode;
  final String name;
  final String flag;

  const Language({
    required this.code, 
    required this.countryCode, 
    required this.name, 
    required this.flag,
  });

  Locale get locale => Locale(code, countryCode);
}
