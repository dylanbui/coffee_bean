import 'dart:io';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class UpdateProfileState extends BaseBlocState {
  final bool isLoading;
  final String? error;
  final UserInfo? userInfo;
  final bool isUpdateSuccess;
  final File? selectedAvatarFile;
  final File? selectedCoverFile;

  UpdateProfileState({
    this.isLoading = false,
    this.error,
    this.userInfo,
    this.isUpdateSuccess = false,
    this.selectedAvatarFile,
    this.selectedCoverFile,
  });

  UpdateProfileState copyWith({
    bool? isLoading,
    String? error,
    UserInfo? userInfo,
    bool? isUpdateSuccess,
    File? selectedAvatarFile,
    File? selectedCoverFile,
  }) {
    return UpdateProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userInfo: userInfo ?? this.userInfo,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
      selectedAvatarFile: selectedAvatarFile ?? this.selectedAvatarFile,
      selectedCoverFile: selectedCoverFile ?? this.selectedCoverFile,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, userInfo, isUpdateSuccess, selectedAvatarFile, selectedCoverFile];
}

class UpdateProfileInitial extends UpdateProfileState {
  UpdateProfileInitial({super.userInfo}) : super();
}
