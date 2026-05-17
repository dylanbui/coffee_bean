import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_page.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/upload_files_router.dart';

class UploadFilesBuilder extends DbNoteBuilder<UploadFilesRouter> {
  @override
  UploadFilesRouter build() {
    final router = UploadFilesRouter();
    final interactor = UploadFilesInteractor(router);
    final page = UploadFilesPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }
}
