import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/instructor_profile_event_state.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/instructor_profile_interactor.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/widgets/instructor_course_item.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/widgets/instructor_header_info.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/widgets/instructor_post_item.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class InstructorProfilePage extends AppCubitStateFulWidget<InstructorProfileInteractor, InstructorProfileState> {
  InstructorProfilePage({super.key, required super.interactor});

  @override
  State<InstructorProfilePage> createState() => _InstructorProfilePageState();
}

class _InstructorProfilePageState extends AppCubitState<InstructorProfilePage, InstructorProfileInteractor, InstructorProfileState> {
  
  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<InstructorProfileInteractor, InstructorProfileState>(
      builder: (context, state) {
        if (state.isLoading || state.instructor == null) return getLoadingView();

        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              _buildSliverHeader(state),
              SliverToBoxAdapter(
                child: InstructorHeaderInfo(
                  data: state.instructor!,
                  onFollowTap: interactor.onFollowTap,
                ),
              ),
              SliverToBoxAdapter(child: _buildBio(state.instructor?.bio)),
              SliverToBoxAdapter(child: _buildTabSelection(state.currentTab)),
              
              if (state.currentTab == InstructorTab.posts)
                _buildPostsGrid(state)
              else
                _buildCoursesList(state),
                
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverHeader(InstructorProfileState state) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: InstructorProfileHeaderDelegate(
        instructorName: state.instructor!.name,
        avatarUrl: state.instructor!.avatar,
        coverImages: state.instructor!.coverImages,
        safeAreaTop: MediaQuery.of(context).padding.top,
        onBack: () => interactor.router?.pop(),
      ),
    );
  }

  Widget _buildBio(String? bio) {
    if (bio == null || bio.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Html(
        data: bio,
        style: {
          "p": Style(
            fontSize: FontSize(14),
            color: TMLabsColor.grey,
            lineHeight: const LineHeight(1.5),
          ),
        },
      ),
    );
  }

  Widget _buildTabSelection(InstructorTab currentTab) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Row(
        children: [
          const SizedBox(width: 16),
          _buildTabItem("Bài đăng", InstructorTab.posts, currentTab),
          const SizedBox(width: 24),
          _buildTabItem("Khóa học", InstructorTab.courses, currentTab),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, InstructorTab tab, InstructorTab currentTab) {
    final isSelected = tab == currentTab;
    return TapEffect(
      onTap: () => interactor.onTabChanged(tab),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TMLabsTextStyle.bodyBold.copyWith(
                color: isSelected ? Colors.black : TMLabsColor.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsGrid(InstructorProfileState state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => InstructorPostItem(
            data: state.posts[index],
            onTap: () => interactor.onPostTap(state.posts[index].id),
          ),
          childCount: state.posts.length,
        ),
      ),
    );
  }

  Widget _buildCoursesList(InstructorProfileState state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => InstructorCourseItem(
          data: state.courses[index],
          onTap: () => interactor.onCourseTap(state.courses[index].id),
        ),
        childCount: state.courses.length,
      ),
    );
  }
}

class InstructorProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String instructorName;
  final String? avatarUrl;
  final List<String> coverImages;
  final double safeAreaTop;
  final VoidCallback onBack;

  InstructorProfileHeaderDelegate({
    required this.instructorName,
    this.avatarUrl,
    required this.coverImages,
    required this.safeAreaTop,
    required this.onBack,
  });

  @override
  double get maxExtent => 280.0;
  
  @override
  double get minExtent => kToolbarHeight + safeAreaTop;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double percent = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Background Slider (Mờ dần khi scroll up)
        Opacity(
          opacity: (1.0 - percent).clamp(0.0, 1.0),
          child: ImageSliderWidget(
            images: coverImages,
            height: maxExtent,
            indicatorType: ImageSliderIndicatorType.dots,
          ),
        ),
        
        // White overlay for status bar when collapsed
        IgnorePointer(
          ignoring: percent < 0.5,
          child: Opacity(
            opacity: percent,
            child: Container(color: Colors.white),
          ),
        ),

        // 2. AppBar Area (Back Button + Collapsed Content)
        Positioned(
          top: safeAreaTop,
          left: 0,
          right: 0,
          height: kToolbarHeight,
          child: Row(
            children: [
              // Back Button
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: percent > 0.5 ? Colors.black : Colors.white,
                  size: 20,
                ),
                onPressed: onBack,
              ),
              
              // Collapsed Content: Avatar + Name (Hiện dần)
              Expanded(
                child: IgnorePointer(
                  ignoring: percent < 0.7,
                  child: Opacity(
                    opacity: (percent * 2 - 1.0).clamp(0.0, 1.0),
                    child: Row(
                      children: [
                        AvatarWidget(imageUrl: avatarUrl, size: 32),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            instructorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TMLabsTextStyle.h2.copyWith(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Bottom border when collapsed
        if (percent > 0.95)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: 0.5, color: TMLabsColor.grey.withValues(alpha: 0.3)),
          ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant InstructorProfileHeaderDelegate oldDelegate) => true;
}
