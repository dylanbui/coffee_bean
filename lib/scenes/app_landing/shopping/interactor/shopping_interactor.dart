import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_router.dart';

// States
abstract class ShoppingState extends BaseBlocState {}
class ShoppingInitial extends ShoppingState {}

class ShoppingInteractor extends CubitInteractor<ShoppingRoutable, ShoppingState> {
  ShoppingInteractor(ShoppingRoutable router) : super(ShoppingInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    // Load initial shop data
  }
}
