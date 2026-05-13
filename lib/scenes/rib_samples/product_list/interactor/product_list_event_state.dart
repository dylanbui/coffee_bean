/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 29/07/2022 - 17:56
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/commons_constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/product.dart';

// -------------- EVENT ---------------------

// abstract class ProductListEvent extends BaseBlocEvent { }
//
// class ProductListGetDataEvent extends ProductListEvent {
//   // final List<ListingScorecardTypes> scorecardTypes;
//   // final Pair<DateTime, DateTime> rangeData;
//   // final String keySearch;
//   //
//   // ListingTabGetData({this.scorecardTypes, this.rangeData, this.keySearch});
// }
//
// class ProductListGetMoreDataEvent extends ProductListEvent {}
//
// class ProductListStartSearchingEvent extends ProductListEvent {}
//
// class ProductListCancelSearchingEvent extends ProductListEvent {}

// -------------- STATE ---------------------

abstract class ProductListState extends BaseBlocState {}

class ProductListInitial extends ProductListState {}

class ProductListInProgress extends ProductListState {}

class ProductListInLoadMoreProgress extends ProductListState {
  final List<Product> items;

  ProductListInLoadMoreProgress(this.items);

  @override
  List<Object> get props => [items];
}

class ProductListGetDataSuccess extends ProductListState {
  final List<Product> items;
  final bool hasReachedMax;
  final int totalItems;
  final int currentPage;

  ProductListGetDataSuccess(this.items, this.hasReachedMax, this.totalItems, this.currentPage);

  @override
  List<Object> get props => [items, hasReachedMax, totalItems];
}

class ProductListGetDataError<T extends BaseError> extends ProductListState {
  final T error;

  ProductListGetDataError(this.error);

  @override
  List<Object> get props => [error];
}
