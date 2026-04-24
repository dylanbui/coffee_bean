import 'dart:async';
import 'package:coffee_bean/commons/utils/locator.dart';

/// Lớp cha cho tất cả các Event trong hệ thống
abstract class DbBaseEvent {
  final DateTime timestamp;
  DbBaseEvent() : timestamp = DateTime.now();
}

class DbEventBus implements DbLocatorDisposable {
  // Sử dụng .broadcast() để nhiều RIBs có thể cùng lắng nghe
  final _controller = StreamController<DbBaseEvent>.broadcast();
  
  // Lưu trữ lịch sử các event (danh sách các event trước đó)
  final List<DbBaseEvent> _history = [];
  final int _maxHistoryLimit = 50;

  /// Gửi một event lên hệ thống
  void fire(DbBaseEvent event) {
    _history.add(event);
    if (_history.length > _maxHistoryLimit) {
      _history.removeAt(0);
    }
    _controller.add(event);
  }

  /// Lắng nghe các event theo một kiểu cụ thể (T)
  /// Ví dụ: locator<DbEventBus>().on<ProductAddedEvent>().listen(...)
  Stream<T> on<T extends DbBaseEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  /// Truy vấn lịch sử các event theo kiểu dữ liệu
  List<T> getHistoryOf<T extends DbBaseEvent>() {
    return _history.whereType<T>().toList();
  }

  @override
  void dispose() {
    _controller.close();
  }
}
