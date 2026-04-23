
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/home/home_router.dart';
import 'package:coffee_bean/scenes/home/interactor/home_interactor.dart';
import 'package:coffee_bean/scenes/home/interactor/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeBuildable implements DbNoteBuildable {
  @override
  Widget build();
}

class HomeBuilder extends DbNoteBuilder implements HomeBuildable {
  @override
  Widget build() {
    final router = HomeRouter();
    final interactor = HomeInteractor(router);
    final page = HomePage();
    
    // Set showAppBar nếu cần thiết (giống product_list_builder)
    // page.showAppBar = showAppBarOnRootPage;

    rootPage = BlocProvider(
      create: (_) => interactor,
      child: page,
    );
    return rootPage;
  }
}
