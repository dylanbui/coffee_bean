/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/forgot_password/interactor/forgot_password_event_state.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class ForgotPasswordInteractor extends CubitInteractor<DbNoteRoutable, ForgotPasswordState> {

  ForgotPasswordInteractor({DbNoteRoutable? router}) : super(ForgotPasswordInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(ForgotPasswordInProgress());
  }

  void sendSmsCode(String phoneNumber) {
    emit(ForgotPasswordInProgress());
    // repository.sendSmsCode(phoneNumber);
  }

  void forgotPassword(String phoneNumber, String smsCode) {
    emit(ForgotPasswordInProgress());
    // repository.verifyAndResetPassword(phoneNumber, smsCode);
  }
}