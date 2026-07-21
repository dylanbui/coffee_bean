import 'package:coffee_bean/scenes/my_profile_features/invitation_record/interactor/invitation_record_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_record/interactor/invitation_record_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE INTERFACE
abstract class InvitationRecordRoutable implements DbNoteRoutable {
  // Add navigation methods here if needed
}

// ROUTER
class InvitationRecordRouter extends DbNoteRouter implements InvitationRecordRoutable {
  // Navigation implementation
}

// BUILDER
class InvitationRecordBuilder extends DbNoteBuilder<InvitationRecordRouter> {
  InvitationRecordBuilder();

  @override
  InvitationRecordRouter build() {
    final router = InvitationRecordRouter();
    final interactor = InvitationRecordInteractor(router);
    final page = InvitationRecordPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
