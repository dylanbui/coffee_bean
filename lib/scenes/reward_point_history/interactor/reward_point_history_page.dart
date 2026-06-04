import 'package:coffee_bean/data/model/response/reward_point_history.dart';
import 'package:coffee_bean/scenes/reward_point_history/interactor/reward_point_history_event_state.dart';
import 'package:coffee_bean/scenes/reward_point_history/interactor/reward_point_history_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_ui.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/utils/refresh_loadmore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class RewardPointHistoryPage extends AppCubitStateFulWidget<RewardPointHistoryInteractor, RewardPointHistoryState> {
  RewardPointHistoryPage({super.key, required super.interactor});

  @override
  State<RewardPointHistoryPage> createState() => _RewardPointHistoryPageState();
}

class _RewardPointHistoryPageState
    extends AppCubitState<RewardPointHistoryPage, RewardPointHistoryInteractor, RewardPointHistoryState> {

  @override
  String? getTitle() => "CHI TIẾT ĐIỂM THƯỞNG";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<RewardPointHistoryInteractor, RewardPointHistoryState>(
      builder: (context, state) {
        // 1. Màn hình loading ban đầu (Trạng thái khởi tạo chưa có data)
        if (state is RewardPointHistoryStartLoading) {
          return getLoadingView();
        }

        return Container(
          color: TMLabsColor.white,
          child: RefreshLoadmore(
            onRefresh: () => interactor.loadData(isRefresh: true),
            onLoadmore: () => interactor.loadData(isRefresh: false),
            isLastPage: !state.hasMore,
            isEmpty: state.items.isEmpty,
            emptyWidget: const Center(child: Text("Không có dữ liệu")),
            style: AppUi.getDefaultRefreshLoadmoreStyle(context),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = state.items[index];
                    return Column(
                      children: [
                        // Divider trên cùng của item đầu tiên
                        const Divider(height: 1, color: TMLabsColor.lightGrey, thickness: 1),
                        _buildPointItem(item),
                        // Divider dưới mỗi item
                        const Divider(height: 1, color: TMLabsColor.lightGrey, thickness: 1),
                        SizedBox(height: 5,),
                      ],
                    );
                  },
                  childCount: state.items.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPointItem(RewardPointHistoryItem item) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TMLabsTextStyle.bodyBold.copyWith(color: TMLabsColor.primary, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.body != null && item.body!.isNotEmpty)
                  Text(
                    item.body!,
                    style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.points > 0 ? '+' : ''}${item.points.toInt()}",
                style: TMLabsTextStyle.title.copyWith(
                  color: item.points > 0 ? TMLabsColor.success : TMLabsColor.error,
                  fontSize: 18,
                ),
                maxLines: 1,
              ),
              Text(
                item.dateTime,
                style: TMLabsTextStyle.small.copyWith(
                  color: TMLabsColor.grey,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
