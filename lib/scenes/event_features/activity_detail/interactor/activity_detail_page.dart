import 'package:coffee_bean/data/model/response/hub/activity_info_detail.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_event_state.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_interactor.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/widget/activity_countdown_widget.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:coffee_bean/shared/ui_control/share_action/share_poster_dialog.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class ActivityDetailPage extends AppCubitStateFulWidget<ActivityDetailInteractor, ActivityDetailState> {
  ActivityDetailPage({super.key, required super.interactor});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends AppCubitState<ActivityDetailPage, ActivityDetailInteractor, ActivityDetailState> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final collapsed = _scrollController.offset > (316 - kToolbarHeight - MediaQuery.of(context).padding.top);
    if (collapsed != _isCollapsed) {
      setState(() => _isCollapsed = collapsed);
    }
  }

  void _showShareDialog(ActivityInfoDetail activity) {
    SharePosterDialog.show(
      context: context,
      imageUrl: activity.activityCover ?? "",
      title: activity.activityName,
      shareLink: "https://tmlabs.coffee/event/${interactor.activityId}",
      shareText: "Tham gia cùng tôi tại sự kiện: ${activity.activityName}",
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ActivityDetailInteractor, ActivityDetailState>(
      builder: (context, state) {
        if (state.isLoading || state.activityDetail == null) return getLoadingView();
        
        final activity = state.activityDetail!;
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(activity),
              SliverToBoxAdapter(child: _buildActivityInfo(activity)),
              SliverToBoxAdapter(child: _buildCapacityBox(activity)),
              SliverToBoxAdapter(child: _buildLocationBox(activity)),
              
              if ((activity.activityDetail ?? "").isNotEmpty) 
                SliverToBoxAdapter(child: _buildAboutActivity(activity)),

              const SliverToBoxAdapter(child: SizedBox(height: 550)),
            ],
          ),
          bottomNavigationBar: _buildFooter(activity),
        );
      },
    );
  }

  Widget _buildSliverAppBar(ActivityInfoDetail activity) {
    return CoffeeSliverAppBar(
      expandedHeight: 316,
      pinned: true,
      style: TmLabAppBarStyle.whiteStyle.copyWith(
        backgroundColor: TMLabsColor.bgSecond,
        centerTitle: true,
        foregroundColor: _isCollapsed ? TMLabsColor.primary : Colors.white,
      ),
      onBackTap: () {
        interactor.router?.pop();
      },
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TapEffect(
            onTap: () => _showShareDialog(activity),
            child: Icon(
              Icons.share_outlined,
              color: _isCollapsed ? TMLabsColor.primary : Colors.white,
            ),
          ),
        ),
      ],
      titleWidget: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          final isCollapsed = top <= kToolbarHeight + (MediaQuery.of(context).padding.top);
          return isCollapsed
              ? Text("CHI TIẾT SỰ KIỆN", style: TmLabAppBarStyle.whiteStyle.titleTextStyle)
              : const SizedBox.shrink();
        },
      ),
      background: DbCachedImageWidget(
        imageUrl: activity.activityCover ?? "",
        width: double.infinity,
        height: 316,
        fit: BoxFit.cover,
        borderRadius: 0,
      ),
    );
  }

  Widget _buildActivityInfo(ActivityInfoDetail activity) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(activity.activityName, style: TMLabsTextStyle.h1)),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatusAndCountdown(activity),
          if (activity.activityDesc != null) ...[
            const SizedBox(height: 12),
            Text(
              activity.activityDesc!,
              style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusAndCountdown(ActivityInfoDetail activity) {
    final now = DateTime.now();
    final deadline = UtcUtils.toDateTimeSafe(activity.activityRegEnd);
    final isExpired = deadline != null && now.isAfter(deadline);
    final isFull = (activity.maxPeople ?? 0) > 0 && (activity.currPeople ?? 0) >= (activity.maxPeople ?? 0);

    String statusText = "ĐANG ĐĂNG KÝ";
    Color statusColor = TMLabsColor.primary;

    if (isExpired) {
      statusText = "HẾT HẠN";
      statusColor = TMLabsColor.grey;
    } else if (isFull) {
      statusText = "ĐÃ ĐỦ NGƯỜI";
      statusColor = TMLabsColor.grey;
    } else if (activity.activityStatus != 1) {
      // Mapping other statuses if needed, default to Ended/Closed
      statusText = "KẾT THÚC";
      statusColor = TMLabsColor.grey;
    }

    return Row(
      children: [
        AppLabel(
          statusText,
          backgroundColor: statusColor,
          borderRadius: 4,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        if (deadline != null && !isExpired && !isFull && activity.activityStatus == 1)
          Flexible(
            child: ActivityCountdownWidget(
              deadline: deadline,
              onExpired: () => setState(() {}),
              style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey, fontSize: 12),
            ),
          )
        else if (deadline != null)
          Flexible(
            child: Text(
              "Hạn đăng ký: ${UtcUtils.toDateTimeStr(activity.activityRegEnd, format: AppDateTimeFormat.fullDatetime)}",
              style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildCapacityBox(ActivityInfoDetail activity) {
    final total = activity.maxPeople ?? 0;
    final booked = activity.currPeople ?? 0;
    if (total <= 0) return const SizedBox.shrink();

    final remaining = total - booked;
    final progress = (booked / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: TMLabsColor.bgLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Số chỗ còn lại: ${remaining > 0 ? remaining : 0}", style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 13)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: TMLabsColor.lightGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(TMLabsColor.primary),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "$booked người đã đăng ký",
              style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBox(ActivityInfoDetail activity) {
    final startTime = UtcUtils.toDateTimeStr(activity.activityStart, format: AppDateTimeFormat.full);
    final endTime = UtcUtils.toDateTimeStr(activity.activityEnd, format: AppDateTimeFormat.full);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: TMLabsColor.bgLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activity.activityLocation != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                          child: Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.location_on, size: 16, color: TMLabsColor.grey),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            activity.activityLocation ?? "",
                            style: TMLabsTextStyle.body.copyWith(fontSize: 12, height: 1.2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (startTime.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          child: Icon(Icons.access_time, size: 14, color: TMLabsColor.grey),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$startTime ${endTime.isNotEmpty ? "- $endTime" : ""}",
                          style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            AppButton(
              text: "Dẫn đường",
              leftIcon: const Icon(Icons.near_me, size: 14, color: Colors.white),
              style: TMLabsButtonStyle.primary.copyWith(
                borderRadius: 12,
                textStyle: TMLabsTextStyle.small.copyWith(color: Colors.white),
              ),
              width: 100,
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              onPressed: interactor.onDirectionTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutActivity(ActivityInfoDetail activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Về sự kiện này", style: TMLabsTextStyle.h2),
          Html(
            data: activity.activityDetail ?? "",
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14),
                color: TMLabsColor.grey,
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ActivityInfoDetail activity) {
    final priceStr = activity.activityPrice == 0 ? "Miễn phí" : activity.activityPrice.toFormatPrice();
    
    final now = DateTime.now();
    final deadline = UtcUtils.toDateTimeSafe(activity.activityRegEnd);
    final isExpired = deadline != null && now.isAfter(deadline);
    final isFull = (activity.maxPeople ?? 0) > 0 && (activity.currPeople ?? 0) >= (activity.maxPeople ?? 0);
    final canRegister = !isExpired && !isFull && activity.activityStatus == 1;

    String btnText = "ĐĂNG KÝ NGAY";
    if (isExpired) {
      btnText = "HẾT HẠN";
    } else if (isFull) {
      btnText = "ĐÃ ĐỦ NGƯỜI";
    }

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: TMLabsColor.bgLight)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  priceStr,
                  style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.w900),
                ),
                Text(
                  activity.activityPrice == 0 ? "Tham gia tự do" : "Phí đăng ký",
                  style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppButton(
            text: btnText,
            style: canRegister ? TMLabsButtonStyle.primary : TMLabsButtonStyle.primary.copyWith(backgroundColor: TMLabsColor.grey),
            width: 164,
            height: 30,
            onPressed: canRegister ? interactor.onPaymentTap : null,
          ),
        ],
      ),
    );
  }
}
