import 'dart:async';

import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/bloc_interactor.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/user_list/interactor/user_list_event_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListInteractor extends BlocInteractor<DbNoteRoutable, BaseBlocEvent, BaseBlocState> {
  final UserRepository _userRepository;

  UserListInteractor(this._userRepository) : super(UserListInitial(), router: null) {
    on<UserListFetchDataEvent>(_onFetchData);
  }

  Future<void> _onFetchData(UserListFetchDataEvent event, Emitter<BaseBlocState> emit) async {
    emit(UserListInProgress());
    final (users, error) = await _userRepository.fetchUsers();

    if (users != null) {
      emit(UserListGetDataSuccess(users));
    } else {
      emit(UserListGetDataError(error ?? BaseError(333, 'An unknown error occurred')));
    }
  }
}