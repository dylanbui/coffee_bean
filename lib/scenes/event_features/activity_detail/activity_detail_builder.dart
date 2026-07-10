import 'package:coffee_bean/data/map_provider/app_map_contract.dart';
import 'package:coffee_bean/features/app_map/app_map_builder.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_builder.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_interactor.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_page.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

abstract class ActivityDetailRoutable implements DbNoteRoutable {
  void openCheckout(CheckoutItemContract item);
  void openMap();
}

class ActivityDetailRouter extends DbNoteRouter implements ActivityDetailRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}

  @override
  void openCheckout(CheckoutItemContract item) {
    final builder = CheckoutOrderBuilder(checkoutItem: item);
    push(builder.build().viewController);
  }

  @override
  void openMap() {
    final marker = MapMarker(
      id: "tmlabs_coffee",
      location: const DbLocation(latitude: 10.796993411873403, longitude: 106.7059799422638),
      title: "TMLabs Coffee",
      address: "84a Nguyễn Cửu Vân, Gia Định, Hồ Chí Minh, Vietnam",
    );
    final builder = AppMapBuilder(marker).build();
    push(builder.viewController);
  }
}


class ActivityDetailBuilder extends DbNoteBuilder<ActivityDetailRouter> {
  final int activityId;

  ActivityDetailBuilder(this.activityId);

  @override
  ActivityDetailRouter build() {
    final router = ActivityDetailRouter();
    final interactor = ActivityDetailInteractor(router, activityId);
    final page = ActivityDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
