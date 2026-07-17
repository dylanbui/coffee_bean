import 'package:coffee_bean/features/checkout_order/checkout_order_builder.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/order_confirmation/order_confirmation_builder.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_page.dart';
import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class ProductDetailRoutable implements DbNoteRoutable {
  void gotoCommentList(int resourceId, int type);
  void gotoOrderConfirmation();
  void gotoCheckout(CheckoutItemContract contract);
}

class ProductDetailRouter extends DbNoteRouter implements ProductDetailRoutable {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }

  @override
  void gotoCommentList(int resourceId, int type) {
    final builder = CommentListBuilder(resourceId: resourceId, source: CommentSource.product, type: type);
    final router = builder.build();
    navigator.push(router.viewController);
  }

  @override
  void gotoOrderConfirmation() {
    final builder = OrderConfirmationBuilder();
    final router = builder.build();
    navigator.push(router.viewController);
  }

  @override
  void gotoCheckout(CheckoutItemContract contract) {
    final builder = CheckoutOrderBuilder(checkoutItem: contract);
    final router = builder.build();
    navigator.push(router.viewController);
  }
}

class ProductDetailBuilder extends DbNoteBuilder<ProductDetailRouter> {
  final int productId;

  ProductDetailBuilder(this.productId);

  @override
  ProductDetailRouter build() {
    final router = ProductDetailRouter();
    final interactor = ProductDetailInteractor(router, productId);
    final page = ProductDetailPage(interactor: interactor);
    router.attach(interactor, page);

    return router;
  }
}
