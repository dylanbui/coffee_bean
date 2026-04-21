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
import 'package:flutter/material.dart';


// Route

class ProductDetailRoute implements DbNoteRoute {
  int productId;
  ProductDetailRoute(this.productId);
}

// Router

abstract class ProductListRoutable with DbNavigator implements DbNoteRoutable {
  void gotoPostDetail(ProductDetailRoute productDetail, BuildContext nextContext);
}

class ProductListRouter extends DbNoteRouter implements ProductListRoutable {

  @override
  void gotoPostDetail(ProductDetailRoute productDetail, BuildContext nextContext) {
    navigate(productDetail, fromContext: nextContext);
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {

      // final PostDetailBuildable postDetailBuilder = PostDetailBuilder();
      // final widget = postDetailBuilder.build(toRoute.postId);
      //// push(nextContext, widget);
      //DbNavigator().push(widget);
      //push(widget)
    }

  }


}