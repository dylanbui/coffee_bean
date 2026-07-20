import 'package:coffee_bean/scenes/my_profile_features/disable_user/interactor/disable_user_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/disable_user/interactor/disable_user_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class DisableUserRoutable implements DbNoteRoutable {}

class DisableUserRouter extends DbNoteRouter implements DisableUserRoutable {}

class DisableUserBuilder extends DbNoteBuilder<DisableUserRouter> {
  @override
  DisableUserRouter build() {
    final router = DisableUserRouter();
    final interactor = DisableUserInteractor(router);
    final page = DisableUserPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
