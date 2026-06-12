import 'dart:async';

import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
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
  final UserSession? session;
  final UserInfo? userInfo;
  MyProfileState({this.isLoggedIn = false, this.isCheckedIn = false, this.session, this.userInfo});

  @override
  List<Object?> get props => [isLoggedIn, isCheckedIn, session, userInfo];
}

class MyProfileInitial extends MyProfileState {
  MyProfileInitial() : super(isLoggedIn: false, isCheckedIn: false, session: null, userInfo: null);
}

class MyProfileLoaded extends MyProfileState {
  MyProfileLoaded({required super.isLoggedIn, super.isCheckedIn, super.session, super.userInfo});
}

class MyProfileInteractor extends CubitInteractor<MyProfileRoutable, MyProfileState> implements UserAuthFlowListener {
  final _authRepo = AuthRepository();

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
    emit(MyProfileLoaded(
      isLoggedIn: UserManager().isLogin,
      isCheckedIn: state.isCheckedIn,
      session: UserManager().currentUser,
      userInfo: UserManager().userInfo,
    ));
  }

  void checkIn() {
    // Toggle trạng thái: nếu đã check thì uncheck, nếu chưa thì check.
    emit(MyProfileLoaded(
      isLoggedIn: state.isLoggedIn,
      isCheckedIn: !state.isCheckedIn,
      session: state.session,
      userInfo: state.userInfo,
    ));
  }

  void doLogout() async {
    // Gọi API logout của server
    await _authRepo.logout();
    
    // Xóa sạch dữ liệu local
    await UserManager().doLogoutAndClearAll();
    
    // Bắn event logout cho toàn hệ thống
    locator<DbEventBus>().fire(UserLogoutEvent());

    router?.doLogout();
  }

// --- UserAuthFlowListener ---


  @override
  void onAuthFlowSuccess(UserSession userData) {
    debugPrint("Auth Flow Success - Reload Profile Data");
    // Chỉ cần bắn event. Listener trong onDidBecomeActive sẽ tự động gọi checkLoginStatus()
    locator<DbEventBus>().fire(UserLoginSuccessEvent(userData));
  }

  @override
  void onAuthFlowCancelled(DbError error) {
    debugPrint("Auth Flow Cancelled: ${error.message}");
  }

}
