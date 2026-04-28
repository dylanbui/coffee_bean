import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/user.dart';

// -------------- EVENTS ---------------------

/// Event to trigger fetching the list of users.
class UserListFetchDataEvent extends BaseBlocEvent {}

// -------------- STATES ---------------------

/// Initial state before any action is taken.
class UserListInitial extends BaseBlocState {}

/// State indicating that data is being fetched.
class UserListInProgress extends BaseBlocState {}

/// State representing a successful data fetch.
class UserListGetDataSuccess extends BaseBlocState {
  final List<User> users;
  UserListGetDataSuccess(this.users);
  @override
  List<Object> get props => [users];
}

/// State representing an error during data fetch.
class UserListGetDataError extends BaseBlocState {
  final BaseError error;
  UserListGetDataError(this.error);
  @override
  List<Object> get props => [error];
}