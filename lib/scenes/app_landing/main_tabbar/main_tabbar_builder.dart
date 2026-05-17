import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_router.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_page.dart';

class MainTabbarBuilder extends DbNoteBuilder<MainTabbarRouter> {
  @override
  MainTabbarRouter build() {
    final router = MainTabbarRouter();
    final interactor = MainTabbarInteractor(router);
    final page = MainTabbarPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }
}
