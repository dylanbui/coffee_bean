import 'package:coffee_bean/data/model/response/hub/feedback_info.dart';
import 'package:db_core/db_core.dart';

class FeedbackRecordState extends BaseBlocState {
  final List<FeedbackInfo> feedbacks;
  final bool isLoading;
  final String? errorMessage;

  FeedbackRecordState({
    this.feedbacks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FeedbackRecordState copyWith({
    List<FeedbackInfo>? feedbacks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FeedbackRecordState(
      feedbacks: feedbacks ?? this.feedbacks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [feedbacks, isLoading, errorMessage];
}

