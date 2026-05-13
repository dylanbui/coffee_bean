/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 23:22
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/user_gift_pack/interactor/user_gift_pack_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/base_cubit_statefull_widget.dart';

// Interactor

class UserGiftPackInteractor extends CubitInteractor<DbNoteRoutable, UserGiftPackState> {

  UserGiftPackInteractor({DbNoteRoutable? router}) : super(UserGiftPackInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(UserGiftPackInProgress());
  }
}