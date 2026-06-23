import 'package:flutter/material.dart';

// https://getemoji.com/
// https://github.com/lipis/flag-icons/tree/main/flags/4x3

enum Language {
  vi(code: 'vi', countryCode: 'VN', name: 'Tiếng Việt', flag: 'assets/icons/ic_flag_vn.svg', emoji: '🇻🇳'),
  en(code: 'en', countryCode: 'US', name: 'English', flag: 'assets/icons/ic_flag_en.svg', emoji: '🇺🇸'),
  cn(code: 'cn', countryCode: 'CN', name: 'China', flag: 'assets/icons/ic_flag_cn.svg', emoji: '🇨🇳');

  final String code;
  final String countryCode;
  final String name;
  final String flag;
  final String emoji;

  const Language({
    required this.code, 
    required this.countryCode, 
    required this.name, 
    required this.flag,
    required this.emoji,
  });

  Locale get locale => Locale(code, countryCode);
}
