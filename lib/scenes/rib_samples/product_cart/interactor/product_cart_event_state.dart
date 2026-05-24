import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/local/live_service/model/cart_item.dart';

// -------------- STATE ---------------------

abstract class ProductCartState extends BaseBlocState {}

class ProductCartInitial extends ProductCartState {}

class ProductCartGetDataSuccess extends ProductCartState {
  final List<CartItem> items;
  final double totalAmount;

  ProductCartGetDataSuccess(this.items, this.totalAmount);

  @override
  List<Object?> get props => [items, totalAmount];
}
