import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/product_cart_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/product_detail_builder.dart';
import 'package:flutter/material.dart';

// --- Routes ---

class ProductDetailRoute implements DbNoteRoute {
  final int productId;
  ProductDetailRoute(this.productId);
}

class ProductCartRoute implements DbNoteRoute {}

// --- Routable ---

abstract class ProductListRoutable implements DbNoteRoutable {
  void gotoProductDetail(int productId, {BuildContext? nextContext});
  void gotoProductCart();
}

// --- Router ---

class ProductListRouter extends DbNoteRouter implements ProductListRoutable {

  @override
  void gotoProductDetail(int productId, {BuildContext? nextContext}) {
    navigate(ProductDetailRoute(productId), fromContext: nextContext);
  }

  @override
  void gotoProductCart() {
    navigate(ProductCartRoute());
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      final productDetailBuilder = ProductDetailBuilder(productId: toRoute.productId);
      // Ensure build() returns a Router (extending DbNoteRouter)
      final productDetailRouter = productDetailBuilder.build();
      navigator.push(productDetailRouter.viewController, fromContext: fromContext);
    } else if (toRoute is ProductCartRoute) {
      final cartBuilder = ProductCartBuilder();
      final cartRouter = cartBuilder.build();
      navigator.push(cartRouter.viewController, fromContext: fromContext);
    }
  }
}
