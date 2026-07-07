import 'package:coffee_bean/data/model/response/hub/feedback_info.dart';
import 'package:db_core/db_core.dart';

class FeedbackDetailState extends BaseBlocState {
  final FeedbackInfo? feedback;
  final bool isLoading;
  final String? errorMessage;

  FeedbackDetailState({
    this.feedback,
    this.isLoading = false,
    this.errorMessage,
  });

  FeedbackDetailState copyWith({
    FeedbackInfo? feedback,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FeedbackDetailState(
      feedback: feedback ?? this.feedback,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [feedback, isLoading, errorMessage];
}
