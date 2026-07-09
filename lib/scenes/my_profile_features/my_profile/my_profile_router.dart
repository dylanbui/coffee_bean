import 'package:coffee_bean/scenes/feedback_features/send_feedback/send_feedback_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/course_learning_list_builder.dart';
import 'package:coffee_bean/scenes/point_features/daily_sign_in/daily_sign_in_builder.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/settings_app_builder.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/activity_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/change_mobile/change_mobile_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/coupon_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/reservation_list_builder.dart';
import 'package:coffee_bean/features/app_map/app_map_builder.dart';
import 'package:coffee_bean/data/map_provider/app_map_contract.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:flutter/cupertino.dart';

class EditProfileRoute implements DbNoteRoute {}
class ChangeMobileRoute implements DbNoteRoute {}
class ReservationListRoute implements DbNoteRoute {}
class CourseLearningListRoute implements DbNoteRoute {}
class ActivityListRoute implements DbNoteRoute {}
class SettingsAppRoute implements DbNoteRoute {}
class CouponListRoute implements DbNoteRoute {}
class DailySignInRoute implements DbNoteRoute {}
class FeedbackRoute implements DbNoteRoute {}
class MapTestRoute implements DbNoteRoute {}


abstract class MyProfileRoutable implements DbNoteRoutable {
  void doLoginFlow(UserAuthFlowListener listener);
  void doRegisterFlow(UserAuthFlowListener listener);
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

    } else if (toRoute is CourseLearningListRoute) {
      final builder = CourseLearningListBuilder().build();
      push(builder.viewController);

    } else if (toRoute is ActivityListRoute) {
      final builder = ActivityListBuilder().build();
      push(builder.viewController);
      
    } else if (toRoute is SettingsAppRoute) {
      final builder = SettingsAppBuilder().build();
      push(builder.viewController);

    } else if (toRoute is CouponListRoute) {
      final builder = CouponListBuilder().build();
      push(builder.viewController);

    } else if (toRoute is DailySignInRoute) {
      final builder = DailySignInBuilder().build();
      push(builder.viewController);

    } else if (toRoute is FeedbackRoute) {
      final builder = SendFeedbackBuilder().build();
      push(builder.viewController);

    } else if (toRoute is MapTestRoute) {
      final marker = MapMarker(
        id: "tmlabs_coffee",
        location: const MapLocation(10.796993411873403, 106.7059799422638),
        title: "TMLabs Coffee",
        address: "84a Nguyễn Cửu Vân, Gia Định, Hồ Chí Minh, Vietnam",
      );
      final builder = AppMapBuilder(marker).build();
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


}
