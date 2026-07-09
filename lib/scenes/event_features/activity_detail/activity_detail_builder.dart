import 'package:coffee_bean/features/checkout_order/checkout_order_builder.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_interactor.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_page.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

abstract class ActivityDetailRoutable implements DbNoteRoutable {
  void openCheckout(CheckoutItemContract item);
}

class ActivityDetailRouter extends DbNoteRouter implements ActivityDetailRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}

  @override
  void openCheckout(CheckoutItemContract item) {
    final builder = CheckoutOrderBuilder(checkoutItem: item);
    push(builder.build().viewController);
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
