import 'dart:io';
import 'package:coffee_bean/data/repository/feedback_repository.dart';
import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/send_feedback_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/interactor/send_feedback_event_state.dart';

class SendFeedbackInteractor extends CubitInteractor<SendFeedbackRoutable, SendFeedbackState> {
  final FeedbackRepository _feedbackRepository = FeedbackRepository();
  final InfraRepository _infraRepository = InfraRepository();

  SendFeedbackInteractor(SendFeedbackRoutable router) : super(SendFeedbackInitial(), router: router);

  void onTextChanged(String text) {
    emit(state.copyWith(text: text));
  }

  void onImagePicked(String path) {
    final updatedImages = List<String>.from(state.images)..add(path);
    emit(state.copyWith(images: updatedImages));
  }

  void onImagesPicked(List<String> paths) {
    final updatedImages = List<String>.from(state.images)..addAll(paths);
    emit(state.copyWith(images: updatedImages));
  }

  void removeImage(int index) {
    final updatedImages = List<String>.from(state.images)..removeAt(index);
    emit(state.copyWith(images: updatedImages));
  }

  Future<void> sendFeedback({bool uploadParallel = true}) async {
    if (state.text.isEmpty) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null, isSuccess: false));

    try {
      // 1. Upload ảnh lên server (Tự động nén bên trong Repo)
      final List<String> uploadedUrls = [];
      if (state.images.isNotEmpty) {
        final List<File> imageFiles = state.images.map((path) => File(path)).toList();

        if (uploadParallel) {
          // Phiên bản Upload ĐỒNG THỜI (Parallel)
          final uploadResults = await Future.wait(
            imageFiles.map((file) => _infraRepository.uploadFile(file, directory: 'feedback')),
          );

          for (var result in uploadResults) {
            if (result case DbSuccess(:final data)) {
              uploadedUrls.add(data);
            }
          }
        } else {
          // Phiên bản Upload TUẦN TỰ (Sequential)
          for (var file in imageFiles) {
            final uploadResult = await _infraRepository.uploadFile(file, directory: 'feedback');
            
            if (uploadResult case DbSuccess(:final data)) {
              uploadedUrls.add(data);
            } else if (uploadResult case DbFailure(:final error)) {
              emit(state.copyWith(isSubmitting: false, errorMessage: "Upload ảnh thất bại: ${error.message}"));
              return;
            }
          }
        }
      }

      // 2. Gửi request tạo Feedback
      final result = await _feedbackRepository.createFeedback(
        content: state.text,
        images: uploadedUrls,
      );

      if (result case DbSuccess()) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else if (result case DbFailure(:final error)) {
        emit(state.copyWith(isSubmitting: false, errorMessage: error.message));
      }

    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
