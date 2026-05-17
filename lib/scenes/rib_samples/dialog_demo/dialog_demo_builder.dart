import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/dialog_demo_router.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DialogDemoBuildable implements DbNoteBuildable {}

class DialogDemoBuilder extends DbNoteBuilder<DialogDemoRouter> implements DialogDemoBuildable {
  @override
  DialogDemoRouter build() {
    final router = DialogDemoRouter();
    final interactor = DialogDemoInteractor(router);
    final page = DialogDemoPage(interactor: interactor);

    router.attach(interactor, BlocProvider.value(value: interactor, child: page));

    return router;
  }
}
