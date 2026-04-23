import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/shopping/shopping_router.dart';
import 'package:coffee_bean/scenes/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/scenes/shopping/interactor/shopping_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ShoppingBuildable implements DbNoteBuildable {
  @override
  Widget build();
}

class ShoppingBuilder extends DbNoteBuilder implements ShoppingBuildable {
  @override
  Widget build() {
    final router = ShoppingRouter();
    final interactor = ShoppingInteractor(router);
    final page = ShoppingPage();
    
    // page.showAppBar = showAppBarOnRootPage;

    rootPage = BlocProvider(
      create: (_) => interactor,
      child: page,
    );
    return rootPage;
  }
}
