import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/db_core.dart';

class ChangeMobileState extends BaseBlocState {
  final bool isLoading;
  final DbFailure? failure;
  final UserInfo? userInfo;
  final bool isUpdateSuccess;

  ChangeMobileState({
    this.isLoading = false,
    this.failure,
    this.userInfo,
    this.isUpdateSuccess = false,
  });

  @override
  List<Object?> get props => [isLoading, failure, userInfo, isUpdateSuccess];

  ChangeMobileState copyWith({
    bool? isLoading,
    DbFailure? failure,
    UserInfo? userInfo,
    bool? isUpdateSuccess,
  }) {
    return ChangeMobileState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure, // Reset error if not provided
      userInfo: userInfo ?? this.userInfo,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
    );
  }
}

class ChangeMobileInitial extends ChangeMobileState {
  ChangeMobileInitial() : super();
}
