import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import các panel đã tách
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/top_image_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/quick_actions_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/announcement_bar_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/promo_banner_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/featured_courses_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/course_sellers_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/posts_list_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/course_videos_panel.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/widget/financial_courses_panel.dart';

//ignore: must_be_immutable
class HomePage extends CubitStateFulWidget<HomeInteractor, HomeState> {
  HomePage({super.key, required super.interactor});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends CubitState<HomePage, HomeInteractor, HomeState> {
  @override
  dynamic getAppBar(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return BlocProvider.value(
      value: interactor,
      child: BlocBuilder<HomeInteractor, HomeState>(
        buildWhen: (previous, current) => previous.isInitialLoading != current.isInitialLoading,
        builder: (context, state) {
          if (state.isInitialLoading) {
            return const Scaffold(body: Center(child: LoadingView(width: 150, height: 150)));
          }

          return Scaffold(backgroundColor: Colors.white, body: getBody(context));
        },
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    // "Phẳng hóa": Home page chỉ quản lý khung (SizedBox, Padding) và các Panel con
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Image Panel (Full width)
          TopImagePanel(interactor: interactor),

          // 2. Quick Actions (Vertical padding 20)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: QuickActionsPanel(interactor: interactor),
          ),

          // 3. Announcement (Horizontal padding 16)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnnouncementBarPanel(interactor: interactor),
          ),

          const SizedBox(height: 16),

          // 4. Promo Banner (Horizontal padding 16)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PromoBannerPanel(interactor: interactor),
          ),

          // 5. Featured Courses (Vertical spacing 24, internally handles horizontal padding for title)
          const SizedBox(height: 24),
          FeaturedCoursesPanel(interactor: interactor),

          // 6. Course Sellers (Vertical spacing 24)
          const SizedBox(height: 24),
          CourseSellersPanel(interactor: interactor),

          // 7. Posts List (Vertical spacing 15)
          const SizedBox(height: 15),
          PostsListPanel(interactor: interactor),

          // 8. Course Videos (Vertical spacing 24)
          const SizedBox(height: 24),
          CourseVideosPanel(interactor: interactor),

          // 9. Financial Courses (Vertical spacing 24)
          const SizedBox(height: 24),
          FinancialCoursesPanel(interactor: interactor),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
