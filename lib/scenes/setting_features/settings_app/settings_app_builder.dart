import 'package:coffee_bean/scenes/setting_features/locale_setting/locale_setting_builder.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/interactor/settings_app_interactor.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/interactor/settings_app_page.dart';
import 'package:coffee_bean/scenes/user_auth_features/privacy_policy/privacy_policy_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_agreement/user_agreement_builder.dart';
import 'package:db_core/db_core.dart';

abstract class SettingsAppRoutable implements DbNoteRoutable {
  void routeToLanguageSetting();
  void routeToUserAgreement();
  void routeToPrivacyPolicy();
  void doLogout();
}

class SettingsAppRouter extends DbNoteRouter implements SettingsAppRoutable {
  @override
  void routeToLanguageSetting() {
    final builder = LocaleSettingBuilder();
    push(builder.build().viewController);
  }

  @override
  void routeToUserAgreement() {
    final builder = UserAgreementBuilder();
    push(builder.build().viewController);
  }

  @override
  void routeToPrivacyPolicy() {
    final builder = PrivacyPolicyBuilder();
    push(builder.build().viewController);
  }

  @override
  void doLogout() {

  }
}


class SettingsAppBuilder extends DbNoteBuilder<SettingsAppRouter> {
  @override
  SettingsAppRouter build() {
    final router = SettingsAppRouter();
    final interactor = SettingsAppInteractor(router: router);
    final page = SettingsAppPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
