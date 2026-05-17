import 'dart:async';

import 'package:coffee_bean/core/commons_constants.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/bloc_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_presenter.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/user_detail_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailInteractor extends BlocPresenterInteractor<UserDetailRoutable, UserDetailPresenter, BaseBlocEvent, BaseBlocState> {
  final int userId;

  UserDetailInteractor({required this.userId, required super.presenter, super.router}) : super(UserDetailInitial()) {
    on<UserDetailFetchEvent>(_onFetchData);
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    // Tự động gọi fetch data khi module active
    add(UserDetailFetchEvent(userId));
  }

  Future<void> _onFetchData(UserDetailFetchEvent event, Emitter<BaseBlocState> emit) async {
    emit(UserDetailInProgress());

    final (user, error) = await presenter.fetchUserDetail(event.userId);

    if (user != null) {
      emit(UserDetailGetDataSuccess(user));
    } else {
      emit(UserDetailGetDataError(error ?? BaseError(111, "Invalid response from presenter.")));
    }
  }
}
