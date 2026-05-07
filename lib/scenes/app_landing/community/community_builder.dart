import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_router.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CommunityBuildable implements DbNoteBuildable { }

class CommunityBuilder extends DbNoteBuilder implements CommunityBuildable {
  @override
  ViewController buildFactory() {
    final router = CommunityRouter();
    final interactor = CommunityInteractor(router);
    final page = CommunityPage();

    return BlocProvider(create: (_) => interactor, child: page);
  }
}
