import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';

// ----------- STATE ---------------
abstract class DialogDemoState extends BaseBlocState {}

class DialogDemoInitial extends DialogDemoState {}

class DialogDemoSuccess extends DialogDemoState {}

class DialogDemoError extends DialogDemoState {
  final String message;

  DialogDemoError({this.message = ""});

  @override
  List<Object?> get props => [message];
}
