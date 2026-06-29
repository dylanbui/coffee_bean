/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 */

import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/commons_constants.dart';

// ----------- EVENT ---------------
abstract class AppAgreementEvent extends BaseBlocEvent {}

// ----------- STATE ---------------
abstract class AppAgreementState extends BaseBlocState {}

class AppAgreementInitial extends AppAgreementState {}

class AppAgreementInProgress extends AppAgreementState {}

class AppAgreementSuccess extends AppAgreementState {
  final Dictionary data;

  AppAgreementSuccess({required this.data});
}

class AppAgreementError extends AppAgreementState {
  final String message;

  AppAgreementError({this.message = ""});
}
