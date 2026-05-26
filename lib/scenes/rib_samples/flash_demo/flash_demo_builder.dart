import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/interactor/flash_demo_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/interactor/flash_demo_page.dart';
import 'package:coffee_bean/scenes/rib_samples/flash_demo/flash_demo_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FlashDemoBuildable implements DbNoteBuildable {}

class FlashDemoBuilder extends DbNoteBuilder<FlashDemoRouter> implements FlashDemoBuildable {
  @override
  FlashDemoRouter build() {
    final router = FlashDemoRouter();
    final interactor = FlashDemoInteractor(router);
    final page = FlashDemoPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }
}
