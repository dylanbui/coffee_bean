import 'package:db_core/architecture_ribs/note_interactor.dart';
import 'package:db_core/state_management/lib_provider/base_provider.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

class MainTabbarProviderInteractor extends BaseProvider<DbNoteRoutable> implements DbNoteInteractor<DbNoteRoutable> {
  MainTabbarProviderInteractor(super.router);
}
