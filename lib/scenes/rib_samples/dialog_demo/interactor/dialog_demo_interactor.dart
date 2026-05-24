import 'package:coffee_bean/scenes/rib_samples/dialog_demo/dialog_demo_router.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_event_state.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

class DialogDemoInteractor extends CubitInteractor<DialogDemoRoutable, DialogDemoState> {
  DialogDemoInteractor(DialogDemoRoutable router) : super(DialogDemoInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(DialogDemoInProgress());
  }
}
