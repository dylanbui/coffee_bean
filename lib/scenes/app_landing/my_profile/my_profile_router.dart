import 'package:coffee_bean/scenes/course_features/course_list/course_list_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/activity_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/change_mobile_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/reservation_list_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:flutter/cupertino.dart';

class EditProfileRoute implements DbNoteRoute {}
class ChangeMobileRoute implements DbNoteRoute {}
class ReservationListRoute implements DbNoteRoute {}
class CourseListRoute implements DbNoteRoute {}
class ActivityListRoute implements DbNoteRoute {}


abstract class MyProfileRoutable implements DbNoteRoutable {
  void doLoginFlow(UserAuthFlowListener listener);
  void doRegisterFlow(UserAuthFlowListener listener);
  void doLogout();
}

class MyProfileRouter extends DbNoteRouter implements MyProfileRoutable {
  
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ChangeMobileRoute) {
      final builder = ChangeMobileBuilder().build();
      push(builder.viewController);

    } else if (toRoute is EditProfileRoute) {
      final builder = UpdateProfileBuilder().build();
      push(builder.viewController);

    } else if (toRoute is ReservationListRoute) {
      final builder = ReservationListBuilder().build();
      push(builder.viewController);

    } else if (toRoute is CourseListRoute) {
      final builder = CourseListBuilder().build();
      push(builder.viewController);

    } else if (toRoute is ActivityListRoute) {
      final builder = ActivityListBuilder().build();
      push(builder.viewController);
    }

  }

  @override
  void doLoginFlow(UserAuthFlowListener listener) {
    // Khởi chạy luồng Auth bắt đầu từ Login
    UserAuthFlow(startStep: AuthStartStep.login).start(this, listener);
  }

  @override
  void doRegisterFlow(UserAuthFlowListener listener) {
    // Khởi chạy luồng Auth bắt đầu từ Login
    UserAuthFlow(startStep: AuthStartStep.register).start(this, listener);
  }

  @override
  void doLogout() {
    // Route to other after logout
    debugPrint("doLogout");
  }


}
