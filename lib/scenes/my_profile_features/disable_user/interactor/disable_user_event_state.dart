import 'package:db_core/db_core.dart';

abstract class DisableUserState extends BaseBlocState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  DisableUserState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  @override
  List<Object?> get props => [isLoading, error, isSuccess];

  DisableUserState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  });
}

class DisableUserInitial extends DisableUserState {
  DisableUserInitial() : super();

  @override
  DisableUserInitial copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return DisableUserInitial();
  }
}

class DisableUserUpdateState extends DisableUserState {
  DisableUserUpdateState({
    super.isLoading,
    super.error,
    super.isSuccess,
  });

  @override
  DisableUserUpdateState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return DisableUserUpdateState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Luôn reset error nếu không truyền
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
