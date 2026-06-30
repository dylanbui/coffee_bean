import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/scenes/announcement_detail/announcement_detail_builder.dart';
import 'package:coffee_bean/scenes/announcement_detail/interactor/announcement_detail_event_state.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';

class AnnouncementDetailInteractor extends CubitInteractor<AnnouncementDetailRoutable, AnnouncementDetailState> {
  final int announcementId;
  late final InfraRepository _infraRepository;

  AnnouncementDetailInteractor(AnnouncementDetailRoutable router, {required this.announcementId})
      : super(AnnouncementDetailState(isLoading: true), router: router) {
    _infraRepository = locator<InfraRepository>();
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    // isLoading already true from constructor
    final result = await _infraRepository.getAnnouncementDetail(announcementId);
    if (result case DbSuccess(data: final detail)) {
      emit(state.copyWith(announcement: detail, isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }
}
