/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/set_password/interactor/set_password_event_state.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class SetPasswordInteractor extends CubitInteractor<DbNoteRoutable, SetPasswordState> {

  SetPasswordInteractor({DbNoteRoutable? router}) : super(SetPasswordInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(SetPasswordInProgress());
  }
}