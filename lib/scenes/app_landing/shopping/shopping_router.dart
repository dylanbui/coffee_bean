import 'package:coffee_bean/scenes/order_confirmation/order_confirmation_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/scenes/food_detail/food_detail_builder.dart';
import 'package:flutter/cupertino.dart';

class FoodDetailRoute implements DbNoteRoute {
  final TblFood product;
  FoodDetailRoute(this.product);
}

class OrderConfirmationRoute implements DbNoteRoute {}

abstract class ShoppingRoutable implements DbNoteRoutable {
}

class ShoppingRouter extends DbNoteRouter implements ShoppingRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is FoodDetailRoute) {
      final nextBuilder = FoodDetailBuilder(toRoute.product.serverId);
      final nextRouter = nextBuilder.build();
      navigator.push(nextRouter.viewController);
    } else if (toRoute is OrderConfirmationRoute) {
      final nextBuilder = OrderConfirmationBuilder();
      final nextRouter = nextBuilder.build();
      navigator.push(nextRouter.viewController);
    }
  }
}
