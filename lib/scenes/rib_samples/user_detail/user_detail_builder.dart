import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_presenter.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_page.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/user_detail_router.dart';

/// Builder for the UserDetail module.
class UserDetailBuilder extends DbNoteBuilder<UserDetailRouter> {
  final int userId;

  UserDetailBuilder({required this.userId});

  @override
  UserDetailRouter build() {
    // 1. Get dependencies from the service locator.
    final userRepository = locator.get<UserRepository>();

    // 2. Create the Presenter, injecting the repository.
    final presenter = UserDetailPresenter(userRepository);

    // 3. Create the Router.
    final router = UserDetailRouter();

    // 4. Create the Interactor, injecting the userId, presenter, and router.
    final interactor = UserDetailInteractor(userId: userId, presenter: presenter, router: router);

    // 5. Create the Page, passing the interactor.
    final page = UserDetailPage(interactor: interactor);

    // 6. Connect everything.
    router.attach(interactor, page);

    return router;
  }
}
