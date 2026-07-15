import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/topic_selection_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/topic_selection_page.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/plugins/topic_selection_plugin/topic_selection_plugin_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/plugins/topic_selection_plugin/topic_selection_plugin_widget.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_plugin.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';

// TODO: Refactor needed - The UI and logic in TopicSelectionPage and TopicSelectionPluginWidget 
// are nearly identical. Consider unifying them into a shared widget or mixin in the future.


// PLUGIN
// Use for plugin TopicSelection
abstract interface class TopicSelectionListener {
  void onTopicSelectionFinish(List<HotTopic>? selected);
}

class TopicSelectionPluginController extends DbPluginController<TopicSelectionPluginInteractor, TopicSelectionListener> {
  void refresh() {
    interactor?.fetchTopics();
  }
}

abstract interface class TopicSelectionBuildable implements DbNoteBuildable {
  Widget buildPlugin(TopicSelectionPluginController controller);
}

// ROUTER
abstract class TopicSelectionRoutable implements DbNoteRoutable {
  void onFinish(List<HotTopic> selected);
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

// BUILDER
class TopicSelectionBuilder extends DbNoteBuilder<TopicSelectionRouter> implements TopicSelectionBuildable {
  final TopicSelectionListener? listener;
  TopicSelectionBuilder({this.listener});

  @override
  TopicSelectionRouter build() {
    final router = TopicSelectionRouter();
    final interactor = TopicSelectionInteractor(router, listener: listener);
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
