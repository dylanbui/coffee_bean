import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_event_state.dart';
import 'package:coffee_bean/scenes/event_features/activity_detail/interactor/activity_detail_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityDetailPage extends AppCubitStateFulWidget<ActivityDetailInteractor, ActivityDetailState> {
  ActivityDetailPage({super.key, required super.interactor});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends AppCubitState<ActivityDetailPage, ActivityDetailInteractor, ActivityDetailState> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentImageIndex = 0;
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

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ActivityDetailInteractor, ActivityDetailState>(
      builder: (context, state) {
        if (state.isLoading) return getLoadingView();
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(state),
              SliverToBoxAdapter(child: _buildActivityInfo(state)),
              SliverToBoxAdapter(child: _buildCapacityBox(state)),
              SliverToBoxAdapter(child: _buildLocationBox(state)),
              
              // --- MOCK DATA CONTENT (SERVER HTML) ---
              SliverToBoxAdapter(child: _buildServerDetailPlaceholder()),
              // ---------------------------------------

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          bottomNavigationBar: _buildFooter(state),
        );
      },
    );
  }

  Widget _buildSliverAppBar(ActivityDetailState state) {
    return CoffeeSliverAppBar(
      expandedHeight: 316,
      pinned: true,
      style: TmLabAppBarStyle.whiteStyle.copyWith(
        backgroundColor: TMLabsColor.bgSecond,
        centerTitle: true,
        foregroundColor: _isCollapsed ? TMLabsColor.primary : Colors.white,
      ),
      onBackTap: interactor.onNavigateBack,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TapEffect(
            onTap: interactor.onShareTap,
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
      background: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemCount: state.images.length,
            itemBuilder: (context, index) => DbCachedImageWidget(
              imageUrl: state.images[index],
              width: double.infinity,
              height: 316,
              fit: BoxFit.cover,
              borderRadius: 0,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                state.images.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityInfo(ActivityDetailState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(state.title, style: TMLabsTextStyle.h1),
          const SizedBox(height: 8),
          Text(
            state.description,
            style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityBox(ActivityDetailState state) {
    final remaining = state.totalSlots - state.bookedSlots;
    final progress = state.bookedSlots / state.totalSlots;

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
                  Text("Số chỗ còn lại: $remaining", style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 13)),
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
            _buildOverlappingAvatars(state),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlappingAvatars(ActivityDetailState state) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 30,
          child: Stack(
            children: List.generate(state.registeredAvatars.length, (index) {
              return Positioned(
                left: index * 12.0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                    image: DecorationImage(
                      image: NetworkImage(state.registeredAvatars[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Text(
          "${state.bookedSlots} người đã đăng ký",
          style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildLocationBox(ActivityDetailState state) {
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
                          state.address,
                          style: TMLabsTextStyle.body.copyWith(fontSize: 12, height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        child: Icon(Icons.access_time, size: 14, color: TMLabsColor.grey),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${state.startTime} - ${state.endTime}",
                        style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                      ),
                    ],
                  ),
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
              padding: const EdgeInsets.symmetric(horizontal: 4), // Giảm padding để hiện chữ
              onPressed: interactor.onDirectionTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerDetailPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          color: TMLabsColor.bgLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TMLabsColor.lightGrey.withValues(alpha: 0.5)),
        ),
        alignment: Alignment.center,
        child: Text(
          "Chi tiết nội dung văn bản định dạng được\nquản trị ở hệ thống backend.",
          textAlign: TextAlign.center,
          style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.lightGrey),
        ),
      ),
    );
  }

  Widget _buildFooter(ActivityDetailState state) {
    final priceStr = NumberToVietnamese.formatNumber(state.price);

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$priceStr",
                style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.w900),
              ),
              Text(
                "Phí đăng ký",
                style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
              ),
            ],
          ),
          AppButton(
            text: "THANH TOÁN",
            style: TMLabsButtonStyle.primary,
            width: 164,
            height: 30,
            onPressed: interactor.onPaymentTap,
          ),
        ],
      ),
    );
  }
}
