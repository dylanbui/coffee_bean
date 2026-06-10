import 'package:flutter/material.dart';
import 'package:db_core/db_core.dart';

/// Mixin xử lý việc tự động bỏ focus (unfocus) khi bàn phím bị ẩn đi.
/// Sử dụng "on WidgetsBindingObserver" để tận dụng các hàm mặc định của Flutter.
mixin KeyboardUnfocusMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  double _lastBottomInset = 0;

  /// Tự động remove focus khi bàn phím đóng lại.
  /// Mặc định là true, các màn hình con có thể override để tắt.
  bool get unfocusOnHide => true;

  @override
  void initState() {
    super.initState();
    if (unfocusOnHide) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    if (unfocusOnHide) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (!unfocusOnHide || !mounted) return;

    final view = View.of(context);
    final currentBottomInset = view.viewInsets.bottom;

    // Chỉ kích hoạt unfocus nếu bàn phím đang mở (_lastBottomInset > 0) 
    // và hiện tại đã đóng hoàn toàn (currentBottomInset == 0).
    if (_lastBottomInset > 0 && currentBottomInset == 0) {
      iLog('⌨️ Keyboard closed → Unfocusing triggered for: ${widget.runtimeType}');
      FocusManager.instance.primaryFocus?.unfocus();
    }

    _lastBottomInset = currentBottomInset;
  }
}
