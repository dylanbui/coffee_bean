import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/shopping/shopping_router.dart';

// Events
abstract class ShoppingEvent {}

// States
abstract class ShoppingState {}
class ShoppingInitial extends ShoppingState {}

class ShoppingInteractor extends Cubit<ShoppingState> {
  final ShoppingRoutable router;

  ShoppingInteractor(this.router) : super(ShoppingInitial());
}
