import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_interactor.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_page.dart';
import 'package:coffee_bean/scenes/fan_follow_list/fan_follow_list_builder.dart';
import 'package:db_core/db_core.dart';

// ROUTER
abstract class ExpertProfileRoutable implements DbNoteRoutable {
  void openFanFollowList({int initialTabIndex = 0});
}

class ExpertProfileRouter extends DbNoteRouter implements ExpertProfileRoutable {
  @override
  void openFanFollowList({int initialTabIndex = 0}) {
    final fanFollowRouter = FanFollowListBuilder(initialTabIndex: initialTabIndex).build();
    push(fanFollowRouter.viewController);
  }
}

// BUILDER
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
