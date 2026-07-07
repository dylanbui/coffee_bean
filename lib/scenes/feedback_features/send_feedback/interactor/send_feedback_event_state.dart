import 'package:equatable/equatable.dart';

abstract class SendFeedbackState extends Equatable {
  final String text;
  final List<String> images;
  
  const SendFeedbackState({this.text = '', this.images = const []});

  @override
  List<Object?> get props => [text, images];
}

class SendFeedbackInitial extends SendFeedbackState {
  const SendFeedbackInitial() : super();
}

class SendFeedbackUpdate extends SendFeedbackState {
  const SendFeedbackUpdate({super.text, super.images});
}

class SendFeedbackSubmitting extends SendFeedbackState {
  const SendFeedbackSubmitting({super.text, super.images});
}

class SendFeedbackSuccess extends SendFeedbackState {
  const SendFeedbackSuccess() : super();
}

class SendFeedbackError extends SendFeedbackState {
  final String message;
  const SendFeedbackError(this.message, {super.text, super.images});

  @override
  List<Object?> get props => [...super.props, message];
}
