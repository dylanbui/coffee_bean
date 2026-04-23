/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 17:09
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/product_cart/product_cart_builder.dart';
import 'package:coffee_bean/scenes/product_detail/product_detail_builder.dart';
import 'package:flutter/material.dart';


// Route

class ProductDetailRoute implements DbNoteRoute {
  int productId;
  ProductDetailRoute(this.productId);
}

class ProductCartRoute implements DbNoteRoute {}

// Router

abstract class ProductListRoutable with DbNavigator implements DbNoteRoutable {
  void gotoPostDetail(ProductDetailRoute productDetail, {BuildContext? nextContext});
  void gotoProductCart();
}

class ProductListRouter extends DbNoteRouter implements ProductListRoutable {

  @override
  void gotoPostDetail(ProductDetailRoute productDetail, {BuildContext? nextContext}) {
    navigate(productDetail, fromContext: nextContext);
  }

  @override
  void gotoProductCart() {
    navigate(ProductCartRoute());
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      final ProductDetailBuildable productDetailBuilder = ProductDetailBuilder();
      final widget = productDetailBuilder.buildWithId(toRoute.productId);
      push(widget);
    } else if (toRoute is ProductCartRoute) {
      final ProductCartBuildable cartBuilder = ProductCartBuilder();
      push(cartBuilder.build());
    }
  }
}
