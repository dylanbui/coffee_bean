import 'dart:async';
import 'dart:io';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
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
    emit(state.copyWith(
      userInfo: userInfo,
      nickname: userInfo?.nickname ?? '',
    ));
  }

  void onNicknameChanged(String value) {
    emit(state.copyWith(
      nickname: value,
      validation: state.validation.copyWith(isNicknameValid: true),
    ));
  }

  Future<void> onAvatarFileSelected(File file) async {
    // Không cần nén ở đây nữa, Repo sẽ tự nén khi upload
    emit(state.copyWith(
      selectedAvatarFile: file,
      validation: state.validation.copyWith(isAvatarValid: true),
    ));
  }

  void onCoverFileSelected(List<String> paths) {
    if (paths.isNotEmpty) {
      emit(state.copyWith(selectedCoverFile: File(paths.first)));
    }
  }

  void removeCoverImage() {
    emit(state.copyWith(selectedCoverFile: null));
  }

  void onDisableAccountRequested() {
    router?.routeToDisableUser();
  }

  Future<void> updateProfile({
    required int sex,
  }) async {
    final isNicknameValid = state.nickname.trim().isNotEmpty;
    // Avatar bắt buộc nếu cả file mới và url cũ đều không có
    final isAvatarValid = state.selectedAvatarFile != null || (state.userInfo?.avatar.isNotEmpty ?? false);

    final validation = state.validation.copyWith(
      isNicknameValid: isNicknameValid,
      isAvatarValid: isAvatarValid,
    );

    emit(state.copyWith(validation: validation));

    if (!validation.isValid) {
      emit(state.copyWith(error: "Vui lòng nhập đầy đủ thông tin bắt buộc"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, isUpdateSuccess: false));

    String finalAvatarUrl = state.userInfo?.avatar ?? "";
    String? finalCoverUrl = state.userInfo?.background;

    // Xử lý upload song song nếu có file mới
    final List<Future<void>> uploadTasks = [];

    if (state.selectedAvatarFile != null) {
      uploadTasks.add(_infraRepository.uploadFile(state.selectedAvatarFile!).then((result) {
        if (result case DbSuccess(:final data)) {
          finalAvatarUrl = data;
        } else if (result case DbFailure(:final error)) {
          throw Exception("Upload ảnh đại diện thất bại: ${error.message}");
        }
      }));
    }

    if (state.selectedCoverFile != null) {
      uploadTasks.add(_infraRepository.uploadFile(state.selectedCoverFile!, directory: 'user').then((result) {
        if (result case DbSuccess(:final data)) {
          finalCoverUrl = data;
        } else if (result case DbFailure(:final error)) {
          throw Exception("Upload ảnh bìa thất bại: ${error.message}");
        }
      }));
    }

    try {
      if (uploadTasks.isNotEmpty) {
        await Future.wait(uploadTasks);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString().replaceFirst("Exception: ", "")));
      return;
    }

    final result = await _userRepository.updateUserInfo(
      nickname: state.nickname.trim(),
      avatar: finalAvatarUrl,
      sex: sex,
      background: finalCoverUrl,
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
        nickname: state.nickname.trim(),
        avatar: finalAvatarUrl,
        sex: sex,
        background: finalCoverUrl,
      );
      await UserManager().saveUserInfo(newUserInfo);
      emit(state.copyWith(
        isLoading: false,
        userInfo: newUserInfo,
        isUpdateSuccess: true,
        // Sau khi update thành công thì xóa file tạm
        selectedAvatarFile: null,
        selectedCoverFile: null,
      ));
    } else {
      emit(state.copyWith(isLoading: false, isUpdateSuccess: true));
    }
  }
}
