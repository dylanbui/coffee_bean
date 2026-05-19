/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 23:22
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class UserGiftPackEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class UserGiftPackState extends BaseBlocState {}

class UserGiftPackInitial extends UserGiftPackState {}

class UserGiftPackInProgress extends UserGiftPackState {}

class UserGiftPackSuccess extends UserGiftPackState {}

class UserGiftPackError extends UserGiftPackState {
  final String message;

  UserGiftPackError({this.message = ""});
}