import 'dart:async';
import 'package:flutter/material.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/architecture_ribs/navigator.dart';
import 'package:db_core/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:coffee_bean/shared/ui/flash_dialog_provider.dart';
import 'package:easy_localization/easy_localization.dart';

mixin AppNotifyMixin<T extends StatefulWidget> on State<T> {
  late StreamSubscription _subNotify;
  final List<SystemNotifyEvent> _notifyQueue = [];
  bool _isProcessing = false;
  
  // Giới hạn hàng đợi để tránh "Stale Errors" (Lỗi cũ chồng chéo)
  final int _maxQueueSize = 3;

  void initNotifyLogic() {
    _subNotify = locator<DbEventBus>().on<SystemNotifyEvent>().listen((event) {
      _enqueueNotify(event);
    });
  }

  void disposeNotifyLogic() {
    _subNotify.cancel();
  }

  void _enqueueNotify(SystemNotifyEvent event) {
    // 1. "Deduplication": Chặn thông báo trùng lặp liên tiếp
    if (_notifyQueue.isNotEmpty && _notifyQueue.last.messageKey == event.messageKey) {
      return;
    }

    // 2. Kiểm tra giới hạn hàng đợi
    if (_notifyQueue.length >= _maxQueueSize) {
      _notifyQueue.removeAt(0); 
    }

    _notifyQueue.add(event);
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isProcessing || _notifyQueue.isEmpty) return;

    _isProcessing = true;

    while (_notifyQueue.isNotEmpty) {
      final event = _notifyQueue.removeAt(0);
      
      _showUI(event);

      // Đợi một khoảng thời gian đủ để người dùng kịp đọc trước khi hiện cái tiếp theo
      // Thường Toast tồn tại khoảng 2s, nên delay 2.2s là hợp lý
      await Future.delayed(const Duration(milliseconds: 2200));
    }

    _isProcessing = false;
  }

  void _showUI(SystemNotifyEvent event) {
    final context = DbNavigator.globalNavigatorState.currentContext;
    if (context == null) return;

    final String displayMessageRaw = event.messageKey;

    // Sử dụng .tr() từ easy_localization để dịch messageKey
    final String displayMessage = displayMessageRaw.tr(
      namedArgs: event.arguments?.map((k, v) => MapEntry(k, v.toString())),
    );

    if (event.isToast) {
      final type = DbFlashToastType.values.byName(event.type.name);
      DbFlashToastHelper.showSnackBar(context, message: displayMessage, type: type);
    } else {
      final type = DbFlashDialogType.values.byName(event.type.name);
      DbFlashDialogHelper.show(
        context: context, 
        title: displayMessage, // Hoặc title tùy chọn
        icon: TMLabsDialogStyleProvider().getIcon(type),
      );
    }
  }
}
