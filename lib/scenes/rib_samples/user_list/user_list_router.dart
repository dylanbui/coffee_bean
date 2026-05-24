import 'package:db_core/architecture_ribs/note_router.dart';

abstract class UserListRoutable implements DbNoteRoutable {}

class UserListRouter extends DbNoteRouter implements UserListRoutable {}
