import 'dart:async';

import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager_events.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/my_profile_features/my_profile/my_profile_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:coffee_bean/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';

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
  final _userRepo = UserRepository();

  MyProfileInteractor(MyProfileRoutable router) : super(MyProfileInitial(), router: router);

  @override
  void onDidBecomeActive() async {
    super.onDidBecomeActive();
    await checkLoginStatus();

    // Lắng nghe sự kiện login thành công từ toàn hệ thống thông qua collect
    collect(locator<DbEventBus>().on<UserAuthEvent>().listen((event) {
      checkLoginStatus();
    }));

    // Lắng nghe sự kiện cập nhật thông tin cá nhân
    collect(locator<DbEventBus>().on<UserInfoUpdatedEvent>().listen((event) {
      checkLoginStatus();
    }));
  }

  Future<void> checkLoginStatus() async {
    emit(MyProfileLoaded(
      isLoggedIn: UserManager().isLogin,
      isCheckedIn: UserManager().hasSignedInToday,
      session: UserManager().currentUser,
      userInfo: UserManager().userInfo,
    ));
  }


  void doMainAction(String actionKey) {
    switch (actionKey) {
      case "ORDERS":
        locator<DbEventBus>().fire(SystemInfoNotifyEvent("Bạn đã hoàn thành điểm danh hôm nay"));
        break;
      case "APPOINTMENTS":
        router?.navigate(ReservationListRoute());
        break;
      case "COURSES_LEARNING":
        router?.navigate(CourseLearningListRoute());
        break;
      case "COURSES_ORDER":
        router?.navigate(CourseOrderCatalogRoute());
        break;
      case "MY_EVENTS":
        router?.navigate(ActivityListRoute());
        break;
      case "CHANGE_MOBILE":
        router?.navigate(ChangeMobileRoute());
        break;
      case "MY_COUPON":
        router?.navigate(CouponListRoute());
        break;
      case "DAILY_SIGN_IN":
        router?.navigate(DailySignInRoute());
        break;
      case "SETTINGS":
        router?.navigate(SettingsAppRoute());
        break;
      case "FEEDBACK":
        router?.navigate(FeedbackRoute());
        break;
      case "MAP_TEST":
        router?.navigate(MapTestRoute());
        break;
      default:
        debugPrint("Action $actionKey chưa được thực hiện");
    }
  }


  Future<void> doDailySignIn() async {
    final result = await _userRepo.createSignInRecord();

    if (result case DbSuccess()) {
      // 1. Lưu trạng thái điểm danh vào Local Storage
      await UserManager().saveLastSignInDate();
      
      // 2. Lấy lại userInfo mới để cập nhật điểm trên UI
      final infoRes = await _userRepo.getUserInfo();
      if (infoRes case DbSuccess(:final data)) {
        await UserManager().saveUserInfo(data);
      }
      
      // 3. Thông báo và cập nhật UI
      locator<DbEventBus>().fire(SystemSuccessNotifyEvent("Điểm danh thành công!"));
      emit(MyProfileLoaded(
        isLoggedIn: state.isLoggedIn,
        isCheckedIn: true,
        session: state.session,
        userInfo: UserManager().userInfo,
      ));

    } else if (result case DbFailure(:final error)) {
      // Case B: Nếu server báo đã điểm danh rồi (Mã lỗi 1004010000 từ bài test)
      if (error.code == 1004010000) {
        await UserManager().saveLastSignInDate();
        locator<DbEventBus>().fire(SystemInfoNotifyEvent("Bạn đã hoàn thành điểm danh hôm nay"));
        emit(MyProfileLoaded(
          isLoggedIn: state.isLoggedIn,
          isCheckedIn: true,
          session: state.session,
          userInfo: state.userInfo,
        ));
      } else {
        // Lỗi kỹ thuật khác (mạng, server sập) -> Không lưu local
        locator<DbEventBus>().fire(SystemErrorNotifyEvent(error.message));
      }
    }
  }

  // void doLogout() async {
  //   // Gọi API logout của server
  //   await _authRepo.logout();
  //
  //   // Xóa sạch dữ liệu local
  //   await UserManager().doLogoutAndClearAll();
  //
  //   // Bắn event logout cho toàn hệ thống
  //   locator<DbEventBus>().fire(UserLogoutEvent());
  //
  //   router?.doLogout();
  // }

  void goToUpdateProfile() {
    router?.navigate(EditProfileRoute());
  }

// --- UserAuthFlowListener ---

  @override
  void onAuthFlowCompleted(AuthResult result) {
    debugPrint("Auth Flow Completed: $result");
    
    switch (result) {
      case LoginSuccess(:final session):
        locator<DbEventBus>().fire(SystemSuccessNotifyEvent(AppStrings.authLoginSuccess));
        locator<DbEventBus>().fire(UserLoginSuccessEvent(session));
      case RegisterSuccess(:final session):
        locator<DbEventBus>().fire(SystemSuccessNotifyEvent(AppStrings.authRegisterSuccess));
        locator<DbEventBus>().fire(UserLoginSuccessEvent(session));
      case ResetPasswordSuccess():
        locator<DbEventBus>().fire(SystemSuccessNotifyEvent(AppStrings.authResetPasswordSuccess));
    }
  }

  @override
  void onAuthFlowCancelled(DbError error) {
    debugPrint("Auth Flow Cancelled: ${error.message}");
  }

}
