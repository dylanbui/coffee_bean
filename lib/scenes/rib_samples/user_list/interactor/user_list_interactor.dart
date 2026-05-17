import 'dart:async';

import 'package:coffee_bean/core/commons_constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/bloc_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/rib_samples/user_list/interactor/user_list_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/user_list/user_list_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListInteractor extends BlocInteractor<UserListRoutable, BaseBlocEvent, BaseBlocState> {
  final UserRepository _userRepository;

  UserListInteractor(this._userRepository, UserListRoutable router) : super(UserListInitial(), router: router) {
    on<UserListFetchDataEvent>(_onFetchData);
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    add(UserListFetchDataEvent());
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
