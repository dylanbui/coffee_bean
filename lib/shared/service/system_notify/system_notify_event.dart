/*
 * Created with Android Studio
 * User: dylanbui
 * Description: Hệ thống thông báo toàn cục qua EventBus.
 * Hỗ trợ hiển thị Toast/Dialog từ Interactor mà không cần context.
 *
 * Cách sử dụng:
 * 1. Toast Success:  locator<DbEventBus>().fire(SystemSuccessNotifyEvent("Message"));
 * 2. Toast Error:    locator<DbEventBus>().fire(SystemErrorNotifyEvent("Error message"));
 * 3. Dialog Info:     locator<DbEventBus>().fire(SystemNotifyDialogEvent("Dialog message"));
 * 4. i18n:           locator<DbEventBus>().fire(SystemSuccessNotifyEvent("key", arguments: {"id": 1}));
 *
 * Lưu ý: Logic hiển thị thực tế nằm tại _AppNotifyMixin trong app.dart
 */

import 'package:db_core/services/event_bus.dart';

/// Định nghĩa các loại thông báo hệ thống
enum SystemNotifyType { success, error, warning, info }

/// Sự kiện thông báo hệ thống gốc (Toast/Dialog)
class SystemNotifyEvent extends DbBaseEvent {
  final String messageKey;      // Có thể là chuỗi hiển thị trực tiếp hoặc i18n key
  final SystemNotifyType type;
  final bool isToast;           // true: Hiển thị Toast, false: Hiển thị Dialog
  final Map<String, dynamic>? arguments; // Tham số cho đa ngôn ngữ (nếu có)

  SystemNotifyEvent({
    required this.messageKey,
    this.type = SystemNotifyType.info,
    this.isToast = true,
    this.arguments,
  });
}

// --- CÁC EVENT TIỆN ÍCH (Sử dụng nhanh) ---

/// Thông báo thành công (Toast)
class SystemSuccessNotifyEvent extends SystemNotifyEvent {
  SystemSuccessNotifyEvent(String message, {super.arguments})
      : super(messageKey: message, type: SystemNotifyType.success);
}

/// Thông báo lỗi (Toast)
class SystemErrorNotifyEvent extends SystemNotifyEvent {
  SystemErrorNotifyEvent(String message, {super.arguments})
      : super(messageKey: message, type: SystemNotifyType.error);
}

/// Thông báo cảnh báo (Toast)
class SystemWarningNotifyEvent extends SystemNotifyEvent {
  SystemWarningNotifyEvent(String message, {super.arguments})
      : super(messageKey: message, type: SystemNotifyType.warning);
}

/// Thông báo thông tin (Toast)
class SystemInfoNotifyEvent extends SystemNotifyEvent {
  SystemInfoNotifyEvent(String message, {super.arguments})
      : super(messageKey: message, type: SystemNotifyType.info);
}

/// Hiển thị Dialog (Mặc định là Info)
class SystemNotifyDialogEvent extends SystemNotifyEvent {
  SystemNotifyDialogEvent(String message, {super.type = SystemNotifyType.info, super.arguments})
      : super(messageKey: message, isToast: false);
}
