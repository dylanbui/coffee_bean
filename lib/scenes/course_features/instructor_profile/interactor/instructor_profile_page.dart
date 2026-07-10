import 'dart:ui';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/instructor_profile_event_state.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/instructor_profile_interactor.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/widgets/instructor_course_item.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/widgets/instructor_header_info.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/widgets/instructor_post_item.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/models/instructor_profile_model.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:db_core/utils/app_sliding_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
        data: state.instructor!,
        safeAreaTop: MediaQuery.of(context).padding.top,
        onBack: () => interactor.router?.pop(),
        onFollowTap: interactor.onFollowTap,
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSlidingTabBar<InstructorTab>(
            currentItem: currentTab,
            style: TMLabsTabBarStyle.defaultStyle,
            items: [
              AppTabItem(value: InstructorTab.posts, label: "Bài đăng"),
              AppTabItem(value: InstructorTab.courses, label: "Khóa học"),
            ],
            onTabChanged: (tab) => interactor.onTabChanged(tab),
          ),
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
        ],
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
          ).animate(key: ValueKey("post_$index")).fadeIn(duration: 400.ms, delay: (index * 50).ms),
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
        ).animate(key: ValueKey("course_$index")).fadeIn(duration: 400.ms, delay: (index * 50).ms),
        childCount: state.courses.length,
      ),
    );
  }
}

class InstructorProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  final InstructorProfileModel data;
  final double safeAreaTop;
  final VoidCallback onBack;
  final VoidCallback onFollowTap;

  InstructorProfileHeaderDelegate({
    required this.data,
    required this.safeAreaTop,
    required this.onBack,
    required this.onFollowTap,
  });

  // Slider height 280, Info height ~130. Total ~410.
  @override
  double get maxExtent => 280.0 + 130.0;
  
  @override
  double get minExtent => kToolbarHeight + safeAreaTop;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 0.0 to 1.0 based on scroll
    final double percent = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    
    // Animation phases
    // Phase 1: Slider disappears (0 to 280 offset)
    // Phase 2: Info section animates into AppBar (280 to 410 offset)
    
    final double sliderVisiblePercent = (1.0 - (shrinkOffset / 200.0)).clamp(0.0, 1.0);
    final double appBarVisiblePercent = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    
    // Flying Animation Logic
    // Avatar starts at (16, 280 + 16) and ends at (48, safeAreaTop + centered)
    final double avatarSize = lerpDouble(70, 40, percent)!;
    final double avatarX = lerpDouble(16, 48, percent)!;
    final double avatarY = lerpDouble(
      280.0 + 16.0 - shrinkOffset,
      safeAreaTop + (kToolbarHeight - 40) / 2,
      percent
    )!;

    // Name starts next to avatar and ends next to collapsed avatar
    final double nameX = lerpDouble(16 + 70 + 10, 48 + 32 + 18, percent)!;
    final double nameY = lerpDouble(
      280.0 + 16.0 - shrinkOffset,
      safeAreaTop + (kToolbarHeight - 20) / 2,
      percent
    )!;
    final double nameScale = lerpDouble(1.0, 0.8, percent)!;

    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Image Slider (Background)
          Positioned(
            top: -shrinkOffset * 0.5, // Slow scroll parallax
            left: 0,
            right: 0,
            height: 280,
            child: Opacity(
              opacity: sliderVisiblePercent,
              child: context.imageSlider(
                images: data.coverImages,
                height: 280,
                indicatorType: ImageSliderIndicatorType.dots,
              ),
            ),
          ),

          // 2. Info Section (The part that fades out)
          Positioned(
            top: 280 - shrinkOffset,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: (1.0 - percent * 2).clamp(0.0, 1.0),
              child: InstructorHeaderInfo(
                data: data,
                onFollowTap: onFollowTap,
                isTemplate: true, // Internal flag to hide internal avatar/name
              ),
            ),
          ),
          
          // 3. AppBar Layer (Back Button & Border)
          Positioned(
            top: safeAreaTop,
            left: 0,
            right: 0,
            height: kToolbarHeight,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: appBarVisiblePercent > 0.5 ? Colors.black : Colors.white,
                    size: 20,
                  ),
                  onPressed: onBack,
                ),
                const Spacer(),
              ],
            ),
          ),

          // 4. Flying Avatar (The Magic)
          Positioned(
            left: avatarX,
            top: avatarY,
            child: AvatarWidget(imageUrl: data.avatar, size: avatarSize),
          ),

          // 5. Flying Name
          Positioned(
            left: nameX,
            top: nameY,
            child: Transform.scale(
              alignment: Alignment.centerLeft,
              scale: nameScale,
              child: Text(
                data.name,
                style: TMLabsTextStyle.h2.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
      ),
    );
  }

  @override
  bool shouldRebuild(covariant InstructorProfileHeaderDelegate oldDelegate) => true;
}
