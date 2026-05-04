/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 14:45
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/rib_samples/dialog_demo/dialog_demo_router.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/commons/state_management/lib_bloc/base_cubit_statefull_widget.dart';

// Interactor

class DialogDemoInteractor extends CubitInteractor<DialogDemoRouter, DialogDemoState> {

  DialogDemoInteractor(DialogDemoRouter router) : super(DialogDemoInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    loadData();
  }

  Future loadData() async {
    // emit(DialogDemoInProgress());
  }
}