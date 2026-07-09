import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/course_learning_catalog_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/course_learning_catalog_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/mock_data.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/app_label.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseLearningCatalogPage extends AppCubitStateFulWidget<CourseLearningCatalogInteractor, CourseLearningCatalogState> {
  CourseLearningCatalogPage({super.key, required super.interactor});

  @override
  State<CourseLearningCatalogPage> createState() => _CourseLearningCatalogPageState();
}

class _CourseLearningCatalogPageState extends AppCubitState<CourseLearningCatalogPage, CourseLearningCatalogInteractor, CourseLearningCatalogState> {
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CourseLearningCatalogInteractor, CourseLearningCatalogState>(
      builder: (context, state) {
        if (state.isLoading || state.courseDetail == null) return getLoadingView();
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(state),
              SliverToBoxAdapter(child: _buildCourseInfo(state)),
              SliverToBoxAdapter(child: _buildInstructorBox(state)),
              SliverToBoxAdapter(child: _buildLessonHeader(state)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildLessonItem(state.lessons[index]),
                  childCount: state.lessons.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(CourseLearningCatalogState state) {
    final course = state.courseDetail!;
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
      titleWidget: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          final isCollapsed = top <= kToolbarHeight + (MediaQuery.of(context).padding.top);
          return isCollapsed
              ? Text("LỘ TRÌNH HỌC TẬP", style: TmLabAppBarStyle.whiteStyle.titleTextStyle)
              : const SizedBox.shrink();
        },
      ),
      background: context.imageSlider(
        images: course.courseCover,
        height: 320,
        indicatorType: ImageSliderIndicatorType.all,
      ),
    );
  }

  Widget _buildCourseInfo(CourseLearningCatalogState state) {
    final course = state.courseDetail!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course.courseName, style: TMLabsTextStyle.h1),
          const SizedBox(height: 8),
          Text(
            course.courseDesc ?? "",
            style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorBox(CourseLearningCatalogState state) {
    final instructor = state.instructor;
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
                AvatarWidget(
                  imageUrl: instructor?.instructorAvatar,
                  size: 30,
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
                              instructor?.instructorName ?? "Đang cập nhật",
                              style: TMLabsTextStyle.bodyBold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AppLabel(
                            "Giảng viên chính",
                            borderRadius: 12,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              instructor?.instructorDesc ?? "Chưa có giới thiệu",
              style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonHeader(CourseLearningCatalogState state) {
    final completedCount = state.lessons.where((l) => l.isCompleted).length;
    final totalCount = state.lessons.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Danh mục khóa học", style: TMLabsTextStyle.h2),
          AppLabel(
            "Tiến độ học tập: $completedCount/$totalCount",
            backgroundColor: TMLabsColor.bgLight,
            style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
            borderRadius: 8,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(LessonModel lesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TapEffect(
        onTap: () => interactor.onLessonTap(lesson),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TMLabsColor.bgLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text("${lesson.id}. ", style: TMLabsTextStyle.bodyBold),
              Expanded(
                child: Text(
                  lesson.title,
                  style: TMLabsTextStyle.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (lesson.isNew)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 20, color: TMLabsColor.grey),
            ],
          ),
        ),
      ),
    );
  }
}
