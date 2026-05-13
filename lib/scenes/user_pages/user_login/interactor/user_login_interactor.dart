/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_event_state.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class UserLoginInteractor extends CubitInteractor<DbNoteRoutable, UserLoginState> {

  UserLoginInteractor({DbNoteRoutable? router}) : super(UserLoginEmptyState(), router: router);

  @override
  void onDidBecomeActive() {
    emit(UserLoginInitial());
    loadData();
  }

  void doLoginWithPw(String phoneNumber, String password) async {
    emit(UserLoginInProgress());
    print("Login with Password: $phoneNumber / $password");
    await Future.delayed(const Duration(seconds: 3));
    emit(UserLoginSuccess());
  }

  void doLoginWithSms(String phoneNumber, String sms) async {
    emit(UserLoginInProgress());
    print("Login with SMS: $phoneNumber / $sms");
    await Future.delayed(const Duration(seconds: 3));
    emit(UserLoginSuccess());

  }

  Future loadData() async {
    // emit(UserLoginInProgress());
    await Future.delayed(const Duration(seconds: 3));
    emit(UserLoginStarted());
  }
}