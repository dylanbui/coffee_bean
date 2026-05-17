import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/product_list/interactor/product_list_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/product_list/interactor/product_list_page.dart';
import 'package:coffee_bean/scenes/rib_samples/product_list/product_list_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductListBuildable implements DbNoteBuildable {}

class ProductListBuilder extends DbNoteBuilder<ProductListRouter> implements ProductListBuildable {
  @override
  ProductListRouter build() {
    final router = ProductListRouter();
    final interactor = ProductListInteractor(router);
    final page = ProductListPage(interactor: interactor);

    router.attach(interactor, BlocProvider.value(value: interactor, child: page));

    return router;
  }
}
