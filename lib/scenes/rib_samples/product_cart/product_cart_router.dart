import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/product_detail_builder.dart';
import 'package:flutter/cupertino.dart';


class ProductDetailRoute implements DbNoteRoute {
  int productId;
  ProductDetailRoute(this.productId);
}

class ProductCartRouter extends DbNoteRouter {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      final ProductDetailBuildable productDetailBuilder = ProductDetailBuilder(productId: toRoute.productId);
      final viewController = productDetailBuilder.build();
      push(viewController);
    }
  }

}