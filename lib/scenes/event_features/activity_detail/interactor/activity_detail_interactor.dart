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
    
    final activity = await _activityRepository.getActivityById(activityId);
    
    if (activity != null) {
      emit(state.copyWith(
        isLoading: false,
        title: activity.name,
        description: activity.description ?? "",
        price: activity.price,
        images: activity.images?.map((e) => e.url ?? "").toList() ?? [],
        // Mocking slots data as they might not be in sample JSON
        totalSlots: 100,
        bookedSlots: 57,
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
    final checkoutItem = ActivityCheckoutItem(
      activityId: activityId,
      activityTitle: state.title,
      activityAddress: state.address,
      activityImageUrl: state.images.isNotEmpty ? state.images.first : null,
      activityPrice: state.price,
    );
    router?.openCheckout(checkoutItem);
  }
}
