import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/my_profile/my_profile_router.dart';
import 'package:coffee_bean/scenes/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/my_profile/interactor/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MyProfileBuildable implements DbNoteBuildable {
  @override
  Widget build({bool showAppBarOnRootPage = true});
}

class MyProfileBuilder extends DbNoteBuilder implements MyProfileBuildable {
  @override
  Widget build({bool showAppBarOnRootPage = true}) {
    final router = MyProfileRouter();
    final interactor = MyProfileInteractor(router);
    final page = MyProfilePage();
    
    rootPage = BlocProvider(
      create: (_) => interactor,
      child: page,
    );
    return rootPage;
  }
}
