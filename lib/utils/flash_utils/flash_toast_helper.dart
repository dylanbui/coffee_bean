/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 02:10
 * Description: Wrapper cho DbFlashToastHelper để giữ tính tương thích trong project.
 */

import 'package:db_core/utils/flash_utils/flash_toast_helper.dart';

/// Alias để sử dụng trong dự án Coffee Bean
typedef FlashToastHelper = DbFlashToastHelper;
typedef FlashToastType = DbFlashToastType;
typedef FlashToastStyle = DbFlashToastStyle;

/*
  // --- CÁCH SỬ DỤNG TRONG PROJECT COFFEE BEAN ---

  // 1. Hiện thông báo nhanh ở Top (Mặc định)
  FlashToastHelper.success(context, "Đã cập nhật đơn hàng thành công!");

  // 2. Hiện lỗi với tiêu đề và thời gian hiển thị lâu hơn
  FlashToastHelper.error(
    context, 
    "Máy chủ đang bận, vui lòng thử lại.", 
    title: "Lỗi kết nối",
    duration: Duration(seconds: 5),
  );

  // 3. Hiện thông báo ở phía dưới (Bottom)
  FlashToastHelper.info(
    context, 
    "Bạn có tin nhắn mới", 
    position: FlashPosition.bottom
  );
*/
