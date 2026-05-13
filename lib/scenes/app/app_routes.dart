// This file defines logical routes for navigation, especially for deep linking.
// They are simple data classes that carry the necessary parameters for a destination.


import 'package:coffee_bean/core/architecture_ribs/note_router.dart';

class SplashRoute implements DbNoteRoute {}

class UserDetailRoute implements DbNoteRoute {
  final int userId;
  UserDetailRoute({required this.userId});
}
