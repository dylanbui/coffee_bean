/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/interactor/set_password_event_state.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/set_password_builder.dart';
import 'package:coffee_bean/shared/i18n/locale_keys.g.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:easy_localization/easy_localization.dart';

// Interactor

class SetPasswordInteractor extends CubitInteractor<DbNoteRoutable, SetPasswordState> {
  final String mobile;
  final String code;
  final SetPasswordMode mode;
  final _authRepo = AuthRepository();

  SetPasswordInteractor({
    required this.mobile,
    required this.code,
    required this.mode,
    DbNoteRoutable? router,
  }) : super(SetPasswordInitial(), router: router);

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
    
    DbResult<bool> result;
    
    if (mode == SetPasswordMode.registration) {
      // Step 3 Registration (Logged in via smsLogin)
      result = await _authRepo.updatePassword(password);
    } else {
      // Forgot Password flow
      result = await _authRepo.resetPassword(mobile, code, password);
    }
    
    result.when(
      success: (isSuccess) {
        if (isSuccess) {
          emit(SetPasswordSuccess());
          if (mode == SetPasswordMode.registration) {
            router?.navigate(SetPasswordRegistrationDoneRoute());
          } else {
            router?.navigate(SetPasswordResetDoneRoute());
          }
        } else {
          emit(SetPasswordError(message: LocaleKeys.user_auth_features_set_password_error_title.tr()));
        }
      },
      failure: (error) {
        emit(SetPasswordError(message:  error.message));
      },
    );
  }
}
