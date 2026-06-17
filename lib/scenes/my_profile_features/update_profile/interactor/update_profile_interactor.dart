import 'dart:async';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_event_state.dart';

class UpdateProfileInteractor extends CubitInteractor<UpdateProfileRoutable, UpdateProfileState> {
  final UserRepository _userRepository = locator<UserRepository>();

  UpdateProfileInteractor(UpdateProfileRoutable router) : super(UpdateProfileInitial(), router: router);

  @override
  void onDidBecomeActive() {
    loadInitialData();
  }

  void loadInitialData() {
    final userInfo = UserManager().userInfo;
    emit(state.copyWith(userInfo: userInfo));
  }

  Future<void> updateProfile({
    required String nickname,
    required String avatar,
    required int sex,
  }) async {
    emit(state.copyWith(isLoading: true, error: null, isUpdateSuccess: false));

    final result = (await _userRepository.updateUserInfo(
      nickname: nickname,
      avatar: avatar,
      sex: sex,
    )).toResult();

    if (result case DbFailure(:final error)) {
      emit(state.copyWith(
        isLoading: false,
        error: error.message,
      ));
      return;
    }

    // Happy Path
    final currentUserInfo = UserManager().userInfo;
    if (currentUserInfo != null) {
      final newUserInfo = currentUserInfo.copyWith(
        nickname: nickname,
        avatar: avatar,
        sex: sex,
      );
      await UserManager().saveUserInfo(newUserInfo);
      emit(state.copyWith(
        isLoading: false,
        userInfo: newUserInfo,
        isUpdateSuccess: true,
      ));
    } else {
      emit(state.copyWith(isLoading: false, isUpdateSuccess: true));
    }
  }


}
