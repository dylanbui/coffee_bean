import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/commons/utils/locator.dart';
import 'package:coffee_bean/data/repository/upload_files_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/upload_files_router.dart';
import 'package:dio/dio.dart';

/// Interactor for the UploadFiles module.
/// Manages the business logic for file uploads.
class UploadFilesInteractor extends CubitInteractor<UploadFilesRoutable, UploadFilesState> {
  final UploadFilesRepository _uploadRepository = locator.get<UploadFilesRepository>();

  UploadFilesInteractor(UploadFilesRoutable router) : super(UploadFilesInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    // Any initial setup or data loading for the interactor.
  }

  /// Initiates the file upload process.
  /// [filePath] The path to the file to be uploaded.
  Future<void> uploadFile(String filePath) async {
    emit(const UploadFilesInProgress());

    final (message, error) = await _uploadRepository.uploadFile(
      filePath,
      onSendProgress: (sent, total) {
        if (total != -1) {
          final progress = sent / total;
          emit(UploadFilesProgress(progress));
        }
      },
    );

    if (message != null) {
      emit(UploadFilesSuccess(message));
    } else {
      emit(UploadFilesError(error ?? const BaseError(500, "Unknown upload error")));
    }
  }

  /// Resets the state to initial.
  void resetState() {
    emit(UploadFilesInitial());
  }
}