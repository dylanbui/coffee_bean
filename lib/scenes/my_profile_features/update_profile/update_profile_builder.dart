import 'package:coffee_bean/scenes/my_profile_features/disable_user/disable_user_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_page.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class UpdateProfileRoutable implements DbNoteRoutable {
  void routeToDisableUser();
}

class UpdateProfileRouter extends DbNoteRouter implements UpdateProfileRoutable {
  @override
  void routeToDisableUser() {
    final builder = DisableUserBuilder();
    push(builder.build().viewController);
  }
}


class UpdateProfileBuilder extends DbNoteBuilder<UpdateProfileRouter> {
  @override
  UpdateProfileRouter build() {
    final router = UpdateProfileRouter();
    final interactor = UpdateProfileInteractor(router);
    final page = UpdateProfilePage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
