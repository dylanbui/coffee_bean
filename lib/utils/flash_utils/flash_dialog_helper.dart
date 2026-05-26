/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 03:15
 * Description: Wrapper cho DbFlashDialogHelper để giữ tính tương thích trong project.
 */

import 'package:db_core/utils/flash_utils/flash_dialog_helper.dart';

/// Alias để sử dụng trong dự án Coffee Bean
// typedef FlashDialogHelper = DbFlashDialogHelper;
// typedef FlashDialogAction<T> = DbFlashDialogAction<T>;
// typedef FlashDialogType = DbFlashDialogType;
// typedef FlashDialogStyle = DbFlashDialogStyle;

/*
  // --- CÁCH SỬ DỤNG TRONG PROJECT ---

  // 1. Hiện thông báo đơn giản
  FlashDialogHelper.success(context, "Đã lưu thành công!");

  // 2. Hiện xác nhận (Confirm)
  final res = await FlashDialogHelper.show<bool>(
    context: context,
    title: "Xác nhận",
    content: "Bạn có chắc muốn đăng xuất?",
    actions: [
      FlashDialogAction(label: "Hủy", value: false, color: Colors.grey),
      FlashDialogAction(label: "Đăng xuất", value: true, color: Colors.red),
    ],
  );
*/
