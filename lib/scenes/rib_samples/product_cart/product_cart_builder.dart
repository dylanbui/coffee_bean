import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/interactor/product_cart_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/interactor/product_cart_page.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/product_cart_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductCartBuildable implements DbNoteBuildable { }

class ProductCartBuilder extends DbNoteBuilder implements ProductCartBuildable {
  @override
  ViewController buildFactory() {
    final router = ProductCartRouter();
    final interactor = ProductCartInteractor(router);
    final page = ProductCartPage();
    return BlocProvider(create: (_) => interactor, child: page);
  }
}
