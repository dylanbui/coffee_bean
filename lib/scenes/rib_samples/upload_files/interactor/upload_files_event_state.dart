import 'package:coffee_bean/core/commons_constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:equatable/equatable.dart';

/// Base state for the UploadFiles module.
abstract class UploadFilesState extends Equatable implements BaseBlocState {
  const UploadFilesState();

  @override
  List<Object> get props => [];
}

/// Initial state before any upload action.
class UploadFilesInitial extends UploadFilesState {}

/// State indicating an upload operation is in progress.
class UploadFilesInProgress extends UploadFilesState {
  final String message;
  const UploadFilesInProgress({this.message = "Uploading..."});

  @override
  List<Object> get props => [message];
}

/// State indicating the upload is progressing with a percentage.
class UploadFilesProgress extends UploadFilesState {
  final double progress; // 0.0 to 1.0
  const UploadFilesProgress(this.progress);

  @override
  List<Object> get props => [progress];
}

/// State indicating a successful upload.
class UploadFilesSuccess extends UploadFilesState {
  final String message;
  const UploadFilesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// State indicating an error during upload.
class UploadFilesError extends UploadFilesState {
  final BaseError error;
  const UploadFilesError(this.error);

  @override
  List<Object> get props => [error];
}
