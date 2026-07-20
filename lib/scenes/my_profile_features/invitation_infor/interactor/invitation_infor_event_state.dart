import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:db_core/db_core.dart';

class InvitationInforState extends BaseBlocState {
  final bool isLoading;
  final String? errorMessage;
  final InviteOverview? overview;
  final InviteRewardConfig? config;
  final UserInfo? userInfo;

  InvitationInforState({
    this.isLoading = false,
    this.errorMessage,
    this.overview,
    this.config,
    this.userInfo,
  });

  InvitationInforState copyWith({
    bool? isLoading,
    String? errorMessage,
    InviteOverview? overview,
    InviteRewardConfig? config,
    UserInfo? userInfo,
  }) {
    return InvitationInforState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      overview: overview ?? this.overview,
      config: config ?? this.config,
      userInfo: userInfo ?? this.userInfo,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, overview, config, userInfo];
}
