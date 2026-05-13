/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_pages/forgot_password/interactor/forgot_password_event_state.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class ForgotPasswordInteractor extends CubitInteractor<DbNoteRoutable, ForgotPasswordState> {

  ForgotPasswordInteractor({DbNoteRoutable? router}) : super(ForgotPasswordInitial(), router: router);

  @override
  void onDidBecomeActive() {
    loadData();
  }

  Future loadData() async {
    // emit(ForgotPasswordInProgress());
  }

  void sendSmsCode(String phoneNumber) async {
    // Để không bị kẹt ở màn hình loading, chúng ta chỉ emit InProgress nếu thực sự cần chặn UI.
    // Ở đây ta giả lập gửi SMS nhanh nên có thể không cần emit hoặc emit rồi quay về Initial.
    print("Interactor: Sending SMS to $phoneNumber");
    emit(ForgotPasswordInProgress());
    await Future.delayed(const Duration(seconds: 3));
    emit(ForgotPasswordSendCodeDone());

    
    // Nếu muốn hiện loading ngắn:
    // emit(ForgotPasswordInProgress());
    // await Future.delayed(const Duration(seconds: 1));
    // emit(ForgotPasswordInitial());
  }

  Future<void> forgotPassword(String phoneNumber, String smsCode) async {
    emit(ForgotPasswordInProgress());
    await Future.delayed(const Duration(seconds: 3));
    emit(ForgotPasswordSuccess());
    router?.navigate(ForgotPasswordCompleteRoute());
    // repository.verifyAndResetPassword(phoneNumber, smsCode);
  }
}
