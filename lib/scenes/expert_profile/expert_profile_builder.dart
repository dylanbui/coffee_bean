import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_interactor.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_page.dart';
import 'package:db_core/db_core.dart';

abstract class ExpertProfileRoutable implements DbNoteRoutable {}

class ExpertProfileRouter extends DbNoteRouter implements ExpertProfileRoutable {
}

class ExpertProfileBuilder extends DbNoteBuilder<ExpertProfileRouter> {
  final int? userId;

  ExpertProfileBuilder({this.userId});

  @override
  ExpertProfileRouter build() {
    final router = ExpertProfileRouter();
    final interactor = ExpertProfileInteractor(router, userId: userId);
    final page = ExpertProfilePage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
