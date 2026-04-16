import 'package:flutter/material.dart';
import 'package:coffee_bean/utils/app_colors.dart';

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