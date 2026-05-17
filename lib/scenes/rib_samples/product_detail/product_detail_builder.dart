import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_page.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/product_detail_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductDetailBuildable implements DbNoteBuildable {}

class ProductDetailBuilder extends DbNoteBuilder<ProductDetailRouter> implements ProductDetailBuildable {
  final int productId;

  ProductDetailBuilder({required this.productId});

  @override
  ProductDetailRouter build() {
    final router = ProductDetailRouter();
    final interactor = ProductDetailInteractor(router, productId);
    final page = ProductDetailPage(interactor: interactor);

    router.attach(interactor, BlocProvider.value(value: interactor, child: page));

    return router;
  }
}
