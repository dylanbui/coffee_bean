import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/community_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/community/interactor/widgets/community_post_item.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/topic_selection_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:coffee_bean/utils/flash_utils/flash_modal_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_sliding_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityPage extends AppCubitStateFulWidget<CommunityInteractor, CommunityState> {
  CommunityPage({super.key, required super.interactor});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends AppCubitState<CommunityPage, CommunityInteractor, CommunityState> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && AppPrefs().getTopicInterested().isEmpty) {
        _showTopicSelectionModal();
      }
    });
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CommunityInteractor, CommunityState>(
      builder: (context, state) {
        final double statusBarHeight = MediaQuery.of(context).padding.top;
        const double sliderHeight = 210.0;

        return Scaffold(
          backgroundColor: TMLabsColor.bgMain,
          floatingActionButton: UserManager().isLogin ? _buildCreatePostButton() : null,
          body: CustomScrollView(
            slivers: [
              // 1. Header: Slider + Hot Topics (Cuộn đi bình thường)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // TODO: update lai thong tin khi co api moi
                        ImageSliderWidget(
                          images: state.posts.take(2).map((e) => e.postImgs?.firstOrNull ?? '').toList(),
                          height: sliderHeight,
                          indicatorType: ImageSliderIndicatorType.dots,
                          onImageTap: (index, _) {
                            if (index < state.posts.length) {
                              final post = state.posts[index];
                              interactor.router?.pushPostDetail(post.id);
                            }
                          },
                        ),
                        Positioned(top: statusBarHeight + 10, left: 16, child: _buildSearchButton()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildHotTopics(state),
                    const SizedBox(height: 12), // KHOẢNG TRỐNG 12PX CHUẨN SÁT TABBAR
                  ],
                ),
              ),

              // 2. TabBar: Pinned (Sẽ dính lên top ngay dưới Status Bar khi cuộn tới)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SimpleTabBarDelegate(
                  height: 64 + statusBarHeight,
                  child: Container(
                    color: TMLabsColor.bgMain,
                    padding: EdgeInsets.only(top: statusBarHeight),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSlidingTabBar<int>(
                            currentItem: state.currentTabIndex,
                            items: [
                              AppTabItem(value: 0, label: "Gợi ý"),
                              AppTabItem(value: 1, label: "Đề xuất"),
                              AppTabItem(value: 2, label: "Thịnh hành"),
                            ],
                            onTabChanged: (index) => interactor.onTabChanged(index),
                            style: TMLabsTabBarStyle.defaultStyle,
                          ),
                          const SizedBox(height: 4),
                          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Posts Grid
              if (state.isLoading && state.posts.isEmpty)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (state.posts.isEmpty)
                SliverFillRemaining(child: getEmptyItemView(caption: "Không có bài viết nào"))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = state.posts[index];
                      return CommunityPostItem(
                        key: ValueKey("post_${state.currentTabIndex}_${post.id}"),
                        data: post,
                        onTap: () => interactor.router?.pushPostDetail(post.id),
                      );
                    }, childCount: state.posts.length),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchButton() {
    return AppButton(
      text: AppStrings.searchHint,
      onPressed: () => interactor.openSearch(),
      mainAxisSize: MainAxisSize.min,
      leftIcon: AppIcon(AppAssets.icons.icSearch, color: TMLabsColor.grey, size: 20),
      style: AppButtonStyleConfig(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        textColor: TMLabsColor.grey,
        borderRadius: 25,
        height: 36,
        textStyle: const TextStyle(color: TMLabsColor.grey, fontSize: 13, fontWeight: FontWeight.w400),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _buildCreatePostButton() {
    return TapEffect(
      onTap: () => interactor.router?.pushCreatePost(),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: TMLabsColor.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: TMLabsColor.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Center(
          child: AppIcon(AppAssets.icons.icPencil, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Widget _buildHotTopics(CommunityState state) {
    final topics = state.hotTopics.take(10).toList();
    if (topics.isEmpty) return const SizedBox.shrink();

    final col1 = topics.take(5).toList();
    final col2 = topics.length > 5 ? topics.sublist(5) : <HotTopic>[];

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Expanded(child: _buildTopicColumn(col1)),
          const SizedBox(width: 12),
          Expanded(child: _buildTopicColumn(col2)),
        ],
      ),
    );
  }

  Widget _buildTopicColumn(List<HotTopic> topics) {
    return Column(
      children: List.generate(5, (index) {
        if (index < topics.length) {
          final topic = topics[index];
          return Expanded(
            child: TapEffect(
              onTap: () => interactor.openTopicDetail(topic),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: TMLabsColor.bgLight, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  topic.topicName ?? '',
                  style: TMLabsTextStyle.caption.copyWith(
                    color: TMLabsColor.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }
        return const Spacer();
      }),
    );
  }

  void _showTopicSelectionModal() {
    final pluginController = TopicSelectionPluginController();

    FlashModalHelper.showSmartModal(
      context: context,
      title: "Chủ đề bạn quan tâm",
      childBuilder: (context, flashController) {
        pluginController.listener = _TopicSelectionModalListener(flashController);
        return TopicSelectionBuilder().buildPlugin(pluginController);
      },
    );
  }
}

class _TopicSelectionModalListener implements TopicSelectionListener {
  final FlashController flashController;
  _TopicSelectionModalListener(this.flashController);

  @override
  void onTopicSelectionFinish(List<HotTopic>? selected) {
    // Logic xử lý kết quả (nếu cần) có thể thực hiện tại đây hoặc báo cho Interactor
    // Login xử lý đã duoc thuc hien ben trong plugin roi
    flashController.dismiss();
  }
}

class _SimpleTabBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _SimpleTabBarDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SimpleTabBarDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
