/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/interactor/forgot_password_event_state.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class ForgotPasswordInteractor extends CubitInteractor<ForgotPasswordRouter, ForgotPasswordState> {
  final _authRepo = AuthRepository();

  ForgotPasswordInteractor(ForgotPasswordRouter router) : super(ForgotPasswordInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(ForgotPasswordInProgress());
  }

  void sendSmsCode(String phoneNumber) async {
    emit(ForgotPasswordInProgress());
    // Scene 4 for Forgot Password (user-reset-password)
    final result = await _authRepo.sendSmsCode(phoneNumber, SmsScene.resetPassword);
    
    result.toResult().when(
      success: (isSent) {
        if (isSent) {
          emit(ForgotPasswordSendCodeDone());
        } else {
          emit(ForgotPasswordError(message: "Send SMS Failed (Server returned false)"));
        }
      },
      failure: (error) {
        emit(ForgotPasswordError(message: error.message));
      },
    );
  }

  Future<void> forgotPassword(String phoneNumber, String smsCode) async {
    // Step 1: Validate phone and code. 
    // In some flows, we just go to Step 2. 
    // If the server has a validate API, we can call it here.
    // Based on CSV, Step 2 is ResetPassword which takes phone, code, and new password.
    // So here we just navigate to SetPassword with phone and code.
    
    router?.navigate(ForgotPasswordCompleteRoute(), parameters: {
      'mobile': phoneNumber,
      'code': smsCode,
    });
  }
}
