/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/user_register/interactor/user_register_event_state.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class UserRegisterInteractor extends CubitInteractor<DbNoteRoutable, UserRegisterState> {

  UserRegisterInteractor({DbNoteRoutable? router}) : super(UserRegisterInitial(), router: router);

  @override
  void onDidBecomeActive() {
    loadData();
  }

  Future loadData() async {
    // emit(UserRegisterInProgress());
  }

  void sendSmsCode(String phoneNumber) async {
    // Logic gửi mã SMS
    print("Interactor: Send SMS to $phoneNumber");
  }

  void doRegister(String phoneNumber, String smsCode, String? invitationCode) async {
    emit(UserRegisterInProgress());
    // Giả lập xử lý đăng ký
    print("Interactor: Register with $phoneNumber / $smsCode / $invitationCode");
    await Future.delayed(const Duration(seconds: 2));
    emit(UserRegisterSuccess());
  }
}
