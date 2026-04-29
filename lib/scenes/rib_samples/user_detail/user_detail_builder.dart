import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/utils/locator.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_presenter.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Builder for the UserDetail module.
class UserDetailBuilder extends DbNoteBuilder {
  final int userId;

  UserDetailBuilder({required this.userId});

  @override
  Widget build() {
    // 1. Get dependencies from the service locator.
    final userRepository = locator.get<UserRepository>();

    // 2. Create the Presenter, injecting the repository.
    final presenter = UserDetailPresenter(userRepository);

    // 3. Create the Page, passing the required user ID.
    final page = UserDetailPage(userId: userId);

    // 4. Create the Interactor, injecting the presenter, and provide it to the page.
    return BlocProvider<UserDetailInteractor>(create: (context) => UserDetailInteractor(presenter: presenter), child: page);
  }
}