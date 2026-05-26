/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 23:17
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/utils/flash_utils/flash_image_helper.dart';
import 'package:db_core/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/utils/flash_utils/flash_toast_helper.dart';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/utils/flash_utils/flash_modal_helper.dart';

/// **************************************************************************
/// FLASH EXTENSION
/// Author: Gemini / Coffee Bean Project
/// Description: Cung cấp cú pháp ngắn gọn (Syntactic Sugar) để gọi Modal và Dialog
/// từ bất kỳ đâu có BuildContext.
/// **************************************************************************

extension FlashExtension on BuildContext {

    // ===========================================================================
    // 1. QUICK TOASTS / SNACKBARS (Sử dụng FlashToastHelper)
    // ===========================================================================

    /// Hiển thị Top SnackBar Success
    void showFlashSuccess(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 2)})
        => DbFlashToastHelper.success(this, message, title: title, position: position, duration: duration);

    /// Hiển thị Top SnackBar Error
    void showFlashError(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 3)}) 
        => DbFlashToastHelper.error(this, message, title: title, position: position, duration: duration);

    /// Hiển thị Top SnackBar Info
    void showFlashInfo(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 2)}) 
        => DbFlashToastHelper.info(this, message, title: title, position: position, duration: duration);

    /// Hiển thị Top SnackBar Warning
    void showFlashWarning(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 2)})
        => DbFlashToastHelper.warning(this, message, title: title, position: position, duration: duration);

    // ===========================================================================
    // 2. QUICK DIALOGS (Sử dụng FlashDialogHelper)
    // ===========================================================================

    /// Hiển thị Dialog xác nhận hoặc Form tùy biến
    /// Trả về kết quả kiểu [T]
    Future<T?> showFlashConfirm<T>({
        required String title,
        required String content,
        List<DbFlashDialogAction<T>>? actions,
        Widget? icon,
        Widget? body,
        bool persistent = false,
    }) {
        return DbFlashDialogHelper.show<T>(
            context: this,
            title: title,
            content: content,
            actions: actions,
            icon: icon,
            body: body,
            persistent: persistent,
        );
    }

    // ===========================================================================
    // 3. QUICK MODALS (Sử dụng FlashModalHelper)
    // ===========================================================================

    /// Hiển thị Bottom hoặc Top Modal lửng (Custom Size)
    /// Trả về kết quả kiểu [T]
    Future<T?> showFlashModal<T>({
        required String title,
        required Widget child,
        List<Widget>? actions,
        FlashModalPosition position = FlashModalPosition.bottom,
        FlashFooterLayout footerLayout = FlashFooterLayout.row,
        double maxHeightThreshold = 0.7,
    }) {
        return FlashModalHelper.showSmartModal<T>(
            context: this,
            title: title,
            child: child,
            actions: actions,
            position: position,
            footerLayout: footerLayout,
            maxHeightThreshold: maxHeightThreshold,
        );
    }

    /// Xem ảnh sản phẩm Coffee Bean
    void showPhotoGallery({required List<String> urls, int index = 0, String? heroPrefix}) {
        FlashImageHelper.showGallery(
            context: this,
            imageUrls: urls,
            initialIndex: index,
            heroTagPrefix: heroPrefix,
        );
    }

}

/// **************************************************************************
/// CÁCH SỬ DỤNG (EXAMPLES)
/// **************************************************************************

/*
  // --- Với Toast / SnackBar ---

  void _testToast(BuildContext context) {
    // 1. Hiện thông báo nhanh ở Top
    context.showFlashSuccess("Đã cập nhật đơn hàng thành công!");
    context.showFlashError("Máy chủ đang bận, vui lòng thử lại.", title: "Lỗi kết nối");
  }

  // --- Với Dialog ---

    // 2. Hiện xác nhận xóa và đợi kết quả
    context.showFlashConfirm<bool>(
      title: "Xác nhận",
      content: "Bạn có muốn xóa không?",
      actions: [
        FlashDialogAction(label: "Hủy", value: false, color: Colors.grey),
        FlashDialogAction(label: "Xóa", value: true, color: Colors.red),
      ],
    ).then((isDelete) {
      if (isDelete == true) { // Xử lý xóa }
    });
  }

  // --- Với Modal ---

  void _testModal(BuildContext context) {
    context.showFlashModal<String>(
      title: "Chọn chi nhánh Coffee Bean",
      position: FlashModalPosition.bottom,
      child: MyStoreListWidget(), // Một ListView danh sách chi nhánh
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, "Hồ Chí Minh"),
          child: Text("Chọn HCM mặc định"),
        ),
      ],
    ).then((city) {
      if (city != null) print("Bạn chọn: $city");
    });
  }

  // --- Show photos ---
  void _onViewFeedbackImages(List<String> images, int clickedIndex) {
  context.showPhotoGallery(
    urls: images,
    index: clickedIndex,
    heroPrefix: "feedback_item", // Tạo hiệu ứng mượt khi mở
  );
}

*/