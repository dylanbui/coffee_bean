import 'package:coffee_bean/data/repository/activity_repository.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/activity_checkout_item.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/activity_detail_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_event_state.dart';
import 'package:db_core/db_core.dart';

class ActivityDetailInteractor extends CubitInteractor<ActivityDetailRoutable, ActivityDetailState> {
  final ActivityRepository _activityRepository = locator<ActivityRepository>();
  final int activityId;

  ActivityDetailInteractor(ActivityDetailRoutable router, this.activityId)
      : super(const ActivityDetailState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadActivityDetail();
  }

  Future<void> _loadActivityDetail() async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _activityRepository.getActivityById(activityId);
    
    if (result case DbSuccess(data: final activity)) {
      emit(state.copyWith(
        isLoading: false,
        activityDetail: activity,
      ));
    } else {
      emit(state.copyWith(isLoading: false));
      DbToast.show("Không tìm thấy thông tin sự kiện");
    }
  }

  void onDirectionTap() {
    DbToast.show("Đang mở bản đồ...");
  }

  void onPaymentTap() {
    final activity = state.activityDetail;
    if (activity == null) return;

    final checkoutItem = ActivityCheckoutItem(
      activityId: activityId,
      activityTitle: activity.activityName,
      activityAddress: activity.activityLocation ?? "",
      activityImageUrl: activity.activityCover,
      activityPrice: activity.activityPrice,
    );
    router?.openCheckout(checkoutItem);
  }
}
