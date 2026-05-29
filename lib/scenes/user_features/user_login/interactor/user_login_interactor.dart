/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_features/user_auth_flow.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/user_features/user_login/interactor/user_login_event_state.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/user_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:coffee_bean/scenes/user_features/user_login/shared/social_auth_service.dart';

// Interactor
class UserLoginInteractor extends CubitInteractor<UserLoginRouter, UserLoginState> {

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
      
      // GIẢ LẬP: Gửi idToken lên Backend của bạn
      await Utils.delay(second: 2);

      // Giả lập Backend trả về User Session
      final userSession = UserSession(
        id: type == SocialLoginType.google ? 100 : 101,
        userName: result.displayName ?? "$providerName User",
        email: result.email ?? "",
        fullName: result.displayName ?? "",
        avatarUrl: result.photoUrl ?? "https://i.pravatar.cc/150?img=${type == SocialLoginType.google ? 24 : 68}",
        accessToken: "mock_${providerName.toLowerCase()}_access_token_${DateTime.now().millisecondsSinceEpoch}",
        refreshToken: "mock_${providerName.toLowerCase()}_refresh_token",
      );

      // await UserManager().saveSession(userSession);
      // locator<DbEventBus>().fire(UserLoginSuccessEvent(userSession));
      
      emit(UserLoginSuccess(userSession));
      router?.navigate(LoginSuccessRoute(), parameters: {'userData': userSession});
      
    } catch (error) {
      eLog("Social Sign-In Error: $error");
      // Thêm delay nhỏ để đảm bảo UI kịp render loading trước khi bị đóng (tránh race condition)
      await Utils.delay(second: 1);
      emit(UserLoginFailure(error: "Sign-In failed: $error"));
    }
  }

  void doLoginWithGoogle() => _handleSocialLogin(SocialLoginType.google);

  void doLoginWithApple() => _handleSocialLogin(SocialLoginType.apple);

  void doLoginWithPw(String phoneNumber, String password) async {
    emit(UserLoginInProgress());
    iLog("Login with Password: $phoneNumber / $password");
    await Utils.delay();

    if (phoneNumber.contains("0988818597") && password == "1234567890") {
      final userSession = UserSession(
        id: 1,
        userName: "Dylan Bui",
        email: "buivantienduc@gmail.com",
        fullName: "Bui Van Tien Duc",
        avatarUrl: "https://i.pravatar.cc/150?img=24",
        accessToken: "mock_access_token_123456",
        refreshToken: "mock_refresh_token_abcdef",
      );

      // Chuyen thong tin logic ve flow
      // await UserManager().saveSession(userSession);
      // locator<DbEventBus>().fire(UserLoginSuccessEvent(userSession));
      emit(UserLoginSuccess(userSession));
      router?.navigate(LoginSuccessRoute(), parameters: {'userData': userSession});
    } else {
      emit(UserLoginFailure(error: "Account does not exist. Please check your phone number and password."));
    }
  }

  void doLoginWithSms(String phoneNumber, String sms) async {
    emit(UserLoginInProgress());
    iLog("Login with SMS: $phoneNumber / $sms");
    await Utils.delay();

    if (phoneNumber.contains("0988818597") && sms == "999999") {
      final userSession = UserSession(
        id: 1,
        userName: "Dylan Bui",
        email: "buivantienduc@gmail.com",
        fullName: "Bui Van Tien Duc",
        avatarUrl: "https://i.pravatar.cc/150?img=24",
        accessToken: "mock_access_token_sms_123456",
        refreshToken: "mock_refresh_token_sms_abcdef",
      );

      // await UserManager().saveSession(userSession);
      // locator<DbEventBus>().fire(UserLoginSuccessEvent(userSession));
      emit(UserLoginSuccess(userSession));
      router?.navigate(LoginSuccessRoute(), parameters: {'userData': userSession});
    } else {
      emit(UserLoginFailure(error: "Invalid SMS code. Please check and try again."));
    }
  }

  Future loadData() async {
    // Init social login
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
