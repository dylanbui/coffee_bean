import 'package:coffee_bean/core/architecture_ribs/note_router.dart';

abstract class UserListRoutable implements DbNoteRoutable {}

class UserListRouter extends DbNoteRouter implements UserListRoutable {}
