import 'package:coffee_bean/scenes/rib_samples/flash_demo/flash_demo_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/interactor/flash_demo_event_state.dart';

class FlashDemoInteractor extends CubitInteractor<FlashDemoRoutable, FlashDemoState> {
  FlashDemoInteractor(FlashDemoRoutable router) : super(FlashDemoInitial(), router: router);

  void onValueSelected(String value) {
    emit(FlashDemoUpdate(selectedValue: value));
  }

  void updateSelectedValue(String value) {
    emit(FlashDemoUpdate(selectedValue: value));
  }
}
