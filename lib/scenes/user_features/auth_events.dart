import 'package:db_core/services/event_bus.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';

/// Lớp cha cho tất cả các Event về Auth
abstract class AuthEvent extends DbBaseEvent {}

/// Event khi người dùng đăng nhập thành công
class UserLoginSuccessEvent extends AuthEvent {
  final UserSession userSessionData;
  UserLoginSuccessEvent(this.userSessionData);
}

/// Event khi người dùng đăng xuất
class UserLogoutEvent extends AuthEvent {}

/// Event khi người dùng hủy bỏ quá trình đăng nhập (đóng modal)
class UserLoginCancelledEvent extends AuthEvent {}

/// Event khi đăng nhập thất bại
class UserLoginFailureEvent extends AuthEvent {
  final String message;
  UserLoginFailureEvent(this.message);
}
