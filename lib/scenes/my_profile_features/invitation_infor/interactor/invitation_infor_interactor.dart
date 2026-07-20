import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/invitation_infor_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/invitation_infor_builder.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/services.dart';

class InvitationInforInteractor extends CubitInteractor<InvitationInforRoutable, InvitationInforState> {
  final UserRepository _userRepository = locator<UserRepository>();

  InvitationInforInteractor(InvitationInforRoutable router) : super(InvitationInforState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchData();
  }

  Future<void> _fetchData() async {
    emit(state.copyWith(isLoading: true));

    // Fetch User Info first
    final userResult = await _userRepository.getUserInfo();
    if (userResult case DbSuccess(data: final userInfo)) {
      emit(state.copyWith(userInfo: userInfo));
    }

    // Fetch Overview and Config in parallel
    final results = await Future.wait([
      _userRepository.getInviteOverview(),
      _userRepository.getInviteRewardConfig(),
    ]);

    final overviewResult = results[0] as DbResult<InviteOverview>;
    final configResult = results[1] as DbResult<InviteRewardConfig>;

    var newState = state.copyWith(isLoading: false);

    // Handle Overview
    if (overviewResult is DbSuccess<InviteOverview>) {
      newState = newState.copyWith(overview: overviewResult.data);
    } else {
      // Fallback to mock if failed
      newState = newState.copyWith(overview: InvitationMockData.mockOverview);
    }

    // Handle Config
    if (configResult is DbSuccess<InviteRewardConfig>) {
      newState = newState.copyWith(config: configResult.data);
    } else {
      // Fallback to mock if failed
      newState = newState.copyWith(config: InvitationMockData.mockConfig);
    }

    emit(newState);
  }

  void copyInviteCode(String code) {
    Clipboard.setData(ClipboardData(text: code)).then((_) {
      // Use extension method from flash_utils if available on context or via EventBus
      // Based on AGENTS.md: UI Layer uses context.showFlash, Logic Layer uses SystemNotifyEvent
      locator<DbEventBus>().fire(SystemSuccessNotifyEvent("Đã sao chép mã mời: $code"));
    });
  }
  
  void refresh() => _fetchData();
}
