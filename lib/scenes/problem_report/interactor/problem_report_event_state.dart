import 'package:db_core/db_core.dart';

class ProblemReportState extends BaseBlocState {
  final String text;
  final List<String> images;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  ProblemReportState({
    this.text = '',
    this.images = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ProblemReportState copyWith({
    String? text,
    List<String>? images,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ProblemReportState(
      text: text ?? this.text,
      images: images ?? this.images,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage, // Sẽ reset về null nếu không truyền
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [text, images, isSubmitting, errorMessage, isSuccess];
}
