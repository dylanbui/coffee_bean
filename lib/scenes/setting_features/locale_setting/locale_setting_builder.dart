import 'package:coffee_bean/scenes/setting_features/locale_setting/interactor/locale_setting_interactor.dart';
import 'package:coffee_bean/scenes/setting_features/locale_setting/interactor/locale_setting_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class LocaleSettingRoutable implements DbNoteRoutable {
}

class LocaleSettingRouter extends DbNoteRouter implements LocaleSettingRoutable {
}


class LocaleSettingBuilder extends DbNoteBuilder<LocaleSettingRouter> {
  @override
  LocaleSettingRouter build() {
    final router = LocaleSettingRouter();
    final interactor = LocaleSettingInteractor(router: router);
    final page = LocaleSettingPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
