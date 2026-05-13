/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/global_search/global_search_router.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_interactor.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Listener

// Buildable
abstract class GlobalSearchBuildable implements DbNoteBuildable {
  @override
  ViewController build();
}

// Builder
class GlobalSearchBuilder extends DbNoteBuilder implements GlobalSearchBuildable {

  @override
  ViewController buildFactory() {
    final router = GlobalSearchRouter();
    final interactor = GlobalSearchInteractor(router);
    final page = GlobalSearchPage();

    return BlocProvider(create: (_) => interactor, child: page);
  }

}