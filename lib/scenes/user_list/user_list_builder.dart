import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/utils/locator.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/user_list/interactor/user_list_interactor.dart';
import 'package:coffee_bean/scenes/user_list/user_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Builder for the UserList module.
/// It's responsible for creating and wiring all the components of the module.
class UserListBuilder extends DbNoteBuilder {
  @override
  Widget build() {
    // Get the singleton instance of the repository from the service locator.
    final userRepository = locator.get<UserRepository>();
    // The page widget.
    final page = UserListPage();

    // The BLoC (Interactor) is created and provided to the widget tree.
    // The BLoC itself depends on the repository.
    return BlocProvider<UserListInteractor>(
      create: (context) => UserListInteractor(userRepository),
      child: page,
    );
  }
}