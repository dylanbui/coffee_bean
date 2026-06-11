import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_main_content.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:db_core/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VenueDetailPage extends AppCubitStateFulWidget<VenueDetailInteractor, VenueDetailState> {
  VenueDetailPage({super.key, required super.interactor});

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends AppCubitState<VenueDetailPage, VenueDetailInteractor, VenueDetailState> {
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
    return BlocBuilder<VenueDetailInteractor, VenueDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildSliverAppBar(state),
                    SliverToBoxAdapter(child: _buildVenueInfo(state)),
                    _buildSliverDateSelector(state),
                    SliverToBoxAdapter(
                      child: VenueDetailMainContent(
                        state: state,
                        interactor: interactor,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for footer
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildFooter(state),
        );
      },
    );
  }

  Widget _buildSliverAppBar(VenueDetailState state) {
    return CoffeeSliverAppBar(
      expandedHeight: 316,
      pinned: true,
      style: TmLabAppBarStyle.whiteStyle.copyWith(
        backgroundColor: TMLabsColor.bgSecond,
        //backIcon: Icons.arrow_back_ios,
        centerTitle: true,
        foregroundColor: _isCollapsed ? TMLabsColor.primary : Colors.white,
      ),
      onBackTap: interactor.onNavigateBack,
      titleWidget: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          final isCollapsed = top <= kToolbarHeight + (MediaQuery.of(context).padding.top);
          return isCollapsed
              ? Text("ĐẶT CHỖ", style: TmLabAppBarStyle.whiteStyle.titleTextStyle)
              : const SizedBox.shrink();
        },
      ),
      background: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemCount: 5,
            itemBuilder: (context, index) => DbCachedImageWidget(
              imageUrl: "https://picsum.photos/seed/${index + 10}/800/600",
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
                5,
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

  Widget _buildVenueInfo(VenueDetailState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TÊN ĐỊA ĐIỂM", style: TMLabsTextStyle.h1),
          const SizedBox(height: 8),
          Text(
            "Bản mô tả giới thiệu địa điểm (văn bản mẫu dùng để hiển thị tạm thời). Bản mô tả giới thiệu địa điểm (văn bản mẫu dùng để hiển thị tạm thời).",
            style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
          ),
          const SizedBox(height: 16),
          Container(
            height: 64,
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
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: TMLabsColor.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "84a Nguyễn Cửu Vân, phường Gia Định, tp.HCM",
                              style: TMLabsTextStyle.caption,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled, size: 14, color: TMLabsColor.grey),
                          const SizedBox(width: 4),
                          Text("6h00' - 23h00'", style: TMLabsTextStyle.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: "Dẫn đường",
                  style: TMLabsButtonStyle.primary.copyWith(
                    borderRadius: 13,
                    textStyle: TMLabsTextStyle.small.copyWith(color: Colors.white),
                  ),
                  leftIcon: AppIcon(AppAssets.icons.icDanDuong, size: 14),
                  width: 100,
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  mainAxisSize: MainAxisSize.min,
                  onPressed: interactor.onOpenMapTap,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildTabs(state),
        ],
      ),
    );
  }

  Widget _buildTabs(VenueDetailState state) {
    final tabs = ["Sân Pickle ball", "Sân bóng rổ"];
    return Row(
      children: tabs.map((tab) {
        final isSelected = state.selectedTab == tab;
        return Padding(
          padding: const EdgeInsets.only(right: 24),
          child: InkWell(
            onTap: () => interactor.onTabChanged(tab),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tab,
                    style: TMLabsTextStyle.title.copyWith(
                      color: isSelected ? TMLabsColor.primary : TMLabsColor.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 2,
                      width: double.infinity,
                      color: TMLabsColor.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSliverDateSelector(VenueDetailState state) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedHeaderDelegate(
        minHeight: 100,
        maxHeight: 100,
        childBuilder: (shrinkOffset, overlapsContent) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.weekDates.length,
              itemBuilder: (context, index) {
                final dateModel = state.weekDates[index];
                final isSelected = DateUtils.isSameDay(state.selectedDate, dateModel.date);
                final dayName = _getDayName(dateModel.date);
                final dayNum = DateFormat('d/M').format(dateModel.date);

                return TapEffect(
                  onTap: () => interactor.onDateSelected(dateModel.date),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? TMLabsColor.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: TMLabsColor.bgLight),
                    ),
                    child: Opacity(
                      opacity: dateModel.isAvailable ? 1.0 : 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: TMLabsTextStyle.caption.copyWith(
                              color: isSelected ? Colors.white : TMLabsColor.grey,
                            ),
                          ),
                          Text(
                            dayNum,
                            style: TMLabsTextStyle.bodyBold.copyWith(
                              color: isSelected ? Colors.white : TMLabsColor.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AppLabel(
                            dateModel.isAvailable ? "Đặt được" : "Không đặt được",
                            backgroundColor: isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : (dateModel.isAvailable ? const Color(0xFFE8F5E9) : TMLabsColor.bgLight),
                            style: TMLabsTextStyle.small.copyWith(
                              fontSize: 8,
                              color: isSelected
                                  ? Colors.white
                                  : (dateModel.isAvailable ? TMLabsColor.success : TMLabsColor.grey),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    // if (DateUtils.isSameDay(date, now)) return "Thứ hai"; // Demo fix as per screenshot
    final days = ["Thứ hai", "Thứ ba", "Thứ tư", "Thứ năm", "Thứ sáu", "Thứ bảy", "Chủ nhật"];
    return days[date.weekday - 1];
  }

  Widget _buildFooter(VenueDetailState state) {
    // final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    // final totalPrice = formatter.format(state.totalAmount);
    final totalPrice = NumberToVietnamese.formatNumber(state.totalAmount) ?? "0";
    final selectedInfo = state.selectedSlots.isEmpty ? "Chưa chọn sân" : "Đã chọn ${state.selectedSlots.length} khung giờ";

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: TMLabsColor.bgSecond,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(totalPrice, style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.w900)),
                Text(
                  selectedInfo,
                  style: TMLabsTextStyle.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppButton(
            text: "ĐẶT LỊCH NGAY",
            style: TMLabsButtonStyle.primary,
            width: 164,
            height: 48,
            onPressed: () {
              if (state.selectedSlots.isEmpty) {
                context.showFlashWarning("Vui lòng chọn ít nhất một khung giờ để đặt lịch.");
                return;
              }
              context.showFlashConfirm<bool>(
                title: "Xác nhận đặt lịch",
                content: "Bạn có chắc chắn muốn đặt ${state.selectedSlots.length} khung giờ đã chọn?",
                actions: [
                  DbFlashDialogAction(label: "Hủy", value: false, color: TMLabsColor.grey),
                  DbFlashDialogAction(label: "Xác nhận", value: true, color: TMLabsColor.primary),
                ],
              ).then((confirmed) {
                if (confirmed == true) {
                  interactor.onBookingConfirm();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget Function(double shrinkOffset, bool overlapsContent) childBuilder;

  FixedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.childBuilder,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return childBuilder(shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(FixedHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        childBuilder != oldDelegate.childBuilder;
  }
}
