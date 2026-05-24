/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/config/constants.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/user_features/user_login/interactor/user_login_event_state.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/user_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/utils/utils.dart';

// Interactor
class UserLoginInteractor extends CubitInteractor<UserLoginRouter, UserLoginState> {

  UserLoginInteractor(UserLoginRouter router) : super(UserLoginInitial(), router: router);

  @override
  void onDidBecomeActive() {
    // emit(UserLoginInitial());
    loadData();
  }

  void doLoginWithPw(String phoneNumber, String password) async {
    emit(UserLoginInProgress());
    iLog("Login with Password: $phoneNumber / $password");
    await Utils.delay();

    // Giả lập logic kiểm tra thông tin đăng nhập
    // Chấp nhận số điện thoại có chứa 0988818597 (để bỏ qua mã quốc gia nếu có)
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

      // Lưu vào hệ thống
      await UserManager().saveSession(userSession);

      // Bao ve UI da thuc hien task xong
      emit(UserLoginSuccess());

      // Bắn event thông báo login thành công cho toàn hệ thống
      // locator<DbEventBus>().fire(UserLoginSuccessEvent());

      // Thuc hien chuyen thong bao di, khong can push voi EventBus
      router?.navigate(LoginSuccessRoute());

    } else {
      emit(UserLoginFailure(error: "Account does not exist. Please check your phone number and password."));
    }
  }

  void doLoginWithSms(String phoneNumber, String sms) async {
    emit(UserLoginInProgress());
    iLog("Login with SMS: $phoneNumber / $sms");
    await Utils.delay();

    // Giả lập logic kiểm tra mã SMS
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

      // Lưu vào hệ thống
      await UserManager().saveSession(userSession);

      // Bắn event thông báo login thành công cho toàn hệ thống
      locator<DbEventBus>().fire(UserLoginSuccessEvent());

      emit(UserLoginSuccess());
    } else {
      emit(UserLoginFailure(error: "Invalid SMS code. Please check and try again."));
    }
  }

  Future loadData() async {
    // emit(UserLoginInProgress());
    await Future.delayed(const Duration(seconds: 3));
    emit(UserLoginStarted());
  }
}