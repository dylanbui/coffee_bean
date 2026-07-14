import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/interactor/topic_selection_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/plugins/topic_selection_plugin/topic_selection_plugin_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicSelectionPluginWidget extends AppCubitStateFulWidget<TopicSelectionPluginInteractor, TopicSelectionState> {
  TopicSelectionPluginWidget({super.key, required super.interactor});

  @override
  State<TopicSelectionPluginWidget> createState() => _TopicSelectionPluginWidgetState();
}

class _TopicSelectionPluginWidgetState extends AppCubitState<TopicSelectionPluginWidget, TopicSelectionPluginInteractor, TopicSelectionState> {
  
  @override
  String? getTitle() => null;

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    // Plugin does not use Scaffold to avoid nested Scaffold issues when embedded
    return body;
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<TopicSelectionPluginInteractor, TopicSelectionState>(
      builder: (context, state) {
        if (state.isLoading && state.topics.isEmpty) {
          return Center(child: getLoadingView());
        }

        final leftCount = (state.topics.length + 1) ~/ 2;
        final leftTopics = state.topics.take(leftCount).toList();
        final rightTopics = state.topics.skip(leftCount).toList();

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: leftTopics.map((topic) => _buildTopicItem(topic, state.selectedIds.contains(topic.id))).toList(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: rightTopics.map((topic) => _buildTopicItem(topic, state.selectedIds.contains(topic.id))).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildBottomButtons(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopicItem(HotTopic topic, bool isSelected) {
    return GestureDetector(
      onTap: () => interactor.toggleTopic(topic.id),
      child: Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? TMLabsColor.primary.withValues(alpha: 0.1) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(22),
          border: isSelected ? Border.all(color: TMLabsColor.primary, width: 1) : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: DbCachedImageWidget(
                imageUrl: topic.topicIcon ?? '',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                topic.topicName ?? '',
                style: TMLabsTextStyle.body.copyWith(
                  fontSize: 12,
                  color: isSelected ? TMLabsColor.primary : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(TopicSelectionState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: AppButton(
              text: "BỎ QUA",
              height: 44,
              style: TMLabsButtonStyle.outline.copyWith(borderRadius: 22),
              onPressed: () => interactor.skip(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: AppButton(
              text: "XÁC NHẬN",
              height: 44,
              isLoading: state.isLoading,
              style: TMLabsButtonStyle.primary.copyWith(borderRadius: 22),
              onPressed: () => interactor.confirm(),
            ),
          ),
        ],
      ),
    );
  }
}
