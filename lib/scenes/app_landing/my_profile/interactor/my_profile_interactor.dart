import 'dart:async';

import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:flutter/cupertino.dart';

// States
abstract class MyProfileState extends BaseBlocState {
  final bool isLoggedIn;
  final bool isCheckedIn;
  MyProfileState({this.isLoggedIn = false, this.isCheckedIn = false});

  @override
  List<Object?> get props => [isLoggedIn, isCheckedIn];
}

class MyProfileInitial extends MyProfileState {
  MyProfileInitial() : super(isLoggedIn: false, isCheckedIn: false);
}

class MyProfileLoaded extends MyProfileState {
  MyProfileLoaded({required super.isLoggedIn, super.isCheckedIn});
}

class MyProfileInteractor extends CubitInteractor<MyProfileRoutable, MyProfileState> implements UserAuthFlowListener {

  MyProfileInteractor(MyProfileRoutable router) : super(MyProfileInitial(), router: router);

  @override
  void onDidBecomeActive() async {
    super.onDidBecomeActive();
    await checkLoginStatus();

    // Lắng nghe sự kiện login thành công từ toàn hệ thống thông qua collect
    collect(locator<DbEventBus>().on<UserAuthEvent>().listen((event) {
      checkLoginStatus();
    }));
  }

  Future<void> checkLoginStatus() async {
    emit(MyProfileLoaded(isLoggedIn: UserManager().isLogin, isCheckedIn: state.isCheckedIn));
  }

  void checkIn() {
    // Toggle trạng thái: nếu đã check thì uncheck, nếu chưa thì check.
    emit(MyProfileLoaded(isLoggedIn: state.isLoggedIn, isCheckedIn: !state.isCheckedIn));
  }

  void doLogout() async {
    await UserManager().doLogoutAndClearAll();
    // Bắn event logout cho toàn hệ thống.
    // Listener AuthEvent sẽ tự động gọi checkLoginStatus() để cập nhật UI.
    locator<DbEventBus>().fire(UserLogoutEvent());

    router?.doLogout();
  }

// --- UserAuthFlowListener ---


  @override
  void onAuthFlowSuccess(UserSession userData) {
    debugPrint("Auth Flow Success - Reload Profile Data");
    // Chỉ cần bắn event. Listener trong onDidBecomeActive sẽ tự động gọi checkLoginStatus()
    // Điều này tránh việc checkLoginStatus() bị chạy 2 lần.
    locator<DbEventBus>().fire(UserLoginSuccessEvent(userData));
  }

  @override
  void onAuthFlowCancelled(DbError error) {
    debugPrint("Auth Flow Cancelled: ${error.message}");
  }

}
