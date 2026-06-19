import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/db_core.dart';

class ChangeMobileState extends BaseBlocState {
  final bool isLoading;
  final String? error;
  final UserInfo? userInfo;
  final bool isUpdateSuccess;

  ChangeMobileState({
    this.isLoading = false,
    this.error,
    this.userInfo,
    this.isUpdateSuccess = false,
  });

  @override
  List<Object?> get props => [isLoading, error, userInfo, isUpdateSuccess];

  ChangeMobileState copyWith({
    bool? isLoading,
    String? error,
    UserInfo? userInfo,
    bool? isUpdateSuccess,
  }) {
    return ChangeMobileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userInfo: userInfo ?? this.userInfo,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
    );
  }
}

class ChangeMobileInitial extends ChangeMobileState {
  ChangeMobileInitial() : super();
}
