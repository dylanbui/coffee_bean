/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class UserLoginEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class UserLoginState extends BaseBlocState {}

class UserLoginInitial extends UserLoginState {}

class UserLoginSuccess extends UserLoginState {}

class UserLoginInProgress extends UserLoginState {
  final String message;
  UserLoginInProgress({this.message = "Loading..."});
}

class UserLoginFailure extends UserLoginState {
  final String error;
  UserLoginFailure({this.error = ""});
}



class UserLoginError extends UserLoginState {
  final String message;

  UserLoginError({this.message = ""});
}