import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_router.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainTabbarBuilder extends DbNoteBuilder<MainTabbarRouter> {
  @override
  MainTabbarRouter build() {
    final router = MainTabbarRouter();
    final interactor = MainTabbarInteractor(router);
    final page = MainTabbarPage(interactor: interactor);

    router.attach(interactor, page);
    // Thay đổi dòng router.attach
    // router.attach(interactor, BlocProvider.value(value: interactor, child: page));

    return router;
  }
}
