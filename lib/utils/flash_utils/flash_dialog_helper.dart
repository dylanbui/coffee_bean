/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 23:05
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:flash/flash.dart';

/// **************************************************************************
/// FLASH DIALOG HELPER
/// Author: Gemini / Coffee Bean Project
/// Description: Hỗ trợ hiển thị Dialog thông báo, xác nhận và Form nhập liệu.
/// **************************************************************************

/// Cấu hình chi tiết cho Text nếu cần tùy chỉnh sâu (Bold, Color, Italic...)
class FlashTextConfig {
    final String text;
    final double? fontSize;
    final FontWeight? fontWeight;
    final Color? color;
    final FontStyle? fontStyle;
    final TextDecoration? decoration;

    FlashTextConfig({
        required this.text,
        this.fontSize,
        this.fontWeight,
        this.color,
        this.fontStyle,
        this.decoration,
    });

    TextStyle get style => TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        decoration: decoration,
    );
}

/// Cấu hình cho các nút bấm trong Dialog
class FlashDialogAction<T> {
    final String label;
    final T value; // Giá trị trả về khi đóng dialog (ví dụ: 1, 2 hoặc 'submit', 'cancel')
    final Color color;
    final VoidCallback? onPressed;

    FlashDialogAction({
        required this.label,
        required this.value,
        this.color = Colors.blue,
        this.onPressed,
    });
}

class FlashDialogHelper {
    /// Hàm gốc đầy đủ tùy biến (Core Function)
    static Future<T?> show<T>({
        required BuildContext context,
        required String title,
        required String content,
        List<FlashDialogAction<T>>? actions,
        FlashTextConfig? titleConfig,
        FlashTextConfig? contentConfig,
        Widget? body, // Chèn thêm Form/UI custom vào giữa Title và Buttons
        Widget? icon,
        bool persistent = false,
    }) {
        // Mặc định nếu không truyền actions sẽ hiện 1 nút OK trả về null
        final List<FlashDialogAction<T>> finalActions = actions ?? [
            FlashDialogAction(label: "OK", value: null as T)
        ];

        return showFlash<T>(
            context: context,
            persistent: persistent,
            barrierColor: Colors.black54,
            barrierDismissible: true, // Chạm ra ngoài trả về null (Bỏ qua)
            builder: (context, controller) {
                return Flash(
                    controller: controller,
                    dismissDirections: const [FlashDismissDirection.vertical],
                    child: Center(
                        child: Padding(
                            // Xử lý đẩy Dialog lên khi hiện bàn phím (cho các Form nhập liệu)
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Material(
                                color: Colors.transparent,
                                child: Container(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                                    ),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Padding(
                                                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                                                child: Column(
                                                    children: [
                                                        if (icon != null) ...[icon, const SizedBox(height: 16)],
                                                        Text(
                                                            title,
                                                            style: titleConfig?.style ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                            textAlign: TextAlign.center,
                                                        ),
                                                        const SizedBox(height: 12),
                                                        Text(
                                                            content,
                                                            style: contentConfig?.style ?? const TextStyle(fontSize: 15, color: Colors.grey),
                                                            textAlign: TextAlign.center,
                                                        ),

                                                        // Slot dành cho Form (TextField, TextArea...)
                                                        if (body != null) ...[
                                                            const SizedBox(height: 20),
                                                            body,
                                                        ],
                                                    ],
                                                ),
                                            ),
                                            const Divider(height: 1, thickness: 0.5),

                                            // Tự động chuyển Row (1-2 nút) hoặc Column (3+ nút)
                                            finalActions.length > 2
                                                ? _buildVerticalButtons(controller, finalActions)
                                                : _buildHorizontalButtons(controller, finalActions),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    ),
                );
            },
        );
    }

    // --- Các hàm tiện ích rút gọn (Shorthands) ---

    static void info(BuildContext context, String msg) {
        show(context: context, title: "Thông báo", content: msg, icon: const Icon(Icons.info, color: Colors.blue, size: 36));
    }

    static void success(BuildContext context, String msg) {
        show(context: context, title: "Thành công", content: msg, icon: const Icon(Icons.check_circle, color: Colors.green, size: 36));
    }

    static void error(BuildContext context, String msg) {
        show(context: context, title: "Lỗi", content: msg, icon: const Icon(Icons.error, color: Colors.red, size: 36));
    }

    // --- Button Builders ---

    static Widget _buildHorizontalButtons<T>(FlashController<T> controller, List<FlashDialogAction<T>> actions) {
        return IntrinsicHeight(
            child: Row(
                children: List.generate(actions.length, (index) {
                    final action = actions[index];
                    return Expanded(
                        child: Row(
                            children: [
                                Expanded(
                                    child: TextButton(
                                        onPressed: () {
                                            if (action.onPressed != null) action.onPressed!();
                                            controller.dismiss(action.value);
                                        },
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 18),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(index == 0 ? 16 : 0),
                                                    bottomRight: Radius.circular(index == actions.length - 1 ? 16 : 0),
                                                ),
                                            ),
                                        ),
                                        child: Text(action.label, style: TextStyle(color: action.color, fontWeight: FontWeight.bold)),
                                    ),
                                ),
                                if (index < actions.length - 1) const VerticalDivider(width: 1, thickness: 0.5),
                            ],
                        ),
                    );
                }),
            ),
        );
    }

    static Widget _buildVerticalButtons<T>(FlashController<T> controller, List<FlashDialogAction<T>> actions) {
        return Column(
            children: List.generate(actions.length, (index) {
                final action = actions[index];
                return Column(
                    children: [
                        SizedBox(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () {
                                    if (action.onPressed != null) action.onPressed!();
                                    controller.dismiss(action.value);
                                },
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(index == actions.length - 1 ? 16 : 0),
                                            bottomRight: Radius.circular(index == actions.length - 1 ? 16 : 0),
                                        ),
                                    ),
                                ),
                                child: Text(action.label, style: TextStyle(color: action.color, fontWeight: FontWeight.bold)),
                            ),
                        ),
                        if (index < actions.length - 1) const Divider(height: 1, thickness: 0.5),
                    ],
                );
            }),
        );
    }
}

/// **************************************************************************
/// CÁCH SỬ DỤNG (EXAMPLES)
/// **************************************************************************

/*
  // 1. Dialog Form Nhập liệu (Tiêu đề + Textbox + TextArea)
  void _showFeedbackForm(BuildContext context) async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final result = await FlashDialog.show<String>(
      context: context,
      title: "Gửi ý kiến",
      content: "Vui lòng nhập thông tin phản hồi của bạn.",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tiêu đề:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Nhập tiêu đề...",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          const Text("Nội dung:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: contentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Nhập nội dung chi tiết...",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
      actions: [
        FlashDialogAction(label: "Gửi nội dung", value: "submit", color: Colors.brown),
      ],
    );

    if (result == "submit") {
      print("Tiêu đề: ${titleController.text}");
      print("Nội dung: ${contentController.text}");
    } else {
      print("User đã bỏ qua (result is null)");
    }
  }

  // 2. Xác nhận xóa (Xử lý kết quả trả về 1, 2 hoặc null)
  void _confirmDelete(BuildContext context) async {
    final res = await FlashDialog.show<int>(
      context: context,
      title: "Xác nhận xóa",
      content: "Dữ liệu này sẽ không thể khôi phục.",
      icon: const Icon(Icons.warning, color: Colors.orange, size: 40),
      actions: [
        FlashDialogAction(label: "Hủy", value: 1, color: Colors.grey),
        FlashDialogAction(label: "Xác nhận xóa", value: 2, color: Colors.red),
      ],
    );
    if (res == 2) { // Thực hiện xóa }
  }

  // 3. Thông báo nhanh (Shorthands)
  void _quickNotify(BuildContext context) {
    FlashDialog.success(context, "Đã lưu đơn hàng thành công!");
    FlashDialog.error(context, "Kết nối internet thất bại.");
  }
*/