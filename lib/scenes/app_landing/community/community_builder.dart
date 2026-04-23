import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_router.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CommunityBuildable implements DbNoteBuildable {
  @override
  Widget build();
}

class CommunityBuilder extends DbNoteBuilder implements CommunityBuildable {
  @override
  Widget build() {
    final router = CommunityRouter();
    final interactor = CommunityInteractor(router);
    final page = CommunityPage();
    
    rootPage = BlocProvider(
      create: (_) => interactor,
      child: page,
    );
    return rootPage;
  }
}
