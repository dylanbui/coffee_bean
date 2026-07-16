import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_event_state.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_interactor.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/widgets/expert_course_item.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/widgets/expert_post_item.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_sliding_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpertProfilePage extends AppCubitStateFulWidget<ExpertProfileInteractor, ExpertProfileState> {
  ExpertProfilePage({super.key, required super.interactor});

  @override
  State<ExpertProfilePage> createState() => _ExpertProfilePageState();
}

class _ExpertProfilePageState extends AppCubitState<ExpertProfilePage, ExpertProfileInteractor, ExpertProfileState> {

  AppButtonStyleConfig _followButtonStyle(ExpertProfileState state) => (state.isFollowed ? TMLabsButtonStyle.outline : TMLabsButtonStyle.primary).copyWith(
        textStyle: TMLabsTextStyle.caption.copyWith(
          color: state.isFollowed ? TMLabsColor.primary : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      );

  AppButtonStyleConfig _smallActionButtonStyle() => TMLabsButtonStyle.outline.copyWith(
        textStyle: TMLabsTextStyle.caption.copyWith(
          color: TMLabsColor.primary,
          fontWeight: FontWeight.w600,
        ),
      );

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ExpertProfileInteractor, ExpertProfileState>(
      builder: (context, state) {
        if (state.isLoading && state.expertInfo == null) {
          return getLoadingView();
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, state),
              SliverToBoxAdapter(
                child: _buildProfileCard(context, state),
              ),
              _buildStickyTabBar(context, state),
              _buildContentList(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ExpertProfileState state) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: const BackButton(color: Colors.white),
      backgroundColor: TMLabsColor.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: const DbCachedImageWidget(
          imageUrl: 'https://picsum.photos/800/400',
          fit: BoxFit.cover,
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;
            if (!isCollapsed) return const SizedBox.shrink();

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AvatarWidget(imageUrl: state.expertInfo?.userAvatar, size: 30),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.expertInfo?.userNickname ?? "",
                    style: TMLabsTextStyle.bodyBold.copyWith(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ExpertProfileState state) {
    final info = state.expertInfo;
    final stat = state.userStat;
    final isCurrentUser = state.isCurrentUser;
    final isExpert = info?.expertStatus == 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarWidget(imageUrl: info?.userAvatar, size: 80),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            info?.userNickname ?? "",
                            style: TMLabsTextStyle.h2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isExpert && info?.expertTitle != null) ...[
                          const SizedBox(width: 4),
                          AppLabel(
                            info!.expertTitle!,
                            backgroundColor: TMLabsColor.primary,
                          ),
                        ],
                        const SizedBox(width: 8),
                        if (isCurrentUser)
                          IconButton(
                            onPressed: interactor.onSettingsPressed,
                            icon: const Icon(Icons.settings_outlined),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          )
                        else
                          AppButton(
                            text: state.isFollowed ? "Đã theo dõi" : "Theo dõi",
                            onPressed: interactor.toggleFollow,
                            style: _followButtonStyle(state),
                            width: 90,
                            height: 30,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatItem(
                          "${stat?.followerCount ?? 0}",
                          "người theo dõi",
                          onTap: isCurrentUser ? () => interactor.onShowFanFollowList(0) : null,
                        ),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          "${stat?.followeeCount ?? 0}",
                          "đang theo dõi",
                          onTap: isCurrentUser ? () => interactor.onShowFanFollowList(1) : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isExpert) ...[
            const SizedBox(height: 16),
            Text(
              info?.expertIntro ?? "Chưa có giới thiệu bản thân.",
              style: TMLabsTextStyle.body,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: TMLabsTextStyle.bodyBold),
          Text(label, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
        ],
      ),
    );
  }

  Widget _buildStickyTabBar(BuildContext context, ExpertProfileState state) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: AppSlidingTabBar<int>(
                  items: [
                    AppTabItem(value: 0, label: "Bài viết"),
                    AppTabItem(value: 1, label: "Khóa học"),
                  ],
                  currentItem: state.currentTabIndex,
                  onTabChanged: interactor.onTabChanged,
                  style: AppSlidingTabBarStyle.defaultStyle.copyWith(
                    activeColor: TMLabsColor.primary,
                    indicatorHeight: 3,
                  ),
                ),
              ),
              if (state.currentTabIndex == 1 && state.expertInfo?.expertStatus == 1)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AppButton(
                    text: "Tạo khóa học",
                    onPressed: interactor.onPublishCourse,
                    style: _smallActionButtonStyle(),
                    height: 28,
                    width: 90,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentList(BuildContext context, ExpertProfileState state) {
    if (state.currentTabIndex == 0) {
      if (state.posts.isEmpty) {
        return const SliverFillRemaining(child: Center(child: Text("Chưa có bài viết nào")));
      }
      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => ExpertPostItem(
              data: state.posts[index],
              onTap: () => iLog("Tap post ${state.posts[index].id}"),
            ),
            childCount: state.posts.length,
          ),
        ),
      );
    } else {
      final isExpert = state.expertInfo?.expertStatus == 1;

      if (!isExpert) {
        return SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school_outlined, size: 80, color: TMLabsColor.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "Trở thành chuyên gia để bắt đầu tạo và chia sẻ các khóa học chuyên sâu của bạn.",
                    textAlign: TextAlign.center,
                    style: TMLabsTextStyle.body,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: "Đăng ký ngay",
                    onPressed: interactor.onApplyExpert,
                    width: 160,
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (state.courses.isEmpty) {
        return const SliverFillRemaining(child: Center(child: Text("Chưa có khóa học nào")));
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ExpertCourseItem(
            data: state.courses[index],
            onTap: () => iLog("Tap course ${state.courses[index].id}"),
          ),
          childCount: state.courses.length,
        ),
      );
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 60.0;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
