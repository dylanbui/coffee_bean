import 'package:coffee_bean/data/local/user_manager/user_service.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/disable_user/disable_user_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/disable_user/interactor/disable_user_event_state.dart';

class DisableUserInteractor extends CubitInteractor<DisableUserRoutable, DisableUserState> {
  final UserRepository _userRepository = locator<UserRepository>();

  DisableUserInteractor(DisableUserRoutable router) : super(DisableUserInitial(), router: router);

  Future<void> cancelAccount() async {
    emit(DisableUserUpdateState(isLoading: true));

    final result = await _userRepository.cancelUserAccount();

    if (result case DbSuccess(data: final success)) {
      if (success) {
        emit(DisableUserUpdateState(isSuccess: true));
        // Đợi 1 chút để UI hiển thị thông báo thành công (nếu cần) trước khi logout
        await Future.delayed(const Duration(milliseconds: 500));
        await UserService().logout();
      } else {
        emit(DisableUserUpdateState(error: "Hệ thống không thể thực hiện yêu cầu lúc này."));
      }
    } else if (result case DbFailure(:final error)) {
      emit(DisableUserUpdateState(error: error.message));
    }
  }
}
