import 'package:flutter/material.dart';

// TODO: 2. Dọn dẹp AppColor (Legacy): 
// Sẽ dọn dẹp các màu rác, chỉ giữ lại những màu thực sự cần cho logic cũ (nếu có) 
// và khuyến khích chuyển sang TMLabsColor.
class AppColor {
  static const grayText = Color(0xFF5F5F5F);
  static const secondaryText = Color(0xFF363636);
  static const gray4A = Color(0xFF4A4A4A);
  static const gray44 = Color(0xFF444444);
  static const gray89 = Color(0xFF898989);
  static const grayD5 = Color(0xFFD5D5D5);
  static const grayD8 = Color(0xFFD8D8D8);
  static const grayD7 = Color(0xFFD7D7D7);
  static const gray7D = Color(0xFF7D7D7D);
  static const grayF0 = Color(0xFFF0F0F0);
  static const grayF4 = Color(0xFFF4F4F4);
  static const grayF5 = Color(0xFFF5F5F5);
  static const grayF9 = Color(0xFFF9F9F9);
  static const grayE4 = Color(0xFFE4E4E4);
  static const grayCC = Color(0xFFCCCCCC);
  static const grayBorderDE = Color(0xFFDEE1E2);
  static const grayC6 = Color(0xFFC6C6C8);
  static const gray55 = Color(0xFF555555);
  static const gray400 = Color(0xFFCED4DA);
  static const gray400_ibuy = Color(0xFF6A6D74);
  static const gray500 = Color(0xFFADB5BD);
  static const gray600 = Color(0xFF6C757D);
  static const propzyBlue = Color(0xFF155AA9);
  static const propzyBlue_100 = Color(0xFFE8EFF6);
  static const orangeDark = Color(0xFFF17423);
  static const red = Color(0xFFFF3B30);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const blackDefault = Color(0xFF242933);
  static const black_40p = Color(0x66000000);
  static const black_55p = Color(0x8C000000);
  static const black_65p = Color(0xA6000000);
  static const black_80p = Color(0xCC000000);
  static const rippleDark = Color(0x80B0B0B0);
  static const rippleLight = Color(0x80FFFFFF);
  static const blueLink = Color(0xFF0072EF);
  static const systemBlue = Color(0xFF007AFF);
  static const dividerGray = Color(0xFFDCDCDC);
  static const greenBackground = Color(0xFFE9F0E6);
  static const greenTextBadge = Color(0xFF46842F);
  static const propzyOrange = Color(0xFFEF7733);
  static const propzyBlue100 = Color(0xFFE8EFF6);
  static const green_iBuy = Color(0xFF248A3D);
  static const green_bg_time = Color(0xFFEDF9F4);

  // Basic Colors for Prototype
  static const basicBackground = Color(0xFFF8F8F8);
  static const basicSearchBg = Color(0xFFF2F2F2);
  static const basicPrimaryText = Color(0xFF333333);
  static const basicSecondaryText = Color(0xFF999999);
  static const basicPrice = Color(0xFFFF4D4F);
  static const basicAccent = Color(0xFF000000);
}

class TMLabsColor {
  // --- 1. BRAND COLORS (Màu thương hiệu) ---
  static const primary = Color(0xFF0E2040);     // Navy chủ đạo (Logo, Button chính, Header)
  static const secondary = Color(0xFF333951);   // Navy nhạt hơn (TabBar unselected, icon phụ)
  static const accent = Color(0xFFA6B5C5);      // Xanh xám (Nút Follow, Badge phụ)
  static const deepNavy = Color(0xFF091834);    // Navy đậm sâu (Vùng tối, Gradient)

  // --- 2. STATUS COLORS (Màu trạng thái) ---
  static const success = Color(0xFF2E7D32);     // Xanh lá (Thành công, tăng trưởng)
  static const error = Color(0xFFEF3A33);       // Đỏ (Lỗi, cảnh báo, giảm giá)
  static const warning = Color(0xFFFFA000);     // Cam/Vàng (Trạng thái chờ, lưu ý)

  // --- 3. NEUTRAL COLORS (Màu trung tính) ---
  static const white = Color(0xFFFFFFFF);       // Trắng (Nền chính, chữ trên nền tối)
  static const grey = Color(0xFF525556);        // Xám đậm (Văn bản phụ, mô tả)
  static const lightGrey = Color(0xFFCECCCD);   // Xám nhạt (Border, đường kẻ Divider)
  static const bgLight = Color(0xFFF2F2F2);     // Xám cực nhẹ (Nền item card, nền input)

  // --- 4. SPECIAL BACKGROUNDS (Màu nền đặc biệt) ---
  //static const bgMain = Color(0xFFF8F8F8);      // Nền xám nhạt toàn bộ ứng dụng
  static const bgMain = Color(0xFFEEEDEE);      // Nền xám nhạt toàn bộ ứng dụng
  static const bgSecond = Color(0xFFEEEDEE);      // Nền xám nhạt toàn bộ ứng dụng
  static const bgBeige = Color(0xFFF2EFED);     // Nền kem (Dành cho quà tặng, promo)
  static const bgTabbarWhile = Color(0xFFFFFFFF);     // Tabbar


  // --- 5. LEGACY/DECORATIVE (Màu trang trí khác từ thiết kế gốc) ---
  static const lightBlue = Color(0xFF9FB0C6);   // Xanh nhạt decor
  static const yellow = Color(0xFFFFCC85);      // Vàng nắng decor
  static const purple = Color(0xFFC9C0C9);      // Tím nhạt decor
  
  // Legacy alias for compatibility during transition
  static const navy = secondary;
  static const red = error;
}
