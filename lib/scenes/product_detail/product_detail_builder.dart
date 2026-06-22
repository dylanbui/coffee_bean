import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/product_detail/product_detail_router.dart';
import 'package:coffee_bean/scenes/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/scenes/product_detail/interactor/product_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
