/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_features/set_password/interactor/set_password_event_state.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/user_features/user_register/user_register_builder.dart';
import 'package:coffee_bean/utils/utils.dart';

// Interactor

class SetPasswordInteractor extends CubitInteractor<DbNoteRoutable, SetPasswordState> {

  SetPasswordInteractor({DbNoteRoutable? router}) : super(SetPasswordInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(SetPasswordInProgress());
  }

  Future<void> doSetPassword(String password) async {
    emit(SetPasswordInProgress());
    await Utils.delay();
    emit(SetPasswordSuccess());
    router?.navigate(UserRegisterCompleteRoute());
  }
}
