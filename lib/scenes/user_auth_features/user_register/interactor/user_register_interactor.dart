/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/data/local/user_manager/user_service.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_event_state.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:flutter/cupertino.dart';

// Interactor

class UserRegisterInteractor extends CubitInteractor<UserRegisterRouter, UserRegisterState> {
  final _authRepo = AuthRepository();
  final _userRepo = UserRepository();

  UserRegisterInteractor(UserRegisterRouter router) : super(UserRegisterInitial(), router: router);

  bool get isRoot {
    // Duyệt ngược lên để tìm UserAuthFlow, tránh lỗi nếu router bị bọc
    var current = router?.parentRouter;
    while (current != null) {
      if (current is UserAuthFlow) {
        return current.startStep == AuthStartStep.register;
      }
      current = current.parentRouter;
    }
    return true;
  }

  bool get canShowLogin => isRoot;

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    emit(UserRegisterStarted());
  }

  void sendSmsCode(String phoneNumber) async {
    final result = await _authRepo.sendSmsCode(phoneNumber, SmsScene.smsLogin);
    result.toResult().when(
      success: (isSent) {
        if (!isSent) {
          emit(UserRegisterError(message: "Send SMS Failed (Server returned false)"));
        }
      },
      failure: (error) {
        emit(UserRegisterError(message: error.message));
      },
    );
  }

  void doRegister(String phoneNumber, String smsCode, String? invitationCode) async {
    emit(UserRegisterInProgress());

    final loginRes = await _authRepo.smsLogin(phoneNumber, smsCode);
    final loginResult = loginRes.toResult();

    if (loginResult case DbFailure(:final error)) {
      emit(UserRegisterError(message: error.message));
      return;
    }

    if (loginResult case DbSuccess(:final data)) {
      // 1. Lưu session sau khi login bằng SMS thành công
      final session = UserSession(id: data.userId, accessToken: data.accessToken, refreshToken: data.refreshToken);
      // Can luu session truoc de su dung accessToken cho cac API tiep theo
      await UserManager().saveSession(session);

      // 2. Lấy thông tin Profile và counters, lưu vào UserManager
      // accessToken se duoc TokenInterceptor tu dong lay tu UserManager cho request nay
      try {
        await UserService().refreshFullUserInfo();
      } catch (e) {
        // Co the log loi hoac thong bao neu can, nhung van cho phep tiep tuc sang step Set Password
        debugPrint("Fetch profile and counters error: $e");
      }

      emit(UserRegisterSuccess());

      // 3. Chuyển sang màn hình đặt Password, truyền theo phone và code để reset pass ở bước sau
      router?.navigate(UserSetPasswordRoute(), parameters: {'mobile': phoneNumber, 'code': smsCode});
    }
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
}
