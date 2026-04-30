
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_router.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeBuildable implements DbNoteBuildable {
  @override
  ViewController build();
}

class HomeBuilder extends DbNoteBuilder implements HomeBuildable {
  @override
  ViewController build() {
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
