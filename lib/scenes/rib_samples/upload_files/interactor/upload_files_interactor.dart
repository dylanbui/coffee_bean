import 'package:db_core/db_core.dart';
import 'package:coffee_bean/data/repository/upload_files_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/upload_files_router.dart';

/// Interactor for the UploadFiles module.
class UploadFilesInteractor extends CubitInteractor<UploadFilesRoutable, UploadFilesState> {
  final UploadFilesRepository _uploadRepository = locator.get<UploadFilesRepository>();

  UploadFilesInteractor(UploadFilesRoutable router) : super(UploadFilesInitial(), router: router);

  Future<void> uploadFile(String filePath) async {
    emit(const UploadFilesInProgress());

    final result = await _uploadRepository.uploadFile(
      filePath,
      onSendProgress: (sent, total) {
        if (total != -1) {
          final progress = sent / total;
          emit(UploadFilesProgress(progress));
        }
      },
    );

    if (result case DbSuccess(data: final message)) {
      emit(UploadFilesSuccess(message));
    } else if (result case DbFailure(:final error)) {
      emit(UploadFilesError(error));
    }
  }

  void resetState() {
    emit(UploadFilesInitial());
  }
}
