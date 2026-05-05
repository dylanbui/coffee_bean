/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class ForgotPasswordEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class ForgotPasswordState extends BaseBlocState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordInProgress extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;

  ForgotPasswordError({this.message = ""});
}