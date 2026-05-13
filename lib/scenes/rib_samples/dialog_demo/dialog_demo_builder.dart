/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 14:45
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/dialog_demo_router.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Listener

// Buildable
abstract class DialogDemoBuildable implements DbNoteBuildable {
  @override
  ViewController build();
}

// Builder
class DialogDemoBuilder extends DbNoteBuilder implements DialogDemoBuildable {

  @override
  ViewController buildFactory() {
    final router = DialogDemoRouter();
    final interactor = DialogDemoInteractor(router);
    final page = DialogDemoPage();

    return BlocProvider(create: (_) => interactor, child: page);
  }

}