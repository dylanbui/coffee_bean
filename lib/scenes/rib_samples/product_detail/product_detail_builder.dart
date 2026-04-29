/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 15:49
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_page.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/product_detail_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Listener


// Buildable

abstract class ProductDetailBuildable implements DbNoteBuildable {
  Widget buildWithId(int productId);
}


// Builder

class ProductDetailBuilder extends DbNoteBuilder implements ProductDetailBuildable {

  late int productId = 0;

  @override
  Widget build() {
    // Default build without ID might not be useful for Detail, but keeping interface
    // productId = 0, se khong tim thay du lieu
    return buildWithId(0);
  }

  @override
  Widget buildWithId(int productId) {
    this.productId = productId;
    final router = ProductDetailRouter();
    final productDetailInteractor = ProductDetailInteractor(router, productId);
    final page = ProductDetailPage();
    rootPage = BlocProvider(create: (_) =>  productDetailInteractor, child: page,);
    return rootPage;
  }

}