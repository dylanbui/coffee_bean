import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/services/event_bus.dart';

/// Event khi thông tin cá nhân của người dùng được cập nhật
class UserInfoUpdatedEvent extends DbBaseEvent {
  final UserInfo userInfo;
  UserInfoUpdatedEvent(this.userInfo);
}
