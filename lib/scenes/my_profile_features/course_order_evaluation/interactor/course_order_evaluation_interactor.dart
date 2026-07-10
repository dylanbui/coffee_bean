import 'package:coffee_bean/scenes/my_profile_features/course_order_evaluation/course_order_evaluation_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_evaluation/interactor/course_order_evaluation_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/models/course_order_detail_model.dart';

class CourseOrderEvaluationInteractor extends CubitInteractor<CourseOrderEvaluationRoutable, CourseOrderEvaluationState> {
  
  CourseOrderEvaluationInteractor(CourseOrderEvaluationRoutable router, int orderId, CourseOrderDetailModel? orderData)
      : super(CourseOrderEvaluationState(orderId: orderId, orderData: orderData), router: router);

  void onRatingChanged(double rating) {
    emit(state.copyWith(rating: rating));
  }

  void onCommentChanged(String comment) {
    emit(state.copyWith(comment: comment));
  }

  void onImagesPicked(List<String> paths) {
    final updatedImages = List<String>.from(state.images)..addAll(paths);
    emit(state.copyWith(images: updatedImages));
  }

  void removeImage(int index) {
    final updatedImages = List<String>.from(state.images)..removeAt(index);
    emit(state.copyWith(images: updatedImages));
  }

  Future<void> submitEvaluation() async {
    if (state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Giả lập gọi API trong 3 giây
      await Future.delayed(const Duration(seconds: 3));
      
      emit(state.copyWith(isSubmitting: false));
      
      // Hiển thị dialog thông báo thành công (Page sẽ lắng nghe state hoặc gọi trực tiếp từ đây nếu có context, 
      // nhưng theo chuẩn RIBs TMLabs, Page nên xử lý hiển thị qua BlocListener hoặc callback)
      // Ở đây ta dùng router để xử lý logic hiển thị dialog nếu router hỗ trợ, hoặc báo về Page.
      // Theo yêu cầu user: "hiện dialog ... và button 'Xin cảm ơn', khi bấm vào button này gọi router?.pop()"
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
