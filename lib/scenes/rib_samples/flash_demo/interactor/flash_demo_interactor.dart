import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';
import 'flash_demo_event_state.dart';

class FlashDemoInteractor extends CubitInteractor<DbNoteRoutable, FlashDemoState> {
  FlashDemoInteractor(DbNoteRoutable router) : super(const FlashDemoInitial());

  void onValueSelected(String value) {
    emit(FlashDemoUpdate(selectedValue: value));
  }
}
