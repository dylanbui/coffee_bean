import 'package:coffee_bean/scenes/setting_features/locale_setting/locale_setting_builder.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/interactor/settings_app_interactor.dart';
import 'package:coffee_bean/scenes/setting_features/settings_app/interactor/settings_app_page.dart';
import 'package:coffee_bean/scenes/user_auth_features/app_agreement/app_agreement_builder.dart';
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
    final builder = AppAgreementBuilder(type: 3, title: "User Agreement");
    push(builder.build().viewController, transitionType: PageTransitionType.bottomToTop);
  }

  @override
  void routeToPrivacyPolicy() {
    final builder = AppAgreementBuilder(type: 4, title: "Privacy Policy");
    push(builder.build().viewController, transitionType: PageTransitionType.bottomToTop);
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
