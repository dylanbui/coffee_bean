/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/global_search/global_search_router.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_interactor.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_page.dart';

// Listener

// Buildable
abstract class GlobalSearchBuildable implements DbNoteBuildable {
  GlobalSearchRouter build();
}

// Builder
class GlobalSearchBuilder extends DbNoteBuilder<GlobalSearchRouter> implements GlobalSearchBuildable {

  @override
  GlobalSearchRouter build() {
    final router = GlobalSearchRouter();
    final interactor = GlobalSearchInteractor(router);
    final page = GlobalSearchPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }

}