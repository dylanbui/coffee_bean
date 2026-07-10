/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Description: Định nghĩa style chung cho các widget trong thư viện commons.
 */

import 'package:db_core/utils/loading_dialog.dart';
import 'package:flutter/material.dart';

class AppButtonStyleConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderRadius;
  final double? height;
  final TextStyle? textStyle;
  final MainAxisSize mainAxisSize;

  const AppButtonStyleConfig({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.height = 48.0,
    this.textStyle,
    this.mainAxisSize = MainAxisSize.max,
  });

  AppButtonStyleConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderRadius,
    double? height,
    TextStyle? textStyle,
    MainAxisSize? mainAxisSize,
  }) {
    return AppButtonStyleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
    );
  }
}

class DbCommonStyle {
  // Brand Colors
  static const Color primaryColor = Colors.brown;
  static const Color secondaryColor = Colors.grey;
  
  // Status Colors
  static const Color successColor = Color.fromRGBO(0, 179, 134, 1.0);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color infoColor = Color(0xFF1976D2);

  // Button Styles
  static const AppButtonStyleConfig defaultButtonStyle = AppButtonStyleConfig(
    backgroundColor: primaryColor,
    textColor: Colors.white,
    borderRadius: 12.0,
    height: 48.0,
  );

  static const TextStyle defaultTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    decoration: TextDecoration.none, // Xóa gạch chân vàng
  );

  static const DbLoadingStyle defaultLoadingStyle = DbLoadingStyle(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.brown,
      decoration: TextDecoration.none,
    ),
    progressColor: Colors.brown,
    backgroundColor: Colors.white,
    borderRadius: 16.0,
  );
  
  static const TextStyle toastTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    decoration: TextDecoration.none,
  );
}

enum TabIndicatorMode { underline, background }

class AppSlidingTabBarStyle {
  final TextStyle? activeStyle;
  final TextStyle? inactiveStyle;
  final Color activeColor;
  final Color inactiveColor;
  final Color? activeTextColor; // Dùng cho mode Background để ép màu chữ (vd: trắng)
  final double indicatorHeight;
  final double indicatorRadius;
  final EdgeInsetsGeometry itemPadding;
  final double spacing;

  const AppSlidingTabBarStyle({
    this.activeStyle,
    this.inactiveStyle,
    this.activeColor = Colors.black,
    this.inactiveColor = Colors.grey,
    this.activeTextColor,
    this.indicatorHeight = 2.0,
    this.indicatorRadius = 4.0,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.spacing = 24.0,
  });

  AppSlidingTabBarStyle copyWith({
    TextStyle? activeStyle,
    TextStyle? inactiveStyle,
    Color? activeColor,
    Color? inactiveColor,
    Color? activeTextColor,
    double? indicatorHeight,
    double? indicatorRadius,
    EdgeInsetsGeometry? itemPadding,
    double? spacing,
  }) {
    return AppSlidingTabBarStyle(
      activeStyle: activeStyle ?? this.activeStyle,
      inactiveStyle: inactiveStyle ?? this.inactiveStyle,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      activeTextColor: activeTextColor ?? this.activeTextColor,
      indicatorHeight: indicatorHeight ?? this.indicatorHeight,
      indicatorRadius: indicatorRadius ?? this.indicatorRadius,
      itemPadding: itemPadding ?? this.itemPadding,
      spacing: spacing ?? this.spacing,
    );
  }

  static const defaultStyle = AppSlidingTabBarStyle(
    activeStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    inactiveStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
    activeColor: Colors.black,
    inactiveColor: Colors.grey,
    spacing: 24,
  );
}
