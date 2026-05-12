import 'dart:async';

import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/splash_page/splash_page_builder.dart';

// --- STATES ---
// The states for the Splash screen. In this case, we only need an initial state.
abstract class SplashPageState extends BaseBlocState {}

class SplashPageInitial extends SplashPageState {}

// --- INTERACTOR (CUBIT) ---
class SplashPageInteractor extends CubitInteractor<DbNoteRoutable, SplashPageState> {
  // Constructor receives the router (which is the builder) and sets the initial state.
  SplashPageInteractor({required DbNoteRoutable router}) : super(SplashPageInitial(), router: router);

  /// Simulates fetching data and then notifies of completion.
  Future<void> fetchSomething() async {
    // Khong can xu ly o day nua
    // await Future.delayed(const Duration(seconds: 3));
    // // After waiting, command the router that the splash is complete.
    // router?.navigate(SplashPageCompleteRoute());
  }
}
