import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/topic_selection_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/topic_selection_page.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/plugins/topic_selection_plugin/topic_selection_plugin_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/plugins/topic_selection_plugin/topic_selection_plugin_widget.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_plugin.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';

abstract class TopicSelectionRoutable implements DbNoteRoutable {
  void onFinish(List<HotTopic> selected);
}

// Use for plugin TopicSelection
abstract interface class TopicSelectionPluginListener {
  void onTopicSelectionFinish(List<HotTopic>? selected);
}

// /// Class hỗ trợ truyền callback nhanh cho TopicSelectionPlugin
// class TopicSelectionCallbackListener implements TopicSelectionPluginListener {
//   final void Function(List<HotTopic>? selected) onFinish;
//   TopicSelectionCallbackListener(this.onFinish);
//
//   @override
//   void onTopicSelectionFinish(List<HotTopic>? selected) => onFinish(selected);
// }

class TopicSelectionPluginController extends DbPluginController<TopicSelectionPluginInteractor, TopicSelectionPluginListener> {
  void refresh() {
    interactor?.fetchTopics();
  }
}

abstract interface class TopicSelectionBuildable implements DbNoteBuildable {
  Widget buildPlugin(TopicSelectionPluginController controller);
}

class TopicSelectionRouter extends DbNoteRouter implements TopicSelectionRoutable {


  TopicSelectionRouter();

  @override
  void onFinish(List<HotTopic> selected) {

  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {

  }
}



class TopicSelectionBuilder extends DbNoteBuilder<TopicSelectionRouter> implements TopicSelectionBuildable {
  TopicSelectionBuilder();

  @override
  TopicSelectionRouter build() {
    final router = TopicSelectionRouter();
    final interactor = TopicSelectionInteractor(router);
    final page = TopicSelectionPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }

  @override
  Widget buildPlugin(TopicSelectionPluginController controller) {
    final router = TopicSelectionRouter();
    final interactor = TopicSelectionPluginInteractor(router, controller: controller);
    final page = TopicSelectionPluginWidget(interactor: interactor);
    router.attach(interactor, page);
    return router.viewController;
  }
}
