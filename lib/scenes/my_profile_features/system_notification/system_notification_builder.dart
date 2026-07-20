import 'package:coffee_bean/scenes/my_profile_features/system_notification/interactor/system_notification_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/system_notification/interactor/system_notification_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE INTERFACE
abstract class SystemNotificationRoutable implements DbNoteRoutable {
  // Define navigation methods here if needed
}

// ROUTER
class SystemNotificationRouter extends DbNoteRouter implements SystemNotificationRoutable {
  // Navigation implementations
}

// BUILDER
class SystemNotificationBuilder extends DbNoteBuilder<SystemNotificationRouter> {
  SystemNotificationBuilder();

  @override
  SystemNotificationRouter build() {
    final router = SystemNotificationRouter();
    final interactor = SystemNotificationInteractor(router);
    final page = SystemNotificationPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
