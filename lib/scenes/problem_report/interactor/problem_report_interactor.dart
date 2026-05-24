import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean/data/repository/file_repository.dart';
import 'package:coffee_bean/scenes/problem_report/problem_report_router.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_event_state.dart';

class ProblemReportInteractor extends CubitInteractor<ProblemReportRouter, ProblemReportState> {
  final FileRepository _fileRepository = FileRepository();

  ProblemReportInteractor(ProblemReportRouter router) : super(const ProblemReportInitial(), router: router);

  void onTextChanged(String text) {
    emit(ProblemReportUpdate(text: text, images: state.images));
  }

  void onImagePicked(String path) {
    final updatedImages = List<String>.from(state.images)..add(path);
    emit(ProblemReportUpdate(text: state.text, images: updatedImages));
  }

  void onImagesPicked(List<String> paths) {
    final updatedImages = List<String>.from(state.images)..addAll(paths);
    emit(ProblemReportUpdate(text: state.text, images: updatedImages));
  }

  void removeImage(int index) {
    final updatedImages = List<String>.from(state.images)..removeAt(index);
    emit(ProblemReportUpdate(text: state.text, images: updatedImages));
  }

  Future<void> submitReport() async {
    if (state.text.isEmpty) return;
    
    emit(ProblemReportSubmitting(text: state.text, images: state.images));
    try {
      // 1. Upload images to server first
      final List<String> uploadedUrls = [];
      for (var imagePath in state.images) {
        final result = await _fileRepository.uploadFile(imagePath);
        if (result != null && result.location != null) {
          uploadedUrls.add(result.location!);
        } else {
          throw Exception("Lỗi upload ảnh: $imagePath");
        }
      }

      // 2. Post data to "my server" (Simulate)
      final postData = {
        "content": state.text,
        "images": uploadedUrls,
      };
      iLog("Post data to my server: $postData");

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      emit(const ProblemReportSuccess());
    } catch (e) {
      emit(ProblemReportError(e.toString(), text: state.text, images: state.images));
    }
  }
}
