/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class SetPasswordEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class SetPasswordState extends BaseBlocState {}

class SetPasswordInitial extends SetPasswordState {}

class SetPasswordInProgress extends SetPasswordState {}

class SetPasswordSuccess extends SetPasswordState {}

class SetPasswordError extends SetPasswordState {
  final String message;

  SetPasswordError({this.message = ""});
}