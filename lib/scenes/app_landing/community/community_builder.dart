import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_router.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityBuilder extends DbNoteBuilder<CommunityRouter> {
  @override
  CommunityRouter build() {
    final router = CommunityRouter();
    final interactor = CommunityInteractor(router);
    final page = CommunityPage(interactor: interactor);

    router.attach(interactor, BlocProvider<CommunityInteractor>.value(value: interactor, child: page));

    return router;
  }
}
