import 'package:coffee_bean/scenes/app_setting/interactor/app_setting_interactor.dart';
import 'package:coffee_bean/scenes/app_setting/interactor/app_setting_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class AppSettingRoutable implements DbNoteRoutable {
}

class AppSettingRouter extends DbNoteRouter implements AppSettingRoutable {
}


class AppSettingBuilder extends DbNoteBuilder<AppSettingRouter> {
  @override
  AppSettingRouter build() {
    final router = AppSettingRouter();
    final interactor = AppSettingInteractor(router: router);
    final page = AppSettingPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
