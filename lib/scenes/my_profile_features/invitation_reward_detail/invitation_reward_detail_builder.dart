import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/interactor/invitation_reward_detail_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/interactor/invitation_reward_detail_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE INTERFACE
abstract class InvitationRewardDetailRoutable implements DbNoteRoutable {
  // Define navigation methods if needed
}

// ROUTER
class InvitationRewardDetailRouter extends DbNoteRouter implements InvitationRewardDetailRoutable {
  // Navigation implementation
}

// BUILDER
class InvitationRewardDetailBuilder extends DbNoteBuilder<InvitationRewardDetailRouter> {
  InvitationRewardDetailBuilder();

  @override
  InvitationRewardDetailRouter build() {
    final router = InvitationRewardDetailRouter();
    final interactor = InvitationRewardDetailInteractor(router);
    final page = InvitationRewardDetailPage(interactor: interactor);
    
    // Wire RIBs components
    router.attach(interactor, page);
    
    return router;
  }
}
