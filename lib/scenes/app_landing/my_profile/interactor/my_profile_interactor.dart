import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/data/local/user_session.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_router.dart';

// States
abstract class MyProfileState extends BaseBlocState {
  final bool isLoggedIn;
  MyProfileState({this.isLoggedIn = false});

  @override
  List<Object?> get props => [isLoggedIn];
}

class MyProfileInitial extends MyProfileState {
  MyProfileInitial() : super(isLoggedIn: false);
}

class MyProfileLoaded extends MyProfileState {
  MyProfileLoaded({required super.isLoggedIn});
}

class MyProfileInteractor extends CubitInteractor<MyProfileRoutable, MyProfileState> {
  MyProfileInteractor(MyProfileRoutable router) : super(MyProfileInitial(), router: router);

  @override
  void onDidBecomeActive() async {
    super.onDidBecomeActive();
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final session = await UserSession.fromSystem();
    emit(MyProfileLoaded(isLoggedIn: session.isLogin()));
  }

  void doLogout() async {
    await UserSession.doLogout();
    await checkLoginStatus();
    router?.doLogout();
  }
}
