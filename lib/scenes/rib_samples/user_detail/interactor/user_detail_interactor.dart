import 'dart:async';

import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/commons_constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/bloc_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_presenter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailInteractor extends BlocPresenterInteractor<DbNoteRoutable, UserDetailPresenter, BaseBlocEvent, BaseBlocState> {
  // The constructor now receives the Presenter.
  UserDetailInteractor({required super.presenter, super.router}) : super(UserDetailInitial()) {
    on<UserDetailFetchEvent>(_onFetchData);
  }

  Future<void> _onFetchData(UserDetailFetchEvent event, Emitter<BaseBlocState> emit) async {
    emit(UserDetailInProgress());

    // No more null checks needed! `presenter` is guaranteed to be non-null.
    final (user, error) = await presenter.fetchUserDetail(event.userId);

    // Use pattern matching on the result tuple for cleaner, null-safe handling.
    switch ((user, error)) {
      case (final u?, null):
        emit(UserDetailGetDataSuccess(u));
      case (null, final e?):
        emit(UserDetailGetDataError(e));
      default:
        emit(UserDetailGetDataError(BaseError(111, "Invalid response from presenter.")));
    }
  }

  // @override
  // set presenter(UserDetailPresenter value) {
  //   // TODO: implement presenter
  // }
}