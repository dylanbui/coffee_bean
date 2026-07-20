import 'package:coffee_bean/data/model/response/promotion/point_breakdown.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/interactor/invitation_reward_detail_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/interactor/invitation_reward_detail_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitationRewardDetailPage extends AppCubitStateFulWidget<InvitationRewardDetailInteractor, InvitationRewardDetailState> {
  InvitationRewardDetailPage({super.key, required super.interactor});

  @override
  State<InvitationRewardDetailPage> createState() => _InvitationRewardDetailPageState();
}

class _InvitationRewardDetailPageState extends AppCubitState<InvitationRewardDetailPage, InvitationRewardDetailInteractor, InvitationRewardDetailState> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      interactor.loadMore();
    }
  }

  @override
  String? getTitle() => "Chi tiết phần thưởng";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<InvitationRewardDetailInteractor, InvitationRewardDetailState>(
      builder: (context, state) {
        if (state.isLoading && state.items.isEmpty) {
          return getLoadingView();
        }

        if (state.items.isEmpty && !state.isLoading) {
          return getEmptyItemView(caption: "Chưa có phần thưởng nào");
        }

        return RefreshIndicator(
          onRefresh: () => interactor.refresh(),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.items.length + (state.hasMore ? 1 : 1), // Always show footer
            separatorBuilder: (context, index) => const Divider(height: 1, color: TMLabsColor.lightGrey),
            itemBuilder: (context, index) {
              if (index < state.items.length) {
                return _buildRewardItem(state.items[index]);
              } else {
                return _buildFooter(state.hasMore);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildRewardItem(PointBreakdownItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TMLabsTextStyle.title,
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "+ ${item.point}",
                style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.error, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                item.displayTime,
                style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool hasMore) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: hasMore
          ? AppUi.getLoadingBottom(context, color: TMLabsColor.primary)
          : AppUi.getNoMore(context),
    );
  }
}
