/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 15:49
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_page.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/product_detail_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Listener


// Buildable

abstract class ProductDetailBuildable implements DbNoteBuildable {
  // Khong nen dung kieu nay
  ViewController buildWithId(int productId);
}

// Builder

class ProductDetailBuilder extends DbNoteBuilder implements ProductDetailBuildable {

  late int productId;

  ProductDetailBuilder({required this.productId});

  @override
  ViewController buildFactory() {
    final router = ProductDetailRouter();
    final interactor = ProductDetailInteractor(router, productId);
    final page = ProductDetailPage(interactor: interactor);
    return BlocProvider.value(value: interactor, child: page,);
  }

  @override
  ViewController buildWithId(int productId) {
    this.productId = productId;
    // Call build() function => call buildFactory
    return build();

  }

}