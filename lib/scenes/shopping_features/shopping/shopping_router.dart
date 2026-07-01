import 'package:coffee_bean/data/model/response/product/product.dart';
import 'package:coffee_bean/scenes/checkout_order/checkout_order_builder.dart';
import 'package:coffee_bean/scenes/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/scenes/store_list/store_list_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/product_detail_builder.dart';
import 'package:flutter/cupertino.dart';

class ProductDetailRoute implements DbNoteRoute {
  final Product product;
  ProductDetailRoute(this.product);
}

class CheckoutOrderRoute implements DbNoteRoute {
  final CheckoutItemContract contract;
  CheckoutOrderRoute(this.contract);
}

class StoreListRoute implements DbNoteRoute {}

abstract class ShoppingRoutable implements DbNoteRoutable {}

class ShoppingRouter extends DbNoteRouter implements ShoppingRoutable {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      final nextBuilder = ProductDetailBuilder(toRoute.product.id);
      final nextRouter = nextBuilder.build();
      push(nextRouter.viewController);

    } else if (toRoute is CheckoutOrderRoute) {
      final nextBuilder = CheckoutOrderBuilder(checkoutItem: toRoute.contract);
      final nextRouter = nextBuilder.build();
      push(nextRouter.viewController);

    } else if (toRoute is StoreListRoute) {
      final nextBuilder = StoreListBuilder();
      final nextRouter = nextBuilder.build();
      push(nextRouter.viewController);
    }
  }

  // @override
  // void openCheckout(CheckoutItemContract contract) {
  //   navigate(CheckoutOrderRoute(contract));
  // }



}
