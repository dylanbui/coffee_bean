import 'package:coffee_bean/scenes/course_features/create_course_application/create_course_application_builder.dart';
import 'package:coffee_bean/scenes/expert_apply/expert_apply_builder.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_interactor.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_page.dart';
import 'package:coffee_bean/scenes/fan_follow_list/fan_follow_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:db_core/db_core.dart';

// ROUTER
abstract class ExpertProfileRoutable implements DbNoteRoutable {
  void pushFanFollowList({int initialTabIndex = 0});
  void pushCreateCourseApplication();
  void pushExpertApply();
  void pushUpdateProfile();
}

class ExpertProfileRouter extends DbNoteRouter implements ExpertProfileRoutable {
  @override
  void pushFanFollowList({int initialTabIndex = 0}) {
    final fanFollowRouter = FanFollowListBuilder(initialTabIndex: initialTabIndex).build();
    push(fanFollowRouter.viewController);
  }

  @override
  void pushCreateCourseApplication() {
    final builder = CreateCourseApplicationBuilder();
    push(builder.build().viewController);
  }

  @override
  void pushExpertApply() {
    final builder = ExpertApplyBuilder();
    push(builder.build().viewController);
  }

  @override
  void pushUpdateProfile() {
    final builder = UpdateProfileBuilder();
    push(builder.build().viewController);
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
