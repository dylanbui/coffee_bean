import 'package:db_core/architecture_ribs/note_router.dart';

abstract class UserDetailRoutable implements DbNoteRoutable {}

class UserDetailRouter extends DbNoteRouter implements UserDetailRoutable {}
