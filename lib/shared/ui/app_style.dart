import 'package:db_core/utils/common_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';

class DefaultStyle {
  static const textSmall = TextStyle(
    color: Color(0xFF757575), // Colors.grey[600]
    fontSize: 12,
  );

  static const textNormal = TextStyle(
    color: Color(0xFF424242), // Colors.grey[800]
    fontSize: 14,
  );

  static const textLarge = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

class BigRevampStyle {
  static const labelTextStyle = TextStyle(
    color: AppColor.secondaryText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const checkAllTextStyle = TextStyle(
    color: AppColor.blackDefault,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const checkboxTextStyle = TextStyle(
    color: AppColor.blackDefault,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const checkboxShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(3)),
    side: BorderSide(
      width: 0.3,
      color: Color(0xFF979797),
    ),
  );
}

class AppButtonStyle {
  static final primary = ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static final secondary = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFEEEEEE), // Colors.grey.shade200
    foregroundColor: Colors.black,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static final outline = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
    side: const BorderSide(color: Colors.black, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

class BasicStyle {
  static const primaryText = TextStyle(
    color: AppColor.basicPrimaryText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const secondaryText = TextStyle(
    color: AppColor.basicSecondaryText,
    fontSize: 14,
  );

  static const priceText = TextStyle(
    color: AppColor.basicPrice,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const tabLabel = TextStyle(
    color: AppColor.basicAccent,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const tabUnselectedLabel = TextStyle(
    color: AppColor.basicSecondaryText,
    fontSize: 14,
  );
}

class TMLabsStyle {}

class TMLabsTextStyle {
  static const _fontFamily = 'Source Sans Pro';

  static const semibold = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const light = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const extraLight = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w200,
  );

  static const regular = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}

class TMLabsButtonStyle {
  // --- App Button Styles ---
  static const primary = AppButtonStyleConfig(
    backgroundColor: TMLabsColor.primary,
    textColor: Colors.white,
    borderRadius: 25,
  );

  static const outline = AppButtonStyleConfig(
    backgroundColor: Colors.transparent,
    textColor: TMLabsColor.primary,
    borderColor: TMLabsColor.primary,
    borderRadius: 25,
  );

  static const white = AppButtonStyleConfig(
    backgroundColor: Colors.white,
    textColor: TMLabsColor.primary,
    borderRadius: 25,
  );
}

class TmLabAppBarStyle {
  static const whiteStyle = CoffeeAppBarStyleConfig(
    backgroundColor: Colors.white,
    foregroundColor: TMLabsColor.primary,
    titleTextStyle: TextStyle(
      fontFamily: 'Source Sans Pro',
      color: TMLabsColor.primary,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );

  static const transparentStyle = CoffeeAppBarStyleConfig(
    backgroundColor: Colors.transparent,
    foregroundColor: TMLabsColor.primary,
    titleTextStyle: TextStyle(
      fontFamily: 'Source Sans Pro',
      color: TMLabsColor.primary,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );

  static const navyStyle = CoffeeAppBarStyleConfig(
    backgroundColor: Color(0xFF0D1B3E),
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: 'Source Sans Pro',
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );
}

class TMLabsLoadingStyle {
  static const DbLoadingStyle defaultLoadingStyle = DbLoadingStyle(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: TMLabsColor.primary,
      decoration: TextDecoration.none,
    ),
    progressColor: TMLabsColor.primary,
    backgroundColor: Colors.white,
    borderRadius: 16.0,
  );
}