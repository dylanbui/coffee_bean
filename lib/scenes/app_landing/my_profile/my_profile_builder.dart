import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_router.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MyProfileBuildable implements DbNoteBuildable { }

class MyProfileBuilder extends DbNoteBuilder implements MyProfileBuildable {

  @override
  ViewController buildFactory({bool showAppBarOnRootPage = true}) {
    final router = MyProfileRouter();
    final interactor = MyProfileInteractor(router);
    final page = MyProfilePage();

    return BlocProvider(create: (_) => interactor, child: page);
  }
}
