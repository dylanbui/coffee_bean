import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/invitation_ranking_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/invitation_ranking_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE INTERFACE
abstract class InvitationRankingRoutable implements DbNoteRoutable {
  // Navigation methods if any
}

// ROUTER
class InvitationRankingRouter extends DbNoteRouter implements InvitationRankingRoutable {
  // Navigation implementation
}

// BUILDER
class InvitationRankingBuilder extends DbNoteBuilder<InvitationRankingRouter> {
  InvitationRankingBuilder();

  @override
  InvitationRankingRouter build() {
    final router = InvitationRankingRouter();
    final interactor = InvitationRankingInteractor(router);
    final page = InvitationRankingPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
