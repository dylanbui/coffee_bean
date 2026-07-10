import 'package:db_core/db_core.dart';

class SendFeedbackState extends BaseBlocState {
  final String text;
  final List<String> images;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  SendFeedbackState({
    this.text = '',
    this.images = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  SendFeedbackState copyWith({
    String? text,
    List<String>? images,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return SendFeedbackState(
      text: text ?? this.text,
      images: images ?? this.images,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage, // Reset if not provided
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [text, images, isSubmitting, errorMessage, isSuccess];
}

class SendFeedbackInitial extends SendFeedbackState {
  SendFeedbackInitial() : super();
}
