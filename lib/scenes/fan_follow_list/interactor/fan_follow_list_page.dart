import 'package:coffee_bean/data/models/response/hub/follower_user.dart';
import 'package:coffee_bean/scenes/fan_follow_list/interactor/fan_follow_list_event_state.dart';
import 'package:coffee_bean/scenes/fan_follow_list/interactor/fan_follow_list_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FanFollowListPage extends AppCubitStateFulWidget<FanFollowListInteractor, FanFollowListState> {
  FanFollowListPage({super.key, required super.interactor});

  @override
  State<FanFollowListPage> createState() => _FanFollowListPageState();
}

class _FanFollowListPageState extends AppCubitState<FanFollowListPage, FanFollowListInteractor, FanFollowListState> {
  @override
  Widget getBody(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<FanFollowListInteractor, FanFollowListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: TMLabsColor.primary),
              title: TabBar(
                onTap: interactor.onTabChanged,
                isScrollable: true,
                indicatorColor: TMLabsColor.primary,
                labelColor: TMLabsColor.primary,
                unselectedLabelColor: TMLabsColor.grey,
                labelStyle: TMLabsTextStyle.bodyBold.copyWith(fontSize: 16),
                unselectedLabelStyle: TMLabsTextStyle.body.copyWith(fontSize: 16),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: "Người theo dõi"),
                  Tab(text: "Đang theo dõi"),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(height: 1, color: Colors.grey.shade200),
              ),
            ),
            body: TabBarView(
              children: [
                _buildUserList(state.followers, isFollowerTab: true),
                _buildUserList(state.following, isFollowerTab: false),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserList(List<FollowUser> users, {required bool isFollowerTab}) {
    if (interactor.state.isLoading && users.isEmpty) return getLoadingView();
    if (users.isEmpty) return getEmptyItemView(caption: "Chưa có dữ liệu");

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: users.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 82),
        child: Divider(height: 1, color: Colors.grey.shade100),
      ),
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserItem(user, isFollowerTab: isFollowerTab);
      },
    );
  }

  Widget _buildUserItem(FollowUser user, {required bool isFollowerTab}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          AvatarWidget(imageUrl: user.expertAvatar, size: 50),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.expertTitle ?? "Người dùng",
                  style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  user.expertDesc ?? "",
                  style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: isFollowerTab ? "Gỡ" : "Đang follow",
            onPressed: () => isFollowerTab ? interactor.onRemoveFollower(user) : interactor.onUnfollow(user),
            style: TMLabsButtonStyle.outline.copyWith(
              textStyle: TMLabsTextStyle.caption.copyWith(
                color: TMLabsColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            height: 30,
            width: isFollowerTab ? 70 : 100,
            mainAxisSize: MainAxisSize.min,
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) => null;
}
