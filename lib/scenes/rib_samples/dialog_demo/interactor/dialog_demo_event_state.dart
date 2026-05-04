/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 14:45
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class DialogDemoEvent extends BaseBlocEvent {}


// ----------- STATE ---------------
abstract class DialogDemoState extends BaseBlocState {}

class DialogDemoInitial extends DialogDemoState {}

class DialogDemoSuccess extends DialogDemoState {}

class DialogDemoError extends DialogDemoState {
  final String message;

  DialogDemoError({this.message = ""});
}