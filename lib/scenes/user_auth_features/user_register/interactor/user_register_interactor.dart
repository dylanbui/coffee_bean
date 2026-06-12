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
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_event_state.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:flutter/cupertino.dart';

// Interactor

class UserRegisterInteractor extends CubitInteractor<UserRegisterRouter, UserRegisterState> {
  final _authRepo = AuthRepository();

  UserRegisterInteractor(UserRegisterRouter router) : super(UserRegisterInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(UserRegisterInProgress());
  }

  void sendSmsCode(String phoneNumber) async {
    final result = await _authRepo.sendSmsCode(phoneNumber, 1);
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
    
    final result = await _authRepo.smsLogin(phoneNumber, smsCode);
    
    result.toResult().when(
      success: (data) async {
        // Lưu session sau khi login bằng SMS thành công
        final session = UserSession(
          id: data.userId,
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        await UserManager().saveSession(session);

        // Chuyển sang màn hình đặt Password, truyền theo phone và code để reset pass ở bước sau
        router?.navigate(UserSetPasswordRoute(), parameters: {
          'mobile': phoneNumber,
          'code': smsCode,
        });
      },
      failure: (error) {
        emit(UserRegisterError(message: error.message));
      },
    );
  }
}
