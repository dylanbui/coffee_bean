/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 17:09
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// Route
class ProductDetailRoute implements DbNoteRoute {
  int productId;
  ProductDetailRoute(this.productId);
}

// Router
class ProductDetailRouter extends DbNoteRouter {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      // Implementation for navigating to or within Product Detail
    }
  }

}