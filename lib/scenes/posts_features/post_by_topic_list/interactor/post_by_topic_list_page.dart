import 'package:coffee_bean/data/model/response/hub/topic_detail.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_builder.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/post_by_topic_list_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/interactor/post_by_topic_list_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_by_topic_list/widgets/topic_post_item.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/utils/extensions.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_sliding_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostByTopicListPage extends AppCubitStateFulWidget<PostByTopicListInteractor, PostByTopicListState> {
  PostByTopicListPage({super.key, required super.interactor});

  @override
  State<PostByTopicListPage> createState() => _PostByTopicListPageState();
}

class _PostByTopicListPageState extends AppCubitState<PostByTopicListPage, PostByTopicListInteractor, PostByTopicListState> {
  
  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<PostByTopicListInteractor, PostByTopicListState>(
      builder: (context, state) {
        final topic = state.topic;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              _buildCustomAppBar(topic),
              _buildFilterBar(state),
              Expanded(
                child: Container(
                  color: TMLabsColor.bgMain,
                  child: FadeSwitcher(
                    stateKey: state.isLoading && state.posts.isEmpty
                        ? 'loading'
                        : 'content_${state.currentTabIndex}',
                    child: state.isLoading && state.posts.isEmpty
                        ? getLoadingView()
                        : Stack(
                            children: [
                              _buildPostGrid(state),
                              if (state.isLoading && state.posts.isNotEmpty)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    child: getLoadingView(),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomAppBar(TopicDetail? topic) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 8, left: 8, right: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: TMLabsColor.bgLight, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => interactor.router?.pop(),
          ),
          const SizedBox(width: 8),
          AvatarWidget(
            imageUrl: topic?.topicIcon ?? '',
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  topic?.topicName ?? '',
                  style: TMLabsTextStyle.bodyBold.copyWith(color: TMLabsColor.primary, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      "${topic?.topicPostCount?.formatCompact() ?? 0} bài viết",
                      style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${topic?.topicViewCount?.formatCompact() ?? 0} lượt xem",
                      style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(PostByTopicListState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: AppSlidingTabBar<int>(
        currentItem: state.currentTabIndex,
        items: [
          AppTabItem(value: 0, label: "Mới nhất"),
          AppTabItem(value: 1, label: "Bài viết nổi bật nhất"),
        ],
        onTabChanged: (index) => interactor.onTabChanged(index),
        style: TMLabsTabBarStyle.defaultStyle,
      ),
    );
  }

  Widget _buildPostGrid(PostByTopicListState state) {
    if (state.posts.isEmpty && !state.isLoading) {
      return getEmptyItemView(caption: "Không có bài viết nào");
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        return TopicPostItem(
          data: state.posts[index],
          onTap: () => interactor.router?.navigate(PostDetailRoute(state.posts[index].id)),
        );
      },
    );
  }
}
