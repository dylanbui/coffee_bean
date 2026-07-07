import 'package:coffee_bean/data/repository/feedback_repository.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_detail/feedback_detail_builder.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/feedback_record_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/interactor/feedback_record_event_state.dart';

class FeedbackRecordInteractor extends CubitInteractor<FeedbackRecordRoutable, FeedbackRecordState> {
  final FeedbackRepository _feedbackRepository = FeedbackRepository();

  FeedbackRecordInteractor(FeedbackRecordRoutable router) : super(FeedbackRecordState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchFeedbacks();
  }


  Future<void> fetchFeedbacks() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    final result = await _feedbackRepository.getMyFeedbacks();
    
    if (result case DbSuccess(:final data)) {
      emit(state.copyWith(isLoading: false, feedbacks: data.list));
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    }
  }
}
