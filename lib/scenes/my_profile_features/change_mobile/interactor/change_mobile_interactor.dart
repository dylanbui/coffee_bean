import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/auth_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/change_mobile_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_event_state.dart';
import 'package:db_core/db_core.dart';

class ChangeMobileInteractor extends CubitInteractor<ChangeMobileRoutable, ChangeMobileState> {
  final AuthRepository _authRepository = locator<AuthRepository>();
  final UserRepository _userRepository = locator<UserRepository>();

  ChangeMobileInteractor(ChangeMobileRoutable router) : super(ChangeMobileInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    final userInfo = UserManager().userInfo;
    emit(state.copyWith(userInfo: userInfo));
  }

  Future<void> sendSmsCode(String mobile) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = (await _authRepository.sendSmsCode(mobile, SmsScene.updatePhoneNumber)).toResult();
    
    if (result case DbSuccess()) {
      emit(state.copyWith(isLoading: false));
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(isLoading: false, error: error.message));
    }
  }

  Future<void> updateMobile(String newMobile, String newCode) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    // Đã bỏ qua oldCode vì backend hiện tại không bắt buộc
    final result = (await _userRepository.updateMobile(
      mobile: newMobile,
      code: newCode,
    )).toResult();

    if (result case DbSuccess(:final data)) {
      if (data) {
        // Cập nhật UserManager cục bộ
        final currentUserInfo = UserManager().userInfo;
        if (currentUserInfo != null) {
          await UserManager().saveUserInfo(currentUserInfo.copyWith(mobile: newMobile));
        }
        emit(state.copyWith(isLoading: false, isUpdateSuccess: true));
      } else {
        emit(state.copyWith(isLoading: false, error: "Cập nhật thất bại"));
      }
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(isLoading: false, error: error.message));
    }
  }
}
