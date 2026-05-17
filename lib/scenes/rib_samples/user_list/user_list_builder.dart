import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/user_list/interactor/user_list_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/user_list/interactor/user_list_page.dart';
import 'package:coffee_bean/scenes/rib_samples/user_list/user_list_router.dart';

class UserListBuilder extends DbNoteBuilder<UserListRouter> {
  @override
  UserListRouter build() {
    final userRepository = locator.get<UserRepository>();
    final router = UserListRouter();
    final interactor = UserListInteractor(userRepository, router);
    final page = UserListPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }
}
