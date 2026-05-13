import 'package:flutter/material.dart';
import 'package:coffee_bean/utils/app_colors.dart';

class DefaultStyle {
  static final textSmall = TextStyle(
    color: Colors.grey[600],
    fontSize: 12,
  );

  static final textNormal = TextStyle(
    color: Colors.grey[800],
    fontSize: 14,
  );

  static final textLarge = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

class BigRevampStyle {

  static final labelTextStyle = TextStyle(
    color: AppColor.secondaryText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final checkAllTextStyle = TextStyle(
    color: HexColor('242933'),
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static final checkboxTextStyle = TextStyle(
    color: HexColor('242933'),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final checkboxShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(3),
    side: BorderSide(
      width: 0.3,
      color: HexColor('979797'),
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
    backgroundColor: Colors.grey.shade200,
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
  static final primaryText = TextStyle(
    color: AppColor.basicPrimaryText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final secondaryText = TextStyle(
    color: AppColor.basicSecondaryText,
    fontSize: 14,
  );

  static final priceText = TextStyle(
    color: AppColor.basicPrice,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final tabLabel = TextStyle(
    color: AppColor.basicAccent,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final tabUnselectedLabel = TextStyle(
    color: AppColor.basicSecondaryText,
    fontSize: 14,
  );
}

class TMLabsStyle {
  static const _fontFamily = 'Source Sans Pro';

  static final semibold = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static final light = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static final extraLight = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w200,
  );

  static final regular = TextStyle(
    fontFamily: _fontFamily,
    color: TMLabsColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}