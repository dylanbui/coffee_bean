/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 29/07/2022 - 17:56
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/commons_constants.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/product.dart';

// -------------- STATE ---------------------

abstract class ProductDetailState extends BaseBlocState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailInProgress extends ProductDetailState {}

class ProductDetailGetDataSuccess extends ProductDetailState {
  final Product item;

  ProductDetailGetDataSuccess(this.item);

  @override
  List<Object?> get props => [item];
}

class ProductDetailGetDataError extends ProductDetailState {
  final DbError error;

  ProductDetailGetDataError(this.error);

  @override
  List<Object?> get props => [error];
}
