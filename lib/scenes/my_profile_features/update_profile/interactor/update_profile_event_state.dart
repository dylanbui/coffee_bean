import 'dart:io';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/db_core.dart';

class UpdateProfileFormStatus extends Equatable {
  final bool isNicknameValid;
  final bool isAvatarValid;

  const UpdateProfileFormStatus({
    this.isNicknameValid = true,
    this.isAvatarValid = true,
  });

  bool get isValid => isNicknameValid && isAvatarValid;

  @override
  List<Object?> get props => [isNicknameValid, isAvatarValid];

  UpdateProfileFormStatus copyWith({
    bool? isNicknameValid,
    bool? isAvatarValid,
  }) {
    return UpdateProfileFormStatus(
      isNicknameValid: isNicknameValid ?? this.isNicknameValid,
      isAvatarValid: isAvatarValid ?? this.isAvatarValid,
    );
  }
}

class UpdateProfileState extends BaseBlocState {
  final bool isLoading;
  final String? error;
  final UserInfo? userInfo;
  final String nickname;
  final bool isUpdateSuccess;
  final File? selectedAvatarFile;
  final File? selectedCoverFile;
  final UpdateProfileFormStatus validation;

  UpdateProfileState({
    this.isLoading = false,
    this.error,
    this.userInfo,
    this.nickname = '',
    this.isUpdateSuccess = false,
    this.selectedAvatarFile,
    this.selectedCoverFile,
    this.validation = const UpdateProfileFormStatus(),
  });

  UpdateProfileState copyWith({
    bool? isLoading,
    String? error,
    UserInfo? userInfo,
    String? nickname,
    bool? isUpdateSuccess,
    File? selectedAvatarFile,
    File? selectedCoverFile,
    UpdateProfileFormStatus? validation,
  }) {
    return UpdateProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userInfo: userInfo ?? this.userInfo,
      nickname: nickname ?? this.nickname,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
      selectedAvatarFile: selectedAvatarFile ?? this.selectedAvatarFile,
      selectedCoverFile: selectedCoverFile ?? this.selectedCoverFile,
      validation: validation ?? this.validation,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        userInfo,
        nickname,
        isUpdateSuccess,
        selectedAvatarFile,
        selectedCoverFile,
        validation,
      ];
}

class UpdateProfileInitial extends UpdateProfileState {
  UpdateProfileInitial({super.userInfo}) : super();
}
