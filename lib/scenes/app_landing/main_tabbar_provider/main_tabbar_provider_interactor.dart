import 'package:coffee_bean/core/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_provider/base_provider.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';

class MainTabbarProviderInteractor extends BaseProvider<DbNoteRoutable> implements DbNoteInteractor<DbNoteRoutable> {
  MainTabbarProviderInteractor(super.router);
}
