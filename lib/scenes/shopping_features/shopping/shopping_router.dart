import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/scenes/order_confirmation/order_confirmation_builder.dart';
import 'package:coffee_bean/scenes/store_list/store_list_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/product_detail_builder.dart';
import 'package:flutter/cupertino.dart';

class ProductDetailRoute implements DbNoteRoute {
  final Product product;
  ProductDetailRoute(this.product);
}

class OrderConfirmationRoute implements DbNoteRoute {}

class StoreListRoute implements DbNoteRoute {}

abstract class ShoppingRoutable implements DbNoteRoutable {
}

class ShoppingRouter extends DbNoteRouter implements ShoppingRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      final nextBuilder = ProductDetailBuilder(toRoute.product.id);
      final nextRouter = nextBuilder.build();
      navigator.push(nextRouter.viewController);
    } else if (toRoute is OrderConfirmationRoute) {
      final nextBuilder = OrderConfirmationBuilder();
      final nextRouter = nextBuilder.build();
      navigator.push(nextRouter.viewController);
    } else if (toRoute is StoreListRoute) {
      final nextBuilder = StoreListBuilder();
      final nextRouter = nextBuilder.build();
      navigator.push(nextRouter.viewController);
    }
  }
}
