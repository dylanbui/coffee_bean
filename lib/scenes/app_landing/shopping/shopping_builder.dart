import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_router.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ShoppingBuildable implements DbNoteBuildable {}

class ShoppingBuilder extends DbNoteBuilder implements ShoppingBuildable {
  @override
  ViewController buildFactory() {
    final router = ShoppingRouter();
    final interactor = ShoppingInteractor(router);
    final page = ShoppingPage();

    return BlocProvider(create: (_) => interactor, child: page);
  }
}
