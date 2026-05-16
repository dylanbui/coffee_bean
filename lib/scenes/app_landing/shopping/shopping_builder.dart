import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_router.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingBuilder extends DbNoteBuilder<ShoppingRouter> {
  @override
  ShoppingRouter build() {
    final router = ShoppingRouter();
    final interactor = ShoppingInteractor(router);
    final page = ShoppingPage(interactor: interactor);

    router.attach(interactor, BlocProvider<ShoppingInteractor>.value(value: interactor, child: page));

    return router;
  }
}
