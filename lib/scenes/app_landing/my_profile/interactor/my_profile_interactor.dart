import 'dart:async';

import 'package:coffee_bean/config/constants.dart';
import 'package:coffee_bean/core/services/event_bus.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_router.dart';
import 'package:coffee_bean/scenes/user_features/user_auth_flow.dart';
import 'package:flutter/cupertino.dart';

// States
abstract class MyProfileState extends BaseBlocState {
  final bool isLoggedIn;
  MyProfileState({this.isLoggedIn = false});

  @override
  List<Object?> get props => [isLoggedIn];
}

class MyProfileInitial extends MyProfileState {
  MyProfileInitial() : super(isLoggedIn: false);
}

class MyProfileLoaded extends MyProfileState {
  MyProfileLoaded({required super.isLoggedIn});
}

class MyProfileInteractor extends CubitInteractor<MyProfileRoutable, MyProfileState> implements UserAuthFlowListener {

  MyProfileInteractor(MyProfileRoutable router) : super(MyProfileInitial(), router: router);

  @override
  void onDidBecomeActive() async {
    super.onDidBecomeActive();
    await checkLoginStatus();

    // Lắng nghe sự kiện login thành công từ toàn hệ thống thông qua collect
    collect(locator<DbEventBus>().on<AuthEvent>().listen((event) {
      checkLoginStatus();
    }));
  }

  Future<void> checkLoginStatus() async {
    emit(MyProfileLoaded(isLoggedIn: UserManager().isLogin));
  }

  void doLogout() async {
    await UserManager().doLogoutAndClearAll();
    // Bắn event logout cho toàn hệ thống
    locator<DbEventBus>().fire(UserLogoutEvent());
    await checkLoginStatus();
    router?.doLogout();
  }

// --- UserAuthFlowListener ---

  @override
  void onAuthSuccess() {
    debugPrint("Auth Flow Success - Reload Profile Data");
    // Interactor có thể lắng nghe UserLoginSuccessEvent qua EventBus để cập nhật UI
    checkLoginStatus();

    // co the them thong ba de nhung thang khac update vi da login roi
    // locator<DbEventBus>().fire(UserLoginSuccessEvent());
  }

  @override
  void onAuthCancelled() {
    debugPrint("Auth Flow Cancelled");
  }

}
