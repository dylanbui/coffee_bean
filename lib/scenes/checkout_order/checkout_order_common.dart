import 'package:db_core/commons_constants.dart';
import 'package:flutter/material.dart';

abstract interface class CheckoutItemContract {
  String get title;         // Tên cửa hàng
  String get subTitle;      // Mô tả phụ (Thời gian, địa chỉ)
  String? get imageUrl;     // Ảnh đại diện
  double get baseAmount;    // Số tiền gốc

  // Dữ liệu cụ thể để gửi lên Backend
  String get category;      // "FOOD", "VENUE", v.v.
  Dictionary get extraData; 

  // Widget hiển thị chi tiết (Danh sách món, thông tin phòng)
  Widget? buildSummaryWidget(BuildContext context); 
}
