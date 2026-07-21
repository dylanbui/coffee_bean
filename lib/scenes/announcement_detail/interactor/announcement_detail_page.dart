import 'dart:math' as math;
import 'package:coffee_bean/data/model/response/system/announcement.dart';
import 'package:coffee_bean/scenes/announcement_detail/interactor/announcement_detail_event_state.dart';
import 'package:coffee_bean/scenes/announcement_detail/interactor/announcement_detail_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';

class AnnouncementDetailPage extends AppCubitStateFulWidget<AnnouncementDetailInteractor, AnnouncementDetailState> {
  AnnouncementDetailPage({super.key, required super.interactor});

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends AppCubitState<AnnouncementDetailPage, AnnouncementDetailInteractor, AnnouncementDetailState> {
  
  @override
  String? getTitle() => null; // Ẩn AppBar mặc định để dùng SliverAppBar

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<AnnouncementDetailInteractor, AnnouncementDetailState>(
      builder: (context, state) {
        final announcement = state.announcement;
        
        if (announcement == null && state.isLoading) {
          return getLoadingView();
        }
        
        if (announcement == null) {
          return getEmptyItemView(caption: "Không tìm thấy nội dung thông báo");
        }

        return CustomScrollView(
          key: ValueKey("announcement_detail_${announcement.id}"),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: AnnouncementHeaderDelegate(
                announcement: announcement,
                safeAreaTop: MediaQuery.of(context).padding.top,
                onBack: () => interactor.router?.pop(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Html(
                  data: announcement.content,
                  style: {
                    "body": Style(
                      fontSize: FontSize(14),
                      color: TMLabsColor.primary,
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                  },
                ),
              ),
            ),
            // Mock data
            const SliverToBoxAdapter(
              child: SizedBox(height: 500),
            ),
          ],
        );
      },
    );
  }
}

class AnnouncementHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Announcement announcement;
  final double safeAreaTop;
  final VoidCallback onBack;

  AnnouncementHeaderDelegate({
    required this.announcement,
    required this.safeAreaTop,
    required this.onBack,
  });

  @override
  double get maxExtent => 180.0; // Giảm xuống 150 theo yêu cầu

  @override
  double get minExtent => kToolbarHeight + safeAreaTop;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double percent = math.min(1.0, shrinkOffset / (maxExtent - minExtent));
    
    final String bgImage = announcement.type == 1 
        ? "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=1000" 
        : "https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=1000";

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Background Image (Mờ dần khi scroll lên)
        Opacity(
          opacity: (1.0 - percent).clamp(0.0, 1.0),
          child: Image.network(bgImage, fit: BoxFit.cover),
        ),

        // 2. Lớp nền trắng (Hiện dần lên)
        Opacity(
          opacity: percent.clamp(0.0, 1.0),
          child: Container(color: Colors.white),
        ),

        // 3. Cụm Title & Time khi MỞ RỘNG (Canh Phải - Mờ dần)
        Opacity(
          opacity: (1.0 - percent * 2).clamp(0.0, 1.0), // Biến mất nhanh hơn để không bị chồng
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    announcement.title,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TMLabsTextStyle.h2.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  if (announcement.createTime != null)
                    Text(
                      announcement.displayCreateTime,
                      style: TMLabsTextStyle.caption.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 4. Cụm Title & Time khi THU NHỎ (Canh Trái - Hiện dần trên AppBar)
        Opacity(
          opacity: (percent * 2 - 1.0).clamp(0.0, 1.0), // Chỉ hiện khi đã scroll quá 50%
          child: Padding(
            padding: EdgeInsets.only(top: safeAreaTop, left: 50, right: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (announcement.createTime != null)
                    Text(
                      announcement.displayCreateTime,
                      style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey, fontSize: 10),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 5. Nút Back (Cố định góc trên trái)
        Positioned(
          top: safeAreaTop,
          left: 8,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: percent > 0.5 ? TMLabsColor.primary : Colors.white,
              size: 20,
            ),
            onPressed: onBack,
          ),
        ),

        // 6. Border dưới AppBar
        if (percent > 0.95)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(height: 0.5, color: TMLabsColor.grey.withValues(alpha: 0.3)),
          ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant AnnouncementHeaderDelegate oldDelegate) {
    return oldDelegate.announcement != announcement || oldDelegate.safeAreaTop != safeAreaTop;
  }
}
