import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/interactor/product_cart_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/interactor/product_cart_page.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/product_cart_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductCartBuildable implements DbNoteBuildable {}

class ProductCartBuilder extends DbNoteBuilder<ProductCartRouter> implements ProductCartBuildable {
  @override
  ProductCartRouter build() {
    final router = ProductCartRouter();
    final interactor = ProductCartInteractor(router);
    final page = ProductCartPage(interactor: interactor);

    router.attach(interactor, BlocProvider.value(value: interactor, child: page));

    return router;
  }
}
