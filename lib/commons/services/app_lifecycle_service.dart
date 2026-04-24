import 'package:flutter/material.dart';
import 'package:coffee_bean/commons/services/event_bus.dart';
import 'package:coffee_bean/commons/services/lifecycle_event.dart';
import 'package:coffee_bean/commons/utils/locator.dart';

class AppLifecycleService extends WidgetsBindingObserver implements DbLocatorDisposable {
  final DbEventBus _eventBus;
  
  // Lưu trạng thái hiện tại để truy cập nhanh (Sync)
  AppLifecycleState _currentState = AppLifecycleState.resumed;
  AppLifecycleState get currentState => _currentState;

  AppLifecycleService(this._eventBus) {
    // Đăng ký quan sát vòng đời app từ Flutter Engine
    WidgetsBinding.instance.addObserver(this);
    // Lấy trạng thái khởi tạo hiện tại từ hệ thống
    _currentState = WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _currentState = state;
    // Bắn event qua EventBus cho toàn hệ thống
    _eventBus.fire(AppLifecycleChangedEvent(state));
  }

  @override
  void dispose() {
    // Hủy đăng ký khi service bị hủy
    WidgetsBinding.instance.removeObserver(this);
  }
}
