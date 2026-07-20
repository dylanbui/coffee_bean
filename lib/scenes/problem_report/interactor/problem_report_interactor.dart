import 'package:db_core/db_core.dart';
import 'package:coffee_bean/data/repository/file_repository.dart';
import 'package:coffee_bean/scenes/problem_report/problem_report_builder.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_event_state.dart';

class ProblemReportInteractor extends CubitInteractor<ProblemReportRouter, ProblemReportState> {
  final FileRepository _fileRepository = FileRepository();

  ProblemReportInteractor(ProblemReportRouter router) : super(ProblemReportState(), router: router);

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

  Future<void> submitReport() async {
    if (state.text.isEmpty) return;
    
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      // 1. Upload images
      final List<String> uploadedUrls = [];
      for (var imagePath in state.images) {
        final result = await _fileRepository.uploadFile(imagePath);
        if (result != null && result.location != null) {
          uploadedUrls.add(result.location!);
        } else {
          throw Exception("Lỗi upload ảnh: $imagePath");
        }
      }

      // 2. Post data (Simulate)
      final postData = {
        "content": state.text,
        "images": uploadedUrls,
      };
      iLog("Post data to my server: $postData");

      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
