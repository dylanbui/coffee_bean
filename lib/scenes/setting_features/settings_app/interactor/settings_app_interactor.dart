import 'dart:async';
import 'dart:ui';
import 'package:coffee_bean/data/local/user_manager/user_service.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/settings_app_builder.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/interactor/settings_app_event_state.dart';
import 'package:db_core/db_core.dart';

class SettingsAppInteractor extends CubitInteractor<SettingsAppRoutable, SettingsAppState> {
  SettingsAppInteractor({required SettingsAppRoutable router}) : super(SettingsAppInitial(), router: router,);

  void routeToLanguageSetting() => router?.routeToLanguageSetting();
  void routeToUserAgreement() => router?.routeToUserAgreement();
  void routeToPrivacyPolicy() => router?.routeToPrivacyPolicy();

  Future<void> doLogout({required VoidCallback onSuccess}) async {
    await UserService().logout(onSuccess: () => onSuccess.call());
  }
}
