import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/interactor/main_tabbar_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_router.dart';

class MainTabbarInteractor extends CubitInteractor<MainTabbarRoutable, MainTabbarState> {
  MainTabbarInteractor(MainTabbarRoutable router) : super(const MainTabbarInitial(), router: router);

  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
