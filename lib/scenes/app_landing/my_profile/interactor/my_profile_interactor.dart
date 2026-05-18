import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_router.dart';

// States
abstract class MyProfileState extends BaseBlocState {}
class MyProfileInitial extends MyProfileState {}

class MyProfileInteractor extends CubitInteractor<MyProfileRoutable, MyProfileState> {
  MyProfileInteractor(MyProfileRoutable router) : super(MyProfileInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    // Load initial profile data
  }

  void doLogout() {
    // TODO: clean user data
    router?.doLogout();
  }
}
