import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_record/interactor/invitation_record_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_record/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_record/invitation_record_builder.dart';
import 'package:db_core/db_core.dart';

class InvitationRecordInteractor extends CubitInteractor<InvitationRecordRoutable, InvitationRecordState> {
  final UserRepository _userRepository = locator.get<UserRepository>();

  InvitationRecordInteractor(InvitationRecordRoutable router) 
      : super(InvitationRecordState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchRecords();
  }

  Future<void> fetchRecords({bool isRefresh = true}) async {
    if (isRefresh) {
      emit(state.copyWith(isLoading: true, pageNo: 1));
    } else {
      if (!state.canLoadMore || state.isMoreLoading) return;
      emit(state.copyWith(isMoreLoading: true));
    }

    final pageNo = isRefresh ? 1 : state.pageNo + 1;
    final result = await _userRepository.getInviteRecords(pageNo: pageNo, pageSize: 50);

    if (result case DbSuccess(:final data)) {
      if (data.list.isEmpty && isRefresh) {
        // Fallback to mock data
        emit(state.copyWith(
          isLoading: false,
          records: InvitationRecordMockData.getRecords(),
          total: InvitationRecordMockData.getRecords().length,
          pageNo: 1,
        ));
      } else {
        final newRecords = isRefresh ? data.list : [...state.records, ...data.list];
        emit(state.copyWith(
          isLoading: false,
          isMoreLoading: false,
          records: newRecords,
          total: data.total,
          pageNo: pageNo,
        ));
      }
    } else if (result case DbFailure()) {
      if (isRefresh) {
        // Fallback to mock data on initial load error
        emit(state.copyWith(
          isLoading: false,
          records: InvitationRecordMockData.getRecords(),
          total: InvitationRecordMockData.getRecords().length,
          pageNo: 1,
        ));
      } else {
        emit(state.copyWith(isMoreLoading: false, failure: result.error as DbFailure));
      }
    }
  }
}
