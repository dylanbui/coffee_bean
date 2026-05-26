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
typedef FlashDialogHelper = DbFlashDialogHelper;
typedef FlashDialogAction<T> = DbFlashDialogAction<T>;
typedef FlashDialogType = DbFlashDialogType;
typedef FlashDialogStyle = DbFlashDialogStyle;

/*
  // --- CÁCH SỬ DỤNG TRONG PROJECT COFFEE BEAN ---

  // 1. Hiện thông báo đơn giản (Sử dụng Shorthand)
  FlashDialogHelper.success(context, "Đã lưu thành công!");

  // 2. Hiện xác nhận (Confirm) và đợi kết quả
  final res = await FlashDialogHelper.show<bool>(
    context: context,
    title: "Xác nhận",
    content: "Bạn có chắc muốn đăng xuất?",
    actions: [
      FlashDialogAction(label: "Hủy", value: false, color: Colors.grey),
      FlashDialogAction(label: "Đăng xuất", value: true, color: Colors.red),
    ],
  );

  // 3. Hiện Dialog kèm Body (Form nhập liệu)
  void _showNoteForm(BuildContext context) {
    FlashDialogHelper.show(
      context: context,
      title: "Ghi chú",
      content: "Nhập lời nhắn cho tài xế",
      body: TextField(decoration: InputDecoration(hintText: "Nhập tại đây...")),
      actions: [
        FlashDialogAction(label: "Gửi", value: "ok"),
      ],
    );
  }
*/
