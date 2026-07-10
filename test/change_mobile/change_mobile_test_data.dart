import 'package:coffee_bean/scenes/my_profile_features/change_mobile/interactor/change_mobile_event_state.dart';
import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:db_core/db_core.dart';

/// Lớp cung cấp dữ liệu mẫu cho các bài test Change Mobile
class ChangeMobileTestData {
  static UserInfo get mockUserInfo => UserInfo(
        id: 123,
        nickname: "Test User",
        mobile: "+84988111222",
        avatar: "",
        sex: 1,
        point: 100,
        experience: 50,
      );

  static ChangeMobileState get initialState => ChangeMobileInitial().copyWith(
        userInfo: mockUserInfo,
      );

  static ChangeMobileState get loadingState => initialState.copyWith(isLoading: true);

  static ChangeMobileState errorState(String message) => initialState.copyWith(
        isLoading: false,
        failure: DbFailure(NetworkError(-1, message)),
      );

  static ChangeMobileState get successState => initialState.copyWith(
        isLoading: false,
        isUpdateSuccess: true,
      );
}
