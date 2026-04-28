import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/user.dart';

// -------------- EVENTS ---------------------

/// Event to trigger fetching the details of a specific user.
class UserDetailFetchEvent extends BaseBlocEvent {
  final int userId;
  UserDetailFetchEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

// -------------- STATES ---------------------

/// Initial state before any action is taken.
class UserDetailInitial extends BaseBlocState {}

/// State indicating that data is being fetched.
class UserDetailInProgress extends BaseBlocState {}

/// State representing a successful data fetch.
class UserDetailGetDataSuccess extends BaseBlocState {
  final User user;
  UserDetailGetDataSuccess(this.user);
  @override
  List<Object> get props => [user];
}

/// State representing an error during data fetch.
class UserDetailGetDataError extends BaseBlocState {
  final BaseError error;
  UserDetailGetDataError(this.error);
  @override
  List<Object> get props => [error];
}