import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/invitation_ranking_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/invitation_ranking_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_sliding_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class InvitationRankingPage extends AppCubitStateFulWidget<InvitationRankingInteractor, InvitationRankingState> {
  InvitationRankingPage({super.key, required super.interactor});

  @override
  State<InvitationRankingPage> createState() => _InvitationRankingPageState();
}

class _InvitationRankingPageState extends AppCubitState<InvitationRankingPage, InvitationRankingInteractor, InvitationRankingState> {
  
  @override
  String? getTitle() => "invitation_ranking.title".tr();

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) => null;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<InvitationRankingInteractor, InvitationRankingState>(
      builder: (context, state) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                pinned: true,
                delegate: RankingHeaderDelegate(
                  statusBarHeight: MediaQuery.paddingOf(context).top,
                  tabBar: _buildTabBar(state),
                  imageUrl: state.userInfo?.background ?? 'https://picsum.photos/id/162/800/600',
                ),
              ),
            ];
          },
          body: state.isLoading ? getLoadingView() : _buildRankingList(state),
        );
      },
    );
  }

  Widget _buildTabBar(InvitationRankingState state) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: AppSlidingTabBar<String>(
        items: [
          AppTabItem(value: 'DAILY', label: "invitation_ranking.day".tr()),
          AppTabItem(value: 'WEEKLY', label: "invitation_ranking.week".tr()),
          AppTabItem(value: 'MONTHLY', label: "invitation_ranking.month".tr()),
        ],
        currentItem: state.timeRange,
        onTabChanged: (value) => interactor.changeTimeRange(value),
        mode: TabIndicatorMode.background,
        isFullWidth: true,
        style: TMLabsTabBarStyle.backgroundStyle.copyWith(
          spacing: 0,
        ),
      ),
    );
  }

  Widget _buildRankingList(InvitationRankingState state) {
    final list = state.currentRanking;
    if (list.isEmpty) {
      return getEmptyItemView(caption: "invitation_ranking.no_data".tr());
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return _buildRankingItem(item);
      },
    );
  }

  Widget _buildRankingItem(InviteRanking item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          AvatarWidget(
            size: 48,
            imageUrl: item.avatar,
            backgroundColor: TMLabsColor.bgLight,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nickname ?? "invitation_ranking.anonymous".tr(),
                  style: TMLabsTextStyle.bodyBold,
                ),
                if (item.mobile != null)
                  Text(
                    item.mobile!,
                    style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppLabel(
                "TOP ${item.rank}",
                backgroundColor: TMLabsColor.error,
                borderRadius: 4,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              ),
              const SizedBox(height: 4),
              Text(
                "${item.totalInvites} ${"invitation_ranking.invites_count".tr()}",
                style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RankingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;
  final Widget tabBar;
  final String imageUrl;

  RankingHeaderDelegate({
    required this.statusBarHeight,
    required this.tabBar,
    required this.imageUrl,
  });

  final double imageHeight = 200.0;
  final double tabBarHeight = 64.0;
  final double spacing = 12.0;

  @override
  double get maxExtent => statusBarHeight + imageHeight + spacing + tabBarHeight;

  @override
  double get minExtent => statusBarHeight + kToolbarHeight + tabBarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double totalShrinkRange = maxExtent - minExtent;
    final double shrinkPercentage = (shrinkOffset / totalShrinkRange).clamp(0.0, 1.0);

    // TODO: chờ update ui Sử dụng màu navy thương hiệu cho AppBar overlay, độ trong suốt tăng dần khi cuộn
    //final Color appBarBgColor = TMLabsColor.primary.withValues(alpha: shrinkPercentage * 0.85);
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // LAYER 1: Background Image with Parallax
        Positioned(
          top: -shrinkOffset * 0.3, // Hiệu ứng parallax nhẹ
          left: 0,
          right: 0,
          height: imageHeight + statusBarHeight + spacing,
          child: DbCachedImageWidget(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),

        // LAYER 2: AppBar Background Overlay (Semi-transparent)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: statusBarHeight + kToolbarHeight,
          child: Container(
            color: Colors.transparent,
          ),
        ),

        // LAYER 3: Title (Fade in)
        Positioned(
          top: statusBarHeight,
          left: 56,
          right: 56,
          height: kToolbarHeight,
          child: Center(
            child: Opacity(
              opacity: shrinkPercentage,
              child: Text(
                "invitation_ranking.title".tr(),
                style: TMLabsTextStyle.title.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),

        // LAYER 4: TabBar pinned at the bottom using CLAMP logic
        Positioned(
          top: (maxExtent - tabBarHeight - shrinkOffset).clamp(statusBarHeight + kToolbarHeight, maxExtent),
          left: 0,
          right: 0,
          height: tabBarHeight,
          child: Material(
            elevation: shrinkPercentage > 0.98 ? 2 : 0,
            color: Colors.transparent, // Background handled by _buildTabBar decoration
            child: tabBar,
          ),
        ),

        // LAYER 5: Back Button
        Positioned(
          top: statusBarHeight,
          left: 8,
          width: 48,
          height: kToolbarHeight,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant RankingHeaderDelegate oldDelegate) => true;
}
