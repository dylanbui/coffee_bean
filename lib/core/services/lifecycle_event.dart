import 'package:flutter/material.dart';
import 'package:coffee_bean/core/services/event_bus.dart';

/// Sự kiện thay đổi trạng thái vòng đời của ứng dụng
class AppLifecycleChangedEvent extends DbBaseEvent {
  final AppLifecycleState state;

  AppLifecycleChangedEvent(this.state);

  // Các hàm helper để check nhanh trạng thái trong Interactor
  bool get isResumed => state == AppLifecycleState.resumed;
  bool get isInactive => state == AppLifecycleState.inactive;
  bool get isPaused => state == AppLifecycleState.paused;
  bool get isDetached => state == AppLifecycleState.detached;
  bool get isHidden => state == AppLifecycleState.hidden;

  @override
  String toString() => 'AppLifecycleChangedEvent: ${state.name}';
}
