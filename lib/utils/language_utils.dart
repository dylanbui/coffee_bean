import 'package:flutter/material.dart';

// https://getemoji.com/
// https://github.com/lipis/flag-icons/tree/main/flags/4x3

enum Language {
  vi(
    code: 'vi',
    countryCode: 'VN',
    name: 'Tiếng Việt',
    flag: 'assets/icons/ic_flag_vn.svg',
    emoji: '🇻🇳',
    discountUnit: '%',
    minSpendLabel: 'Đơn tối thiểu',
  ),
  en(
    code: 'en',
    countryCode: 'US',
    name: 'English',
    flag: 'assets/icons/ic_flag_en.svg',
    emoji: '🇺🇸',
    discountUnit: '%',
    minSpendLabel: 'Min spend',
  ),
  cn(
    code: 'cn',
    countryCode: 'CN',
    name: 'China',
    flag: 'assets/icons/ic_flag_cn.svg',
    emoji: '🇨🇳',
    discountUnit: '折',
    minSpendLabel: '满',
  );

  final String code;
  final String countryCode;
  final String name;
  final String flag;
  final String emoji;
  final String discountUnit;
  final String minSpendLabel;

  const Language({
    required this.code,
    required this.countryCode,
    required this.name,
    required this.flag,
    required this.emoji,
    required this.discountUnit,
    required this.minSpendLabel,
  });

  Locale get locale => Locale(code, countryCode);
}
