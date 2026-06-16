/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/interactor/user_login_event_state.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/shared/social_auth_service.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/logger.dart';

// Interactor
class UserLoginInteractor extends CubitInteractor<UserLoginRouter, UserLoginState> {
  final _authRepo = AuthRepository();
  final _userRepo = UserRepository();

  UserLoginInteractor(UserLoginRouter router) : super(UserLoginInitial(), router: router);

  bool get isRoot {
    var current = router?.parentRouter;
    while (current != null) {
      if (current is UserAuthFlow) {
        return current.startStep == AuthStartStep.login;
      }
      current = current.parentRouter;
    }
    return true;
  }

  bool get canShowRegister => isRoot;

  @override
  Future<void> onDidBecomeActive() async {
    await SocialAuthService.initialize();
    emit(UserLoginStarted());
  }

  Future<void> _handleSocialLogin(SocialLoginType type) async {
    try {
      final String providerName = type == SocialLoginType.google ? "Google" : "Apple";
      emit(UserLoginInProgress(message: "Connecting to $providerName..."));

      final SocialAuthResult? result = await SocialAuthService.login(type);

      if (result == null) {
        emit(UserLoginFailure(error: "Sign-In failed: User cancelled")); // User cancelled
        return;
      }

      // Gooi len BE de auth, sau do
      iLog("$providerName ID Token: ${result.idToken}");
      emit(UserLoginInProgress(message: "Verifying with server..."));

      // THỰC HIỆN disconnect account ngay sau khi lấy được thông tin
      // giúp lần sau nhấn vào Login Google sẽ phải chọn lại account
      SocialAuthService.disconnectSocialAccount(type);

      // GIẢ LẬP: Gửi idToken lên Backend
      await Utils.delay(second: 1);

      // 1. Giả lập Backend trả về User Session
      final userSession = UserSession(
        id: type == SocialLoginType.google ? 100 : 101,
        accessToken: "mock_${providerName.toLowerCase()}_access_token",
        refreshToken: "mock_${providerName.toLowerCase()}_refresh_token",
      );

      // 2. Giả lập tạo UserInfo (Thường sẽ gọi thêm 1 API Profile nếu login ko trả về đủ)
      final userInfo = UserInfo(
        id: userSession.id,
        nickname: result.displayName ?? "User $providerName",
        avatar: result.photoUrl ?? "https://i.pravatar.cc/150?img=${userSession.id}",
        mobile: result.email ?? "",
        sex: 0,
        point: 100,
        experience: 50,
        brokerageEnabled: false,
      );

      iLog("Login Social thành công: ${userInfo.nickname}");
      
      // Quan trọng: Lưu session và info vào UserManager
      await UserManager().saveSession(userSession);
      await UserManager().saveUserInfo(userInfo);

      emit(UserLoginSuccess(userSession));
      // Không cần truyền parameters nữa, Flow sẽ lấy từ UserManager
      router?.navigate(LoginSuccessRoute());

    } catch (error) {
      eLog("Social Sign-In Error: $error");
      // Thêm delay nhỏ để đảm bảo UI kịp render loading trước khi bị đóng (tránh race condition)
      await Utils.delay(milliseconds: 500);
      emit(UserLoginFailure(error: "Sign-In failed: $error"));
    }
  }

  void doLoginWithGoogle() => _handleSocialLogin(SocialLoginType.google);

  void doLoginWithApple() => _handleSocialLogin(SocialLoginType.apple);

  void doLoginWithPw(String phoneNumber, String password) async {
    emit(UserLoginInProgress());
    iLog("Login with Password: $phoneNumber");

    final loginResult = (await _authRepo.login(phoneNumber, password)).toResult();

    if (loginResult case DbFailure(:final error)) {
      eLog("Login PW Error: ${error.message}");
      emit(UserLoginFailure(error: error.message));
      return;
    }

    if (loginResult case DbSuccess(data: final loginData)) {
      final userSession = UserSession(
        id: loginData.userId,
        accessToken: loginData.accessToken,
        refreshToken: loginData.refreshToken,
      );

      // Quan trọng: Lưu session để TokenInterceptor có token gọi API Profile
      await UserManager().saveSession(userSession);
      _fetchUserInfo(userSession);
    }
  }

  void doLoginWithSms(String phoneNumber, String sms) async {
    emit(UserLoginInProgress());
    iLog("Login with SMS: $phoneNumber");

    final loginResult = (await _authRepo.smsLogin(phoneNumber, sms)).toResult();

    if (loginResult case DbFailure(:final error)) {
      eLog("Login SMS Error: ${error.message}");
      emit(UserLoginFailure(error: error.message));
      return;
    }

    if (loginResult case DbSuccess(data: final loginData)) {
      final userSession = UserSession(
        id: loginData.userId,
        accessToken: loginData.accessToken,
        refreshToken: loginData.refreshToken,
      );

      // Quan trọng: Lưu session để TokenInterceptor có token gọi API Profile
      await UserManager().saveSession(userSession);
      _fetchUserInfo(userSession);

    }
  }

  void sendSmsCode(String phoneNumber) async {
    iLog("Sending SMS Code to $phoneNumber");
    final result = await _authRepo.sendSmsCode(phoneNumber, SmsScene.smsLogin);
    result.toResult().when(
      success: (isSent) {
        if (!isSent) {
          emit(UserLoginFailure(error: "Send SMS Failed"));
        }
      },
      failure: (error) {
        emit(UserLoginFailure(error: error.message));
      },
    );
  }


  void onBack() {
    if (isRoot) {
      if (router?.parentRouter is UserAuthFlow) {
        (router?.parentRouter as UserAuthFlow).onCancel();
        return;
      }
    }
    router?.parentRouter?.pop();
  }

  void _fetchUserInfo(UserSession userSession) async {
    // Fetch Profile info sau khi login
    final profileResult = (await _userRepo.getUserInfo()).toResult();

    if (profileResult case DbSuccess(data: final userInfo)) {
      await UserManager().saveUserInfo(userInfo);
      iLog("Login thành công: ${userInfo.nickname}");
      emit(UserLoginSuccess(userSession));
      router?.navigate(LoginSuccessRoute());
    } else if (profileResult case DbFailure(:final error)) {
      eLog("Fetch Profile Error: ${error.message}");
      // OPTIONAL: Xóa session vừa lưu nếu không lấy được profile để tránh trạng thái lửng lơ
      await UserManager().doLogoutAndClearAll();
      emit(UserLoginFailure(error: error.message));
    }
  }
}
