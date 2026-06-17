import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class UpdateProfileState extends BaseBlocState {
  final bool isLoading;
  final String? error;
  final UserInfo? userInfo;
  final bool isUpdateSuccess;

  UpdateProfileState({
    this.isLoading = false,
    this.error,
    this.userInfo,
    this.isUpdateSuccess = false,
  });

  UpdateProfileState copyWith({
    bool? isLoading,
    String? error,
    UserInfo? userInfo,
    bool? isUpdateSuccess,
  }) {
    return UpdateProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userInfo: userInfo ?? this.userInfo,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, userInfo, isUpdateSuccess];
}

class UpdateProfileInitial extends UpdateProfileState {
  UpdateProfileInitial({super.userInfo}) : super();
}
