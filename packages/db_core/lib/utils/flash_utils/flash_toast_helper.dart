/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 02:00
 * Description: Base Utility hỗ trợ hiển thị SnackBar/Toast sử dụng thư viện flash: ^3.1.1
 * Được thiết kế để dùng chung trong db_core.
 */

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

/// Phân loại Toast/SnackBar cơ bản
enum DbFlashToastType { success, error, info, warning }

/// Lớp cấu hình giao diện linh hoạt (Base Model)
class DbFlashToastStyle {
  final Color backgroundColor;
  final IconData iconData;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final Color iconColor;

  const DbFlashToastStyle({
    required this.backgroundColor,
    required this.iconData,
    this.titleStyle,
    this.messageStyle,
    this.iconColor = Colors.white,
  });
}

/// Abstract Provider để dự án cụ thể định nghĩa style riêng
abstract class DbFlashToastStyleProvider {
  DbFlashToastStyle getStyle(DbFlashToastType type);
}

/// Base Class Utility - Nằm trong db_core
class DbFlashToastHelper {
  static DbFlashToastStyleProvider? _styleProvider;

  /// Cấu hình Style Provider một lần duy nhất ở cấp dự án
  static void init(DbFlashToastStyleProvider provider) {
    _styleProvider = provider;
  }

  /// Hàm core hiển thị SnackBar
  static void showSnackBar(
    BuildContext context, {
    required String message,
    String? title,
    DbFlashToastStyle? customStyle,
    DbFlashToastType type = DbFlashToastType.info,
    FlashPosition position = FlashPosition.top,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    // Ưu tiên: Custom Style > Provider Style > Default Fallback Style
    final DbFlashToastStyle style = customStyle ?? 
        _styleProvider?.getStyle(type) ?? 
        _getDefaultFallbackStyle(type);

    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          position: position,
          dismissDirections: const [FlashDismissDirection.vertical],
          child: Align(
            alignment: position == FlashPosition.top ? Alignment.topCenter : Alignment.bottomCenter,
            child: SafeArea(
              top: position == FlashPosition.top,
              bottom: position == FlashPosition.bottom,
              child: GestureDetector(
                onTap: () {
                  if (onTap != null) onTap();
                  controller.dismiss();
                },
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: style.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(style.iconData, color: style.iconColor, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null)
                              Text(
                                title,
                                style: style.titleStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            Text(
                              message,
                              style: style.messageStyle ?? const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                        onPressed: () => controller.dismiss(),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Helper Methods ---

  static void success(BuildContext context, String message, {String? title, FlashPosition position = FlashPosition.top, Duration? duration}) =>
      showSnackBar(context, message: message, title: title, type: DbFlashToastType.success, position: position, duration: duration ?? const Duration(seconds: 3));

  static void error(BuildContext context, String message, {String? title, FlashPosition position = FlashPosition.top, Duration? duration}) =>
      showSnackBar(context, message: message, title: title, type: DbFlashToastType.error, position: position, duration: duration ?? const Duration(seconds: 3));

  static void info(BuildContext context, String message, {String? title, FlashPosition position = FlashPosition.top, Duration? duration}) =>
      showSnackBar(context, message: message, title: title, type: DbFlashToastType.info, position: position, duration: duration ?? const Duration(seconds: 3));

  static void warning(BuildContext context, String message, {String? title, FlashPosition position = FlashPosition.top, Duration? duration}) =>
      showSnackBar(context, message: message, title: title, type: DbFlashToastType.warning, position: position, duration: duration ?? const Duration(seconds: 3));

  /// Fallback style cơ bản nếu dự án không cung cấp Provider
  static DbFlashToastStyle _getDefaultFallbackStyle(DbFlashToastType type) {
    switch (type) {
      case DbFlashToastType.success: return const DbFlashToastStyle(backgroundColor: Colors.green, iconData: Icons.check);
      case DbFlashToastType.error: return const DbFlashToastStyle(backgroundColor: Colors.red, iconData: Icons.error);
      case DbFlashToastType.warning: return const DbFlashToastStyle(backgroundColor: Colors.orange, iconData: Icons.warning);
      case DbFlashToastType.info: return const DbFlashToastStyle(backgroundColor: Colors.blue, iconData: Icons.info);
    }
  }
}
