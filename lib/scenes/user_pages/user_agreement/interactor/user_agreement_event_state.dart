/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:14
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class UserAgreementEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class UserAgreementState extends BaseBlocState {}

class UserAgreementInitial extends UserAgreementState {}

class UserAgreementSuccess extends UserAgreementState {}

class UserAgreementError extends UserAgreementState {
  final String message;

  UserAgreementError({this.message = ""});
}