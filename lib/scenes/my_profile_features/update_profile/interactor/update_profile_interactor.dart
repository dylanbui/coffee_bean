import 'dart:async';
import 'dart:io';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:coffee_bean/utils/image_utils.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_event_state.dart';

class UpdateProfileInteractor extends CubitInteractor<UpdateProfileRoutable, UpdateProfileState> {
  final UserRepository _userRepository = locator<UserRepository>();
  final InfraRepository _infraRepository = locator<InfraRepository>();

  UpdateProfileInteractor(UpdateProfileRoutable router) : super(UpdateProfileInitial(), router: router);

  @override
  void onDidBecomeActive() {
    loadInitialData();
  }

  void loadInitialData() {
    final userInfo = UserManager().userInfo;
    emit(state.copyWith(userInfo: userInfo));
  }

  Future<void> onAvatarFileSelected(File file) async {
    // Nén ảnh ngay khi chọn
    final compressedFile = await ImageUtils.compressAvatar(file);
    emit(state.copyWith(selectedAvatarFile: compressedFile ?? file));
  }

  Future<void> updateProfile({
    required String nickname,
    required String avatar,
    required int sex,
  }) async {
    emit(state.copyWith(isLoading: true, error: null, isUpdateSuccess: false));

    String finalAvatarUrl = avatar;

    // Nếu có file mới chọn, thực hiện upload trước
    if (state.selectedAvatarFile != null) {
      final uploadResult = await _infraRepository.uploadFile(state.selectedAvatarFile!);
      
      if (uploadResult case DbFailure(:final error)) {
        emit(state.copyWith(isLoading: false, error: "Upload ảnh thất bại: ${error.message}"));
        return;
      }
      
      if (uploadResult case DbSuccess(:final data)) {
        finalAvatarUrl = data;
      }
    }

    final result = await _userRepository.updateUserInfo(
      nickname: nickname,
      avatar: finalAvatarUrl,
      sex: sex,
    );

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
        avatar: finalAvatarUrl,
        sex: sex,
      );
      await UserManager().saveUserInfo(newUserInfo);
      emit(state.copyWith(
        isLoading: false,
        userInfo: newUserInfo,
        isUpdateSuccess: true,
        // Sau khi update thành công thì xóa file tạm
        selectedAvatarFile: null, 
      ));
    } else {
      emit(state.copyWith(isLoading: false, isUpdateSuccess: true));
    }
  }
}
