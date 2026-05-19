/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_features/forgot_password/forgot_password_router.dart';
import 'package:coffee_bean/scenes/user_features/forgot_password/interactor/forgot_password_event_state.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class ForgotPasswordInteractor extends CubitInteractor<ForgotPasswordRouter, ForgotPasswordState> {

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
    print("Interactor: Sending SMS to $phoneNumber");
    emit(ForgotPasswordInProgress());
    await Future.delayed(const Duration(seconds: 3));
    emit(ForgotPasswordSendCodeDone());
  }

  Future<void> forgotPassword(String phoneNumber, String smsCode) async {
    emit(ForgotPasswordInProgress());
    await Future.delayed(const Duration(seconds: 3));
    emit(ForgotPasswordSuccess());
    router?.navigate(ForgotPasswordCompleteRoute());
  }
}
