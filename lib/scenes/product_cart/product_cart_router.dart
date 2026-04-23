import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/product_cart/interactor/product_cart_interactor.dart';
import 'package:coffee_bean/scenes/product_detail/product_detail_builder.dart';
import 'package:coffee_bean/scenes/product_list/product_list_router.dart';
import 'package:flutter/cupertino.dart';

class ProductCartRouter extends DbNoteRouter implements ProductCartRoutable {
  @override
  void gotoProductDetail(ProductDetailRoute route) {
    navigate(route);
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      final ProductDetailBuildable productDetailBuilder = ProductDetailBuilder();
      final widget = productDetailBuilder.buildWithId(toRoute.productId);
      push(widget);
    }
  }
}
