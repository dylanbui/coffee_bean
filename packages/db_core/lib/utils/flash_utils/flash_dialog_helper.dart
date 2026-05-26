/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 03:00
 * Description: Base Utility hỗ trợ hiển thị Dialog thông báo, xác nhận và Form nhập liệu.
 * Sử dụng thư viện flash: ^3.1.1. Thiết kế để dùng chung trong db_core.
 */

import 'package:flutter/material.dart';
import 'package:flash/flash.dart';

/// Phân loại Dialog cơ bản
enum DbFlashDialogType { info, success, error, warning }

/// Lớp cấu hình giao diện linh hoạt cho Dialog
class DbFlashDialogStyle {
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final Color primaryActionColor;
  final double borderRadius;
  final EdgeInsets padding;
  final Color barrierColor;

  const DbFlashDialogStyle({
    this.titleStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.contentStyle = const TextStyle(fontSize: 15, color: Colors.grey),
    this.primaryActionColor = Colors.blue,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.fromLTRB(24, 24, 24, 20),
    this.barrierColor = Colors.black54,
  });
}

/// Cấu hình cho các nút bấm trong Dialog
class DbFlashDialogAction<T> {
  final String label;
  final T value;
  final Color? color;
  final VoidCallback? onPressed;

  const DbFlashDialogAction({
    required this.label,
    required this.value,
    this.color,
    this.onPressed,
  });
}

/// Provider để dự án cụ thể định nghĩa style và icon/màu cho từng loại Dialog
abstract class DbFlashDialogStyleProvider {
  DbFlashDialogStyle getStyle();
  Widget? getIcon(DbFlashDialogType type);
  String getDefaultTitle(DbFlashDialogType type);
}

class DbFlashDialogHelper {
  static DbFlashDialogStyleProvider? _styleProvider;

  static void init(DbFlashDialogStyleProvider provider) {
    _styleProvider = provider;
  }

  /// Hàm gốc đầy đủ tùy biến (Core Function)
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    List<DbFlashDialogAction<T>>? actions,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    Widget? body,
    Widget? icon,
    bool persistent = true, // Chuyển mặc định sang true để tránh lỗi rootOverlay
    bool barrierDismissible = true,
  }) {
    final style = _styleProvider?.getStyle() ?? const DbFlashDialogStyle();
    
    final List<DbFlashDialogAction<T>> finalActions = actions ?? [
      DbFlashDialogAction(label: "OK", value: null as T)
    ];

    return showFlash<T>(
      context: context,
      persistent: persistent,
      barrierColor: style.barrierColor,
      barrierDismissible: barrierDismissible,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          dismissDirections: const [FlashDismissDirection.vertical],
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(style.borderRadius),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: style.padding,
                        child: Column(
                          children: [
                            if (icon != null) ...[icon, const SizedBox(height: 16)],
                            Text(
                              title,
                              style: titleStyle ?? style.titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              content,
                              style: contentStyle ?? style.contentStyle,
                              textAlign: TextAlign.center,
                            ),
                            if (body != null) ...[
                              const SizedBox(height: 20),
                              body,
                            ],
                          ],
                        ),
                      ),
                      const Divider(height: 1, thickness: 0.5),
                      finalActions.length > 2
                          ? _buildVerticalButtons(controller, finalActions, style)
                          : _buildHorizontalButtons(controller, finalActions, style),
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

  // --- Shorthands ---

  static void info(BuildContext context, String msg, {String? title, bool persistent = true}) {
    final t = title ?? _styleProvider?.getDefaultTitle(DbFlashDialogType.info) ?? "Thông báo";
    show(context: context, title: t, content: msg, icon: _styleProvider?.getIcon(DbFlashDialogType.info), persistent: persistent);
  }

  static void success(BuildContext context, String msg, {String? title, bool persistent = true}) {
    final t = title ?? _styleProvider?.getDefaultTitle(DbFlashDialogType.success) ?? "Thành công";
    show(context: context, title: t, content: msg, icon: _styleProvider?.getIcon(DbFlashDialogType.success), persistent: persistent);
  }

  static void error(BuildContext context, String msg, {String? title, bool persistent = true}) {
    final t = title ?? _styleProvider?.getDefaultTitle(DbFlashDialogType.error) ?? "Lỗi";
    show(context: context, title: t, content: msg, icon: _styleProvider?.getIcon(DbFlashDialogType.error), persistent: persistent);
  }

  static void warning(BuildContext context, String msg, {String? title, bool persistent = true}) {
    final t = title ?? _styleProvider?.getDefaultTitle(DbFlashDialogType.warning) ?? "Cảnh báo";
    show(context: context, title: t, content: msg, icon: _styleProvider?.getIcon(DbFlashDialogType.warning), persistent: persistent);
  }

  // --- Button Builders ---

  static Widget _buildHorizontalButtons<T>(FlashController<T> controller, List<DbFlashDialogAction<T>> actions, DbFlashDialogStyle style) {
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
                          bottomLeft: Radius.circular(index == 0 ? style.borderRadius : 0),
                          bottomRight: Radius.circular(index == actions.length - 1 ? style.borderRadius : 0),
                        ),
                      ),
                    ),
                    child: Text(
                      action.label,
                      style: TextStyle(
                        color: action.color ?? style.primaryActionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

  static Widget _buildVerticalButtons<T>(FlashController<T> controller, List<DbFlashDialogAction<T>> actions, DbFlashDialogStyle style) {
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
                      bottomLeft: Radius.circular(index == actions.length - 1 ? style.borderRadius : 0),
                      bottomRight: Radius.circular(index == actions.length - 1 ? style.borderRadius : 0),
                    ),
                  ),
                ),
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: action.color ?? style.primaryActionColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (index < actions.length - 1) const Divider(height: 1, thickness: 0.5),
          ],
        );
      }),
    );
  }
}
