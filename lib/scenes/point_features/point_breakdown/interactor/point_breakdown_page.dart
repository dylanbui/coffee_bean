import 'package:coffee_bean/data/model/response/promotion/point_breakdown.dart';
import 'package:coffee_bean/scenes/point_features/point_breakdown/interactor/point_breakdown_event_state.dart';
import 'package:coffee_bean/scenes/point_features/point_breakdown/interactor/point_breakdown_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_ui.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/utils/refresh_loadmore.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class PointBreakdownPage extends AppCubitStateFulWidget<PointBreakdownInteractor, PointBreakdownState> {
  PointBreakdownPage({super.key, required super.interactor});

  @override
  State<PointBreakdownPage> createState() => _PointBreakdownPageState();
}

class _PointBreakdownPageState
    extends AppCubitState<PointBreakdownPage, PointBreakdownInteractor, PointBreakdownState> {

  @override
  String? getTitle() => "CHI TIẾT ĐIỂM THƯỞNG";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<PointBreakdownInteractor, PointBreakdownState>(
      builder: (context, state) {
        // 1. Màn hình loading ban đầu (Trạng thái khởi tạo chưa có data)
        if (state is PointBreakdownStartLoading) {
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

  Widget _buildPointItem(PointBreakdownItem item) {
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
                if (item.description != null && item.description!.isNotEmpty)
                  Text(
                    item.description!,
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
                "${item.point > 0 ? '+' : ''}${item.point}",
                style: TMLabsTextStyle.title.copyWith(
                  color: item.point > 0 ? TMLabsColor.success : TMLabsColor.error,
                  fontSize: 18,
                ),
                maxLines: 1,
              ),
              Text(
                UtcUtils.formatTimestamp(item.createTime, format: AppDateTimeFormat.full),
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
