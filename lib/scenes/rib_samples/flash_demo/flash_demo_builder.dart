import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/interactor/flash_demo_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/interactor/flash_demo_page.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/flash_demo_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FlashDemoBuildable implements DbNoteBuildable {
  // @override
  // Widget build({bool showAppBarOnRootPage = true});
}

class FlashDemoBuilder extends DbNoteBuilder implements FlashDemoBuildable {
  @override
  Widget buildFactory() {
    final router = FlashDemoRouter();
    final interactor = FlashDemoInteractor(router);
    final page = FlashDemoPage();
    return BlocProvider(create: (_) => interactor, child: page);
  }
}
