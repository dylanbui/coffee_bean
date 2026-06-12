/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

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

  @override
  void onDidBecomeActive() {
    loadData();
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
      
      emit(UserLoginSuccess(userSession));
      // Gửi cả session và info cho Flow xử lý tập trung
      router?.navigate(LoginSuccessRoute(), parameters: {
        'userSession': userSession,
        'userInfo': userInfo,
      });

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
    try {
      emit(UserLoginInProgress());
      iLog("Login with Password: $phoneNumber");

      final loginData = (await _authRepo.login(phoneNumber, password)).getOrThrow();

      final userSession = UserSession(
        id: loginData.userId,
        accessToken: loginData.accessToken,
        refreshToken: loginData.refreshToken,
      );

      // Fetch Profile info sau khi login
      final userInfo = (await _userRepo.getUserInfo()).getOrThrow();

      iLog("Login PW thành công: ${userInfo.nickname}");
      emit(UserLoginSuccess(userSession));
      
      router?.navigate(LoginSuccessRoute(), parameters: {
        'userSession': userSession,
        'userInfo': userInfo,
      });
    } catch (error) {
      eLog("Login PW Error: $error");
      emit(UserLoginFailure(error: error.toString()));
    }
  }

  void doLoginWithSms(String phoneNumber, String sms) async {
    try {
      emit(UserLoginInProgress());
      iLog("Login with SMS: $phoneNumber");

      final loginData = (await _authRepo.smsLogin(phoneNumber, sms)).getOrThrow();

      final userSession = UserSession(
        id: loginData.userId,
        accessToken: loginData.accessToken,
        refreshToken: loginData.refreshToken,
      );

      // Fetch Profile info sau khi login
      final userInfo = (await _userRepo.getUserInfo()).getOrThrow();

      iLog("Login SMS thành công: ${userInfo.nickname}");
      emit(UserLoginSuccess(userSession));
      
      router?.navigate(LoginSuccessRoute(), parameters: {
        'userSession': userSession,
        'userInfo': userInfo,
      });
    } catch (error) {
      eLog("Login SMS Error: $error");
      emit(UserLoginFailure(error: error.toString()));
    }
  }

  Future loadData() async {
    await SocialAuthService.initialize();
    await Utils.delay(second: 1);
    emit(UserLoginStarted());
  }

  void onBack() {
    if (router?.parentRouter is UserAuthFlow) {
      (router!.parentRouter as UserAuthFlow).onCancel();
    } else {
      router?.pop();
    }
  }
}
