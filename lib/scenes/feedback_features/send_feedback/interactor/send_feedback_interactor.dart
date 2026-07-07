import 'dart:io';
import 'package:coffee_bean/data/repository/feedback_repository.dart';
import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/feedback_record_builder.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/send_feedback_builder.dart';
import 'package:coffee_bean/utils/image_utils.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/feedback_features/send_feedback/interactor/send_feedback_event_state.dart';

class SendFeedbackInteractor extends CubitInteractor<SendFeedbackRoutable, SendFeedbackState> {
  final FeedbackRepository _feedbackRepository = FeedbackRepository();
  final InfraRepository _infraRepository = InfraRepository();

  SendFeedbackInteractor(SendFeedbackRoutable router) : super(const SendFeedbackInitial(), router: router);

  void onTextChanged(String text) {
    emit(SendFeedbackUpdate(text: text, images: state.images));
  }

  void onImagePicked(String path) {
    final updatedImages = List<String>.from(state.images)..add(path);
    emit(SendFeedbackUpdate(text: state.text, images: updatedImages));
  }

  void onImagesPicked(List<String> paths) {
    final updatedImages = List<String>.from(state.images)..addAll(paths);
    emit(SendFeedbackUpdate(text: state.text, images: updatedImages));
  }

  void removeImage(int index) {
    final updatedImages = List<String>.from(state.images)..removeAt(index);
    emit(SendFeedbackUpdate(text: state.text, images: updatedImages));
  }

  // void goToFeedbackRecord() {
  //   router?.navigate(Fee());
  // }

  Future<void> sendFeedback({bool uploadParallel = true}) async {
    if (state.text.isEmpty) return;

    emit(SendFeedbackSubmitting(text: state.text, images: state.images));

    try {
      // 1. Nén ảnh và Upload ảnh lên server
      final List<String> uploadedUrls = [];
      if (state.images.isNotEmpty) {
        // Nén toàn bộ ảnh sang chuẩn FHD trước khi upload
        final List<File> imageFiles = state.images.map((path) => File(path)).toList();
        final compressedFiles = await ImageUtils.compressFHDImages(imageFiles);

        if (uploadParallel) {
          // Phiên bản Upload ĐỒNG THỜI (Parallel)
          // Sử dụng Future.wait để upload tất cả cùng lúc
          final uploadResults = await Future.wait(
            compressedFiles.map((file) => _infraRepository.uploadFile(file, directory: 'feedback')),
          );

          for (var result in uploadResults) {
            if (result case DbSuccess(:final data)) {
              uploadedUrls.add(data);
            }
            // Nếu lỗi (DbFailure) thì bỏ qua theo yêu cầu
          }
        } else {
          // Phiên bản Upload TUẦN TỰ (Sequential)
          for (var file in compressedFiles) {
            final uploadResult = await _infraRepository.uploadFile(file, directory: 'feedback');
            
            if (uploadResult case DbSuccess(:final data)) {
              uploadedUrls.add(data);
            } else if (uploadResult case DbFailure(:final error)) {
              emit(SendFeedbackError("Upload ảnh thất bại: ${error.message}", text: state.text, images: state.images));
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
        // Dọn dẹp file tạm sau khi thành công
        await ImageUtils.cleanTemporaryFiles();
        emit(const SendFeedbackSuccess());
      } else if (result case DbFailure(:final error)) {
        emit(SendFeedbackError(error.message, text: state.text, images: state.images));
      }

    } catch (e) {
      emit(SendFeedbackError(e.toString(), text: state.text, images: state.images));
    }
  }
}
