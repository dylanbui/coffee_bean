import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/interactor/course_detail_event_state.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/interactor/course_detail_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:coffee_bean/shared/ui_control/share_action/share_poster_dialog.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailPage extends AppCubitStateFulWidget<CourseDetailInteractor, CourseDetailState> {
  CourseDetailPage({super.key, required super.interactor});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends AppCubitState<CourseDetailPage, CourseDetailInteractor, CourseDetailState> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentImageIndex = 0;
  bool _isCollapsed = false;
  Widget? _commentPlugin;

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

  void _showShareDialog(CourseDetailState state) {
    SharePosterDialog.show(
      context: context,
      imageUrl: state.images.isNotEmpty ? state.images.first : "",
      title: state.courseTitle,
      shareLink: "https://tmlabs.coffee/course/${interactor.courseId}",
      shareText: "Tham gia cùng tôi tại khóa học: ${state.courseTitle}",
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CourseDetailInteractor, CourseDetailState>(
      builder: (context, state) {
        if (state.isLoading) return getLoadingView();
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(state),
              SliverToBoxAdapter(child: _buildCourseInfo(state)),
              SliverToBoxAdapter(child: _buildInstructorBox(state)),

              // --- MOCK DATA SECTIONS (Xóa khi có API) ---
              SliverToBoxAdapter(child: _buildCourseContent(state)),
              SliverToBoxAdapter(child: _buildAboutCourse(state)),
              // ------------------------------------------

              SliverToBoxAdapter(child: _buildCommentSection(state)),
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom spacing
            ],
          ),
          bottomNavigationBar: _buildFooter(state),
        );
      },
    );
  }

  Widget _buildSliverAppBar(CourseDetailState state) {
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
          padding: const EdgeInsets.only(right: 8),
          child: TapEffect(
            onTap: () => _showShareDialog(state),
            child: Icon(
              Icons.share_outlined,
              color: _isCollapsed ? TMLabsColor.primary : Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TapEffect(
            // TapEffect mặc định có throttleDuration là 500ms
            onTap: interactor.onLikeTap,
            child: Icon(
              state.isLiked ? Icons.favorite : Icons.favorite_border,
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
              ? Text("CHI TIẾT KHÓA HỌC", style: TmLabAppBarStyle.whiteStyle.titleTextStyle)
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

  Widget _buildCourseInfo(CourseDetailState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(state.courseTitle, style: TMLabsTextStyle.h1),
          const SizedBox(height: 8),
          Text(
            state.courseDescription,
            style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorBox(CourseDetailState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 90),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TMLabsColor.bgLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(state.instructorAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              state.instructorName,
                              style: TMLabsTextStyle.bodyBold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AppLabel(
                            "Giảng viên chính",
                            borderRadius: 12,
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                            backgroundColor: TMLabsColor.lightGrey.withValues(alpha: 0.8),
                            style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                AppButton(
                  text: "Chi tiết",
                  style: TMLabsButtonStyle.outline.copyWith(
                    borderRadius: 12,
                    textStyle: TMLabsTextStyle.small.copyWith(color: TMLabsColor.grey),
                    borderColor: TMLabsColor.lightGrey,
                  ),
                  rightIcon: const Icon(Icons.chevron_right, size: 16, color: TMLabsColor.grey),
                  width: 76,
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  mainAxisSize: MainAxisSize.min,
                  onPressed: interactor.onInstructorDetailTap,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              state.instructorBio,
              style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // --- MOCK DATA WIDGETS ---

  Widget _buildCourseContent(CourseDetailState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Nội dung khóa học", style: TMLabsTextStyle.h2),
          const SizedBox(height: 12),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_fill, color: TMLabsColor.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Bài ${index + 1}: Nội dung hướng dẫn chi tiết phần ${index + 1}",
                      style: TMLabsTextStyle.body,
                    ),
                  ),
                  Text("15:00", style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCourse(CourseDetailState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Về khóa học này", style: TMLabsTextStyle.h2),
          const SizedBox(height: 12),
          Text(
            "Đây là một khóa học chuyên sâu được thiết kế để cung cấp cho bạn những kiến thức thực tế nhất. Bạn sẽ được học qua các ví dụ thực tiễn, bài tập thực hành và được giảng viên hỗ trợ trực tiếp.\n\n"
            "Mục tiêu của khóa học là giúp bạn làm chủ các kỹ năng cần thiết trong thời gian ngắn nhất nhưng vẫn đảm bảo được chất lượng kiến thức thu nhận được.\n\n"
            "Hãy bắt đầu hành trình chinh phục kiến thức mới ngay hôm nay cùng chúng tôi!",
            style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
          ),
        ],
      ),
    );
  }

  // -------------------------

  Widget _buildCommentSection(CourseDetailState state) {
    _commentPlugin ??= CommentListBuilder(
      productId: interactor.courseId,
      type: 0, // 0 for all comments
    ).buildPlugin(5, interactor.commentController);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: _commentPlugin!,
    );
  }

  Widget _buildFooter(CourseDetailState state) {
    final totalPrice = NumberToVietnamese.formatNumber(state.totalAmount);

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
          Text(
            totalPrice,
            style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.w900),
          ),
          AppButton(
            text: "MUA KHÓA HỌC",
            style: TMLabsButtonStyle.primary,
            width: 164,
            height: 30,
            onPressed: interactor.onBuyTap,
          ),
        ],
      ),
    );
  }
}
