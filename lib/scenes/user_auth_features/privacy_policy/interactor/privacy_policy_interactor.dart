/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_auth_features/privacy_policy/interactor/privacy_policy_event_state.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// Interactor

class PrivacyPolicyInteractor extends CubitInteractor<DbNoteRoutable, PrivacyPolicyState> {

  PrivacyPolicyInteractor({DbNoteRoutable? router}) : super(PrivacyPolicyInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(PrivacyPolicyInProgress());
  }
}
