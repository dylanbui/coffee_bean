import 'package:coffee_bean/scenes/settings_app/interactor/settings_app_interactor.dart';
import 'package:coffee_bean/scenes/settings_app/interactor/settings_app_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class SettingsAppRoutable implements DbNoteRoutable {
}

class SettingsAppRouter extends DbNoteRouter implements SettingsAppRoutable {
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
