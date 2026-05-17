import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_router.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBuilder extends DbNoteBuilder<HomeRouter> {
  @override
  HomeRouter build() {
    final router = HomeRouter();
    final interactor = HomeInteractor(router);
    final page = HomePage(interactor: interactor);

    router.attach(interactor, page);

    // Set showAppBar nếu cần thiết (giống product_list_builder)
    // page.showAppBar = showAppBarOnRootPage;

    return router;
  }
}
