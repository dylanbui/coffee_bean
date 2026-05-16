import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_router.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileBuilder extends DbNoteBuilder<MyProfileRouter> {
  @override
  MyProfileRouter build() {
    final router = MyProfileRouter();
    final interactor = MyProfileInteractor(router);
    final page = MyProfilePage(interactor: interactor);

    router.attach(interactor, BlocProvider<MyProfileInteractor>.value(value: interactor, child: page));

    return router;
  }
}
