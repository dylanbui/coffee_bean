import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_page.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/upload_files_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Buildable interface for UploadFiles module
abstract class UploadFilesBuildable implements DbNoteBuildable {
  @override
  Widget build();
}

/// Builder for the UploadFiles module.
/// It's responsible for creating and wiring all the components of the module.
class UploadFilesBuilder extends DbNoteBuilder implements UploadFilesBuildable {
  @override
  Widget build() {
    final router = UploadFilesRouter();
    final interactor = UploadFilesInteractor(router);
    final page = UploadFilesPage();
    return BlocProvider(create: (_) => interactor, child: page);
  }
}