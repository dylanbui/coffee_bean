/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class UserRegisterEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class UserRegisterState extends BaseBlocState {}

class UserRegisterInitial extends UserRegisterState {}

class UserRegisterInProgress extends UserRegisterState {}

class UserRegisterSuccess extends UserRegisterState {}

class UserRegisterError extends UserRegisterState {
  final String message;

  UserRegisterError({this.message = ""});
}