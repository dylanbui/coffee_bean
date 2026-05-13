/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class PrivacyPolicyEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class PrivacyPolicyState extends BaseBlocState {}

class PrivacyPolicyInitial extends PrivacyPolicyState {}

class PrivacyPolicySuccess extends PrivacyPolicyState {}

class PrivacyPolicyError extends PrivacyPolicyState {
  final String message;

  PrivacyPolicyError({this.message = ""});
}