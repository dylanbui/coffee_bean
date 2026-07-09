import 'package:db_core/commons_constants.dart';
import 'package:flutter/material.dart';

abstract class CheckoutItemContract {
  String get title;         // Tên cửa hàng / Sản phẩm
  String get subTitle;      // Mô tả phụ (Thời gian, địa chỉ)
  String? get imageUrl;     // Ảnh đại diện
  double get baseAmount;    // Số tiền gốc

  // Dữ liệu cụ thể để gửi lên Backend
  String get category;      // "FOOD", "VENUE", v.v.
  Dictionary get extraData; 

  // Widget hiển thị chi tiết (Danh sách món, thông tin phòng)
  Widget? buildSummaryWidget(BuildContext context);

  // --- PHẦN MỞ RỘNG CHO OPTIONS (SHIP, FORM THÔNG TIN...) ---

  // Mặc định trả về null nếu không có tùy chọn bổ sung
  Widget? buildOptionsWidget(BuildContext context) => null;

  // Quản lý giá cộng thêm (Reactive)
  final ValueNotifier<double> totalOptionsAmountNotifier = ValueNotifier(0.0);
  
  // Quản lý trạng thái hợp lệ để đặt hàng (Mặc định là true)
  final ValueNotifier<bool> isValidNotifier = ValueNotifier(true);

  @mustCallSuper
  void dispose() {
    totalOptionsAmountNotifier.dispose();
    isValidNotifier.dispose();
  }
}
