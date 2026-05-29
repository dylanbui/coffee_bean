/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_event_state.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:flutter/cupertino.dart';

// Interactor

class UserRegisterInteractor extends CubitInteractor<UserRegisterRouter, UserRegisterState> {

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
    // Logic gửi mã SMS
    debugPrint("Interactor: Send SMS to $phoneNumber");
  }

  void doRegister(String phoneNumber, String smsCode, String? invitationCode) async {
    emit(UserRegisterInProgress());
    // Giả lập xử lý đăng ký
    debugPrint("Interactor: Register with $phoneNumber / $smsCode / $invitationCode");
    Utils.delay(second: 2);
    emit(UserSetPassword());
    router?.navigate(UserSetPasswordRoute());
  }
}
