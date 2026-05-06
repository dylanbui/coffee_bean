/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Description: Định nghĩa style chung cho các widget trong thư viện commons.
 */

import 'package:flutter/material.dart';

class DbCommonStyle {
  static const TextStyle defaultTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    decoration: TextDecoration.none, // Xóa gạch chân vàng
  );

  static const TextStyle loadingTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.brown,
    decoration: TextDecoration.none,
  );
  
  static const TextStyle toastTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    decoration: TextDecoration.none,
  );
}
