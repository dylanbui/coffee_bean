import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/interactor/course_learning_detail_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/interactor/course_learning_detail_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class CourseLearningDetailPage extends AppCubitStateFulWidget<CourseLearningDetailInteractor, CourseLearningDetailState> {
  CourseLearningDetailPage({super.key, required super.interactor});

  @override
  State<CourseLearningDetailPage> createState() => _CourseLearningDetailPageState();
}

class _CourseLearningDetailPageState extends AppCubitState<CourseLearningDetailPage, CourseLearningDetailInteractor, CourseLearningDetailState> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final collapsed = _scrollController.offset > (320 - kToolbarHeight - MediaQuery.of(context).padding.top);
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
    return BlocBuilder<CourseLearningDetailInteractor, CourseLearningDetailState>(
      builder: (context, state) {
        if (state.isLoading || state.lesson == null) return getLoadingView();

        final lesson = state.lesson!;
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(state),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lesson.lessonName, style: TMLabsTextStyle.h1),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      if ((lesson.lessonDetail ?? "").isNotEmpty)
                        Html(
                          data: lesson.lessonDetail ?? "",
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
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 800)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(CourseLearningDetailState state) {
    return CoffeeSliverAppBar(
      expandedHeight: 320,
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
              ? Text("CHI TIẾT BÀI HỌC", style: TmLabAppBarStyle.whiteStyle.titleTextStyle)
              : const SizedBox.shrink();
        },
      ),
      background: _buildVideoPlaceholder(),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      width: double.infinity,
      height: 320,
      color: TMLabsColor.bgSecond,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 8),
            Text(
              "Video bài học",
              style: TMLabsTextStyle.body.copyWith(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
