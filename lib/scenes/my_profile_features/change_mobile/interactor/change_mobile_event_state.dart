import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/db_core.dart';

class ChangeMobileState extends BaseBlocState {
  final bool isLoading;
  final String? errorMessage;
  final UserInfo? userInfo;
  final bool isUpdateSuccess;

  ChangeMobileState({
    this.isLoading = false,
    this.errorMessage,
    this.userInfo,
    this.isUpdateSuccess = false,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, userInfo, isUpdateSuccess];

  ChangeMobileState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserInfo? userInfo,
    bool? isUpdateSuccess,
  }) {
    return ChangeMobileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Reset error if not provided
      userInfo: userInfo ?? this.userInfo,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
    );
  }
}

class ChangeMobileInitial extends ChangeMobileState {
  ChangeMobileInitial() : super();
}
