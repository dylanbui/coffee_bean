import 'package:db_core/state_management/lib_bloc/constants.dart';

abstract class FlashDemoState extends BaseBlocState {
  final String selectedValue;
  FlashDemoState({this.selectedValue = ""});

  @override
  List<Object?> get props => [selectedValue];
}

class FlashDemoInitial extends FlashDemoState {
  FlashDemoInitial() : super();
}

class FlashDemoUpdate extends FlashDemoState {
  FlashDemoUpdate({required super.selectedValue});
}
