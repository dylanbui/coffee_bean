import 'package:coffee_bean/scenes/expert_apply/interactor/expert_apply_interactor.dart';
import 'package:coffee_bean/scenes/expert_apply/interactor/expert_apply_page.dart';
import 'package:db_core/db_core.dart';

// ROUTER
abstract class ExpertApplyRoutable implements DbNoteRoutable {}

class ExpertApplyRouter extends DbNoteRouter implements ExpertApplyRoutable {}

// BUILDER
class ExpertApplyBuilder extends DbNoteBuilder<ExpertApplyRouter> {

  @override
  ExpertApplyRouter build() {

    final router = ExpertApplyRouter();
    final interactor = ExpertApplyInteractor(router);
    final page = ExpertApplyPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}


