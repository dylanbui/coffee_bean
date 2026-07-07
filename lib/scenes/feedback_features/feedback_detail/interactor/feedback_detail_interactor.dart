import 'package:coffee_bean/data/repository/feedback_repository.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_detail/feedback_detail_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_detail/interactor/feedback_detail_event_state.dart';

class FeedbackDetailInteractor extends CubitInteractor<FeedbackDetailRoutable, FeedbackDetailState> {
  final FeedbackRepository _feedbackRepository = FeedbackRepository();
  final int feedbackId;

  FeedbackDetailInteractor(FeedbackDetailRoutable router, {required this.feedbackId}) 
      : super(FeedbackDetailState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchFeedbackDetail();
  }

  Future<void> fetchFeedbackDetail() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    final result = await _feedbackRepository.getFeedbackDetail(feedbackId);
    
    if (result case DbSuccess(:final data)) {
      emit(state.copyWith(isLoading: false, feedback: data));
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    }
  }
}
