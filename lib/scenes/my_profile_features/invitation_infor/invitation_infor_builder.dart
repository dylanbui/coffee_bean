import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/invitation_infor_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/invitation_infor_page.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/foundation.dart';

// ROUTABLE INTERFACE
abstract class InvitationInforRoutable implements DbNoteRoutable {
  void openPoster();
  void openInviteLink();
  void openRanking();
  void openUserProfile();
}

// ROUTER
class InvitationInforRouter extends DbNoteRouter implements InvitationInforRoutable {
  @override
  void openPoster() {
    debugPrint("Navigate to: My Invitation Poster");
  }

  @override
  void openInviteLink() {
    debugPrint("Navigate to: My Invitation Link");
  }

  @override
  void openRanking() {
    debugPrint("Navigate to: Invitation Ranking");
  }

  @override
  void openUserProfile() {
    final builder = UpdateProfileBuilder();
    push(builder.build().viewController);
  }
}

// BUILDER
class InvitationInforBuilder extends DbNoteBuilder<InvitationInforRouter> {
  InvitationInforBuilder();

  @override
  InvitationInforRouter build() {
    final router = InvitationInforRouter();
    final interactor = InvitationInforInteractor(router);
    final page = InvitationInforPage(interactor: interactor);
    
    // Wire RIBs components
    router.attach(interactor, page);
    
    return router;
  }
}
