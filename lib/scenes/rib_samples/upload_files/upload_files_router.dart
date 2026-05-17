import 'package:coffee_bean/core/architecture_ribs/note_router.dart';

abstract class UploadFilesRoutable implements DbNoteRoutable {}

class UploadFilesRouter extends DbNoteRouter implements UploadFilesRoutable {}
