import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/product_detail_builder.dart';
import 'package:flutter/material.dart';

// --- Routes ---

class ProductDetailRoute implements DbNoteRoute {
  final int productId;
  ProductDetailRoute(this.productId);
}

// --- Routable ---

abstract class ProductCartRoutable implements DbNoteRoutable {
  void gotoProductDetail(int productId);
}

// --- Router ---

class ProductCartRouter extends DbNoteRouter implements ProductCartRoutable {

  @override
  void gotoProductDetail(int productId) {
    navigate(ProductDetailRoute(productId));
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      final productDetailBuilder = ProductDetailBuilder(productId: toRoute.productId);
      final productDetailRouter = productDetailBuilder.build();
      navigator.push(productDetailRouter.viewController, fromContext: fromContext);
    }
  }
}
