import 'dart:ui';
import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:db_core/utils/app_sliding_tab_bar.dart';
import 'package:db_core/utils/common_style.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';

/// VERSION 4 - Tích hợp các Control dự án (ImageSliderWidget, AppSlidingTabBar)
/// Duy trì logic Morphing Header và các quy chuẩn TMLab Style.
class CommunityProfilePageTest extends StatefulWidget {
  const CommunityProfilePageTest({super.key});

  @override
  State<CommunityProfilePageTest> createState() => _CommunityProfilePageTestState();
}

class _CommunityProfilePageTestState extends State<CommunityProfilePageTest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Danh sách 5 hình ảnh cho ImageSliderWidget
  final List<String> _sliderImages = [
    'https://picsum.photos/id/101/800/400',
    'https://picsum.photos/id/102/800/400',
    'https://picsum.photos/id/103/800/400',
    'https://picsum.photos/id/104/800/400',
    'https://picsum.photos/id/105/800/400',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Đồng bộ TabController với AppSlidingTabBar để cập nhật UI khi vuốt TabBarView
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_currentTabIndex != _tabController.index) {
          setState(() {
            _currentTabIndex = _tabController.index;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Header Morphing tích hợp ImageSliderWidget
            SliverPersistentHeader(
              pinned: true,
              delegate: ProfileHeaderDelegateV2(
                statusBarHeight: MediaQuery.paddingOf(context).top,
                tabBar: _buildTabBar(),
                sliderImages: _sliderImages,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildList("Bài viết"),
            _buildList("Yêu thích"),
            _buildList("Hình ảnh"),
          ],
        ),
      ),
    );
  }

  /// Sử dụng AppSlidingTabBar tùy chỉnh của dự án
  Widget _buildTabBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      alignment: Alignment.centerLeft, // Căn trái các tab theo yêu cầu
      child: AppSlidingTabBar<int>(
        items: [
          AppTabItem(value: 0, label: "Bài viết"),
          AppTabItem(value: 1, label: "Yêu thích"),
          AppTabItem(value: 2, label: "Hình ảnh"),
        ],
        currentItem: _currentTabIndex,
        onTabChanged: (index) {
          setState(() {
            _currentTabIndex = index;
            _tabController.animateTo(index);
          });
        },
        mode: TabIndicatorMode.underline,
        style: AppSlidingTabBarStyle(
          activeColor: TMLabsColor.primary,
          inactiveColor: TMLabsColor.grey,
          activeStyle: TMLabsTextStyle.bodyBold.copyWith(color: TMLabsColor.primary),
          inactiveStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
          spacing: 24,
          itemPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  /// Danh sách item mẫu sử dụng TMLab Style
  Widget _buildList(String label) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 20,
      itemBuilder: (context, index) => ListTile(
        leading: AvatarWidget(
          size: 40,
          imageUrl: 'https://picsum.photos/id/${index + 50}/200',
        ),
        title: Text("$label Item $index", style: TMLabsTextStyle.bodyBold),
        subtitle: Text("Nội dung chi tiết của $label số $index...", style: TMLabsTextStyle.caption),
      ),
    );
  }
}

/// Delegate điều khiển logic Morphing nâng cao tích hợp Controls dự án
class ProfileHeaderDelegateV2 extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;
  final Widget tabBar;
  final List<String> sliderImages;

  ProfileHeaderDelegateV2({
    required this.statusBarHeight,
    required this.tabBar,
    required this.sliderImages,
  });

  // Giữ nguyên các thông số kích thước từ Version 3
  final double imageHeight = 240.0;
  final double userCardHeight = 80.0;
  final double tabBarHeight = 48.0;
  final double spacing = 12.0;

  @override
  double get maxExtent => statusBarHeight + imageHeight + spacing + userCardHeight + spacing + tabBarHeight;

  @override
  double get minExtent => statusBarHeight + kToolbarHeight + tabBarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double totalShrinkRange = maxExtent - minExtent;
    final double shrinkPercentage = (shrinkOffset / totalShrinkRange).clamp(0.0, 1.0);

    // --- LOGIC NỘI SUY DI CHUYỂN (MORPHING) ---
    const double startAvatarSize = 60.0;
    const double endAvatarSize = 32.0;
    final double currentAvatarSize = lerpDouble(startAvatarSize, endAvatarSize, shrinkPercentage)!;

    final double startAvatarLeft = 16.0 + 16.0; 
    final double endAvatarLeft = 52.0; 
    final double currentAvatarLeft = lerpDouble(startAvatarLeft, endAvatarLeft, shrinkPercentage)!;

    final double startTextLeft = startAvatarLeft + startAvatarSize + 20.0; 
    final double endTextLeft = endAvatarLeft + endAvatarSize + 8.0; 
    final double currentTextLeft = lerpDouble(startTextLeft, endTextLeft, shrinkPercentage)!;

    final double currentTextSpacing = lerpDouble(10.0, 2.0, shrinkPercentage)!;

    final double startContentTop = statusBarHeight + imageHeight + spacing + (userCardHeight - startAvatarSize) / 2;
    final double endContentTop = statusBarHeight + (kToolbarHeight - endAvatarSize) / 2;
    final double currentContentTop = lerpDouble(startContentTop, endContentTop, shrinkPercentage)!;

    // --- MÀU SẮC & HIỆU ỨNG APPBAR ---
    final Color backButtonColor = Color.lerp(Colors.black, Colors.white, shrinkPercentage)!;
    final Color appBarBgColor = TMLabsColor.grey.withValues(alpha: shrinkPercentage);
    final double cardBgOpacity = (1.0 - shrinkPercentage * 2.5).clamp(0.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        // --- LAYER 1: IMAGE SLIDER WIDGET (PARALLAX & DỰ ÁN CONTROL) ---
        Positioned(
          top: -shrinkOffset * 0.5,
          left: 0,
          right: 0,
          height: imageHeight + statusBarHeight,
          child: ImageSliderWidget(
            images: sliderImages,
            height: imageHeight + statusBarHeight,
            indicatorType: ImageSliderIndicatorType.dots,
            fit: BoxFit.cover,
          ),
        ),

        // --- LAYER 2: APPBAR BACKGROUND LAYER ---
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: statusBarHeight + kToolbarHeight,
          child: Container(color: appBarBgColor),
        ),

        // --- LAYER 3: USER CARD BACKGROUND (MORPHING) ---
        Positioned(
          top: (statusBarHeight + imageHeight + spacing) - shrinkOffset,
          left: 16,
          right: 16,
          height: userCardHeight,
          child: Opacity(
            opacity: cardBgOpacity,
            child: Container(
              decoration: BoxDecoration(
                color: TMLabsColor.bgLight, 
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),

        // --- LAYER 4: MORPHING AVATAR (SỬ DỤNG AVATARWIDGET DỰ ÁN) ---
        Positioned(
          top: currentContentTop - (shrinkPercentage < 1.0 ? shrinkOffset * (1.0 - shrinkPercentage) : 0),
          left: currentAvatarLeft,
          child: AvatarWidget(
            size: currentAvatarSize,
            imageUrl: 'https://picsum.photos/id/64/200',
            backgroundColor: Colors.white,
          ),
        ),

        // --- LAYER 5: MORPHING TEXT (NICKNAME & STATS - TMLAB STYLE) ---
        Positioned(
          top: currentContentTop - (shrinkPercentage < 1.0 ? shrinkOffset * (1.0 - shrinkPercentage) : 0),
          left: currentTextLeft,
          height: currentAvatarSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Coffee Bean",
                style: TMLabsTextStyle.bodyBold.copyWith(
                  fontSize: lerpDouble(20, 14, shrinkPercentage),
                  color: Color.lerp(Colors.black, Colors.white, shrinkPercentage),
                  height: 1.1,
                ),
              ),
              SizedBox(height: currentTextSpacing), 
              Text(
                "1.2K Thích • 450 Chia sẻ",
                style: TMLabsTextStyle.caption.copyWith(
                  fontSize: lerpDouble(13, 10, shrinkPercentage),
                  color: Color.lerp(TMLabsColor.grey, Colors.white.withValues(alpha: 0.8), shrinkPercentage),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),

        // --- LAYER 6: APP SLIDING TABBAR (PINNED - DỰ ÁN CONTROL) ---
        Positioned(
          top: (maxExtent - tabBarHeight - shrinkOffset).clamp(statusBarHeight + kToolbarHeight, maxExtent),
          left: 0,
          right: 0,
          height: tabBarHeight,
          child: Material(
            elevation: shrinkPercentage > 0.98 ? 2 : 0,
            color: Colors.white,
            child: tabBar,
          ),
        ),

        // --- LAYER 7: IOS BACK BUTTON ---
        Positioned(
          top: statusBarHeight,
          left: 0,
          width: 56,
          height: kToolbarHeight,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: backButtonColor,
              size: 20,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant ProfileHeaderDelegateV2 oldDelegate) => true;
}
