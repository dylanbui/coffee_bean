import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_event_state.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_interactor.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/widgets/expert_course_item.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/widgets/expert_post_item.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/parallax_sliver_app_bar.dart';
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
  late ScrollController _scrollController;
  final GlobalKey _profileCardKey = GlobalKey();
  
  double _appBarTitleOpacity = 0.0;
  double _profileCardOpacity = 1.0;
  
  static const double _expandedHeight = 200.0;
  static const double _fadeOffset = 40.0; // Khoảng cách bắt đầu mờ dần

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final double offset = _scrollController.offset;
    final double safeAreaTop = MediaQuery.of(context).padding.top;
    final double toolbarHeight = kToolbarHeight + safeAreaTop;
    
    // Lấy chiều cao thực tế của ProfileCard
    final RenderBox? renderBox = _profileCardKey.currentContext?.findRenderObject() as RenderBox?;
    final double profileCardHeight = renderBox?.size.height ?? 150.0;
    
    // Quãng đường từ lúc bắt đầu cuộn đến khi TabBar chạm AppBar
    // Quãng đường = (Chiều cao Banner mở rộng - Chiều cao AppBar thu gọn) + Chiều cao Profile Card
    final double totalDistance = (_expandedHeight - toolbarHeight) + profileCardHeight;

    // 1. Profile Card mờ dần xuyên suốt quãng đường cho đến khi chui dưới AppBar
    final double newProfileOpacity = (1.0 - (offset / totalDistance)).clamp(0.0, 1.0);
    
    // 2. AppBar Title hiện dần khi Profile Card mờ đi (Bắt đầu hiện từ giữa quãng đường và rõ hẳn ở cuối)
    double newTitleOpacity = 0.0;
    const double titleStartThreshold = 0.6; // Bắt đầu hiện từ 60% quãng đường
    if (offset / totalDistance > titleStartThreshold) {
      newTitleOpacity = ((offset / totalDistance) - titleStartThreshold) / (1.0 - titleStartThreshold);
    }

    setState(() {
      _profileCardOpacity = newProfileOpacity;
      _appBarTitleOpacity = newTitleOpacity.clamp(0.0, 1.0);
    });
  }
  AppButtonStyleConfig _followButtonStyle(ExpertProfileState state) =>
      (state.isFollowed ? TMLabsButtonStyle.outline : TMLabsButtonStyle.primary).copyWith(
        textStyle: TMLabsTextStyle.caption.copyWith(
          color: state.isFollowed ? TMLabsColor.primary : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600
        ),
      );

  AppButtonStyleConfig _smallActionButtonStyle() => TMLabsButtonStyle.outline.copyWith(
    textStyle: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.w600),
  );

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ExpertProfileInteractor, ExpertProfileState>(
      builder: (context, state) {
        if (state.isLoading && state.expertInfo == null) {
          return getLoadingView();
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(context, state),
            SliverToBoxAdapter(
              child: Opacity(
                opacity: _profileCardOpacity,
                child: Container(
                  key: _profileCardKey,
                  child: _buildProfileCard(context, state),
                ),
              ),
            ),
            _buildStickyTabBar(context, state),
            _buildContentList(context, state),
          ],
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ExpertProfileState state) {
    return ParallaxSliverAppBar(
      expandedHeight: _expandedHeight,
      imageUrl: (state.expertInfo?.background != null && state.expertInfo!.background!.isNotEmpty)
          ? state.expertInfo!.background!
          : 'https://picsum.photos/800/400',
      onBackTap: interactor.router?.pop,
      style: ParallaxSliverAppBarStyleConfig(
        backgroundColor: TMLabsColor.primary,
        backIcon: Icons.arrow_back_ios_new,
        leadingWidth: 40,
      ),
      mode: ParallaxAppBarMode.solidOnScroll,
      solidBackgroundColor: Colors.transparent,
      actions: [
        if (state.isCurrentUser)
          IconButton(
            onPressed: interactor.router?.pushUpdateProfile,
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
          ),
      ],
      titleWidget: Opacity(
        opacity: _appBarTitleOpacity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarWidget(imageUrl: state.expertInfo?.userAvatar, size: 30),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                state.expertInfo?.userNickname ?? "",
                style: TMLabsTextStyle.bodyBold.copyWith(
                  color: Colors.white, 
                  fontSize: 14,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                    // Hàng 1: Nickname & Badge
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          info?.userNickname ?? "",
                          style: TMLabsTextStyle.h2.copyWith(height: 1.1),
                        ),
                        if (isExpert)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1E3A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Chuyên gia",
                              style: TMLabsTextStyle.caption.copyWith(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Hàng 2: Stats
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatItem("${stat?.statPostCount ?? 0}", "Bài viết"),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          "${stat?.statFansCount ?? 0}",
                          "Follower",
                          onTap: isCurrentUser ? () => interactor.router?.pushFanFollowList(initialTabIndex: 0) : null,
                        ),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          "${stat?.statFollowCount ?? 0}",
                          "Đã Follow",
                          onTap: isCurrentUser ? () => interactor.router?.pushFanFollowList(initialTabIndex: 1) : null,
                        ),
                      ],
                    ),
                    if (!isCurrentUser) ...[
                      const SizedBox(height: 6),
                      AppButton(
                        text: state.isFollowed ? "Đang theo dõi" : "Theo dõi",
                        onPressed: interactor.toggleFollow,
                        style: _followButtonStyle(state),
                        width: 120,
                        height: 32,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (info?.expertIntro != null && info!.expertIntro!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                info.expertIntro!,
                style: TMLabsTextStyle.body.copyWith(
                  color: TMLabsColor.grey,
                ),
              ),
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
          Text(count, style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 18)),
          Text(label, style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey, fontSize: 12)),
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
          height: 60,
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
                    onPressed: interactor.router?.pushCreateCourseApplication,
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
            (context, index) =>
                ExpertPostItem(data: state.posts[index], onTap: () => iLog("Tap post ${state.posts[index].id}")),
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
                  AppButton(text: "Đăng ký ngay", onPressed: interactor.router?.pushExpertApply, width: 160),
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
          (context, index) =>
              ExpertCourseItem(data: state.courses[index], onTap: () => iLog("Tap course ${state.courses[index].id}")),
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
