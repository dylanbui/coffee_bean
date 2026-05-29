/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:14
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_auth_features/user_agreement/interactor/user_agreement_event_state.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class UserAgreementInteractor extends CubitInteractor<DbNoteRoutable, UserAgreementState> {

  UserAgreementInteractor({DbNoteRoutable? router}) : super(UserAgreementInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(UserAgreementInProgress());
  }
}
