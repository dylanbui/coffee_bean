import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/interactor/update_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class UpdateProfileRoutable implements DbNoteRoutable {

}

class UpdateProfileRouter extends DbNoteRouter implements UpdateProfileRoutable {

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
