/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:14
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/user_agreement/interactor/user_agreement_event_state.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class UserAgreementInteractor extends CubitInteractor<DbNoteRoutable, UserAgreementState> {

  UserAgreementInteractor({DbNoteRoutable? router}) : super(UserAgreementInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(UserAgreementInProgress());
  }
}