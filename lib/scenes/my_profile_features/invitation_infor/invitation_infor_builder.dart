import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/invitation_infor_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_infor/interactor/invitation_infor_page.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/invitation_ranking_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_record/invitation_record_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/invitation_reward_detail_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE INTERFACE
abstract class InvitationInforRoutable implements DbNoteRoutable {
  void openRanking();
  void openRewardDetail();
  void openUserProfile();
  void openInvitationRecord();
}

// ROUTER
class InvitationInforRouter extends DbNoteRouter implements InvitationInforRoutable {

  @override
  void openInvitationRecord() {
    final builder = InvitationRecordBuilder();
    push(builder.build().viewController);
  }

  @override
  void openRanking() {
    final builder = InvitationRankingBuilder();
    push(builder.build().viewController);
  }

  @override
  void openRewardDetail() {
    final builder = InvitationRewardDetailBuilder();
    push(builder.build().viewController);
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
