/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 17:15
 * Description: Quản lý Loading toàn cục, hỗ trợ cập nhật nội dung động qua ValueNotifier.
 */

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class DbLoading {
  static FlashController? _currentController;
  static bool _isShowing = false;

  // ValueNotifier dùng để cập nhật message mà không cần rebuild toàn bộ Modal
  static final ValueNotifier<String> _messageNotifier = ValueNotifier<String>("");

  /// Hiện Loading toàn cục
  static void show(
    BuildContext context, {
    String? message,
  }) {
    final msg = message ?? "Đang xử lý...";

    // Nếu đang hiển thị hoặc đang trong quá trình mở, chỉ cập nhật tin nhắn
    if (_isShowing || _currentController != null) {
      _messageNotifier.value = msg;
      return;
    }

    _isShowing = true;
    _messageNotifier.value = msg;

    showFlash(
      context: context,
      persistent: true,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (context, controller) {
        _currentController = controller;

        return Flash(
          controller: controller,
          child: PopScope(
            canPop: false,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.brown),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<String>(
                      valueListenable: _messageNotifier,
                      builder: (context, value, child) {
                        return Text(
                          value,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // Khi flash bị đóng (bằng bất cứ lý do gì), reset lại trạng thái
      _currentController = null;
      _isShowing = false;
    });
  }

  /// Đóng Loading
  static void dismiss() {
    _currentController?.dismiss();
    _currentController = null;
    _isShowing = false;
    _messageNotifier.value = "";
  }
}
