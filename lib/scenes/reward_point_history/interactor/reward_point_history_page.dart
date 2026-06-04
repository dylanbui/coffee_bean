import 'package:coffee_bean/data/model/response/reward_point_history.dart';
import 'package:coffee_bean/scenes/app/app.dart';
import 'package:coffee_bean/scenes/reward_point_history/interactor/reward_point_history_event_state.dart';
import 'package:coffee_bean/scenes/reward_point_history/interactor/reward_point_history_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_ui.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/utils/refresh_loadmore.dart';
import 'package:db_core/db_core.dart';
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
        // 1. Màn hình loading ban đầu (Khi danh sách trống và đang ở trạng thái Initial/Loading)
        if (state is RewardPointHistoryStartLoading) {
          return getLoadingView();
        }
        if (state is RewardPointHistoryDone && state.items.isEmpty) {
          return const Center(child: Text("Không có dữ liệu"));
        }
        // Xu ly tat cac cac trang thai con lai
        dLog("Rebuild with items: ${state.items.length}, hasMore: ${state.hasMore}");
        return Container(
          color: TMLabsColor.white,
          child: RefreshLoadmore(
            onRefresh: () => interactor.loadData(isRefresh: true),
            onLoadmore: () => interactor.loadData(isRefresh: false),
            color: TMLabsColor.primary,
            isLastPage: !state.hasMore,
            refreshWidget: AppUi.getRefreshTopWidget(context),
            loadingWidget: AppUi.getLoadingBottomWidget(context, color: TMLabsColor.primary),
            // noMoreWidget: AppUi.getNoMoreWidget(),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Column(
                  children: [
                    // Divider trên cùng của item đầu tiên
                    if (index == 0) const Divider(height: 1, color: TMLabsColor.lightGrey, thickness: 1),
                    _buildPointItem(item),
                    // Divider dưới mỗi item
                    const Divider(height: 1, color: TMLabsColor.lightGrey, thickness: 1),
                  ],
                );
              },
            ),
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
