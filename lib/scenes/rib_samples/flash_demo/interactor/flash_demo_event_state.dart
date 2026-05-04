import 'package:equatable/equatable.dart';

abstract class FlashDemoState extends Equatable {
  final String selectedValue;
  const FlashDemoState({this.selectedValue = ""});

  @override
  List<Object?> get props => [selectedValue];
}

class FlashDemoInitial extends FlashDemoState {
  const FlashDemoInitial() : super();
}

class FlashDemoUpdate extends FlashDemoState {
  const FlashDemoUpdate({required super.selectedValue});
}
