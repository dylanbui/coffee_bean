import 'package:coffee_bean/data/model/response/system/announcement.dart';
import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/scenes/announcement_detail/announcement_detail_builder.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_builder.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:db_core/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

class HomeInteractor extends CubitInteractor<HomeRoutable, HomeState> {
  late final AuthHelper _authHelper;
  late final InfraRepository _infraRepository;

  HomeInteractor(HomeRoutable router) : super(HomeInitial(), router: router) {
    _authHelper = AuthHelper(router as DbNoteRouter);
    _infraRepository = locator<InfraRepository>();
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    initData();
  }

  void initData() async {
    // 1. Fetch announcements
    final announcementResult = await _infraRepository.getAnnouncementList(2); // type=2 for announcements
    List<Announcement> announcements = [];
    if (announcementResult case DbSuccess(data: final list)) {
      announcements = list;
    }

    // Simulate initial loading
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      isInitialLoading: false,
      topImageData: TopImageData(
        images: [
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=1080&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=1080&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=1080&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=1080&auto=format&fit=crop',
        ],
        userName: "Gigi",
      ),
      quickActionsData: QuickActionsData(
        items: [
          QuickActionItem(key: "dat_cho", icon: AppAssets.icons.icDatCho, label: AppStrings.booking),
          QuickActionItem(key: "doi_diem", icon: AppAssets.icons.icDoiDiem, label: AppStrings.redeemPoints),
          QuickActionItem(key: "khoa_hoc", icon: AppAssets.icons.icKhoaHoc, label: AppStrings.allCourses),
          QuickActionItem(key: "trung_tam_sk", icon: AppAssets.icons.icTrungTam, label: AppStrings.healthCenter),
        ],
      ),
      announcementData: AnnouncementData(
        message: "Menu mới với combo trader health các món ăn giàu dinh dưỡng... Đặt hàng ngay để nhận ưu đãi!",
      ),
      announcements: announcements,
      promoData: PromoData(
        title: "Banner quảng cáo",
        description: "Hiển thị banner dạng nhỏ nhấn vào sẽ đến trang...",
      ),
      featuredCoursesData: FeaturedCoursesData(
        items: [
          CourseItem(title: "INNER CIRCLE TRADER", imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=400&auto=format&fit=crop'),
          CourseItem(title: "QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH", imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop'),
          CourseItem(title: "PHÂN TÍCH KỸ THUẬT NÂNG CAO", imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=400&auto=format&fit=crop'),
        ],
      ),
      courseSellersData: CourseSellersData(
        items: [
          SellerItem(id: 1, name: "Tyler Ballmer One", imageUrl: "https://i.pravatar.cc/300"),
          SellerItem(id: 2, name: "Julia Two", imageUrl: "https://i.pravatar.cc/310"),
          SellerItem(id: 3, name: "Stella Three", imageUrl: "https://i.pravatar.cc/320"),
          SellerItem(id: 4, name: "Henry", imageUrl: "https://i.pravatar.cc/330"),
          SellerItem(id: 5, name: "Henry Four", imageUrl: "https://i.pravatar.cc/340"),
          SellerItem(id: 6, name: "Henry Five", imageUrl: "https://i.pravatar.cc/350"),
          SellerItem(id: 7, name: "My Team", imageUrl: "https://picsum.photos/id/34/200/200"),
          SellerItem(id: 8, name: "Coffee Four", imageUrl: "https://picsum.photos/id/35/200/200"),
          SellerItem(id: 9, name: "Tea Five", imageUrl: "https://picsum.photos/id/36/200/200"),
        ],
      ),
      courseVideosData: CourseVideosData(
        items: [
          CourseVideoItem(
            title: "KHÓA HỌC QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH",
            imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=400&auto=format&fit=crop',
            videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            authorName: "Lorem ipsum",
            authorAvatar: "https://i.pravatar.cc/100",
          ),
          CourseVideoItem(
            title: "KHÓA HỌC QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH",
            imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop',
            videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            authorName: "Lorem ipsum",
            authorAvatar: "https://i.pravatar.cc/110",
          ),
          CourseVideoItem(
            title: "KHÓA HỌC QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH",
            imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=400&auto=format&fit=crop',
            videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            authorName: "Lorem ipsum",
            authorAvatar: "https://i.pravatar.cc/120",
          ),
        ],
      ),
      postsData: PostsData(
        items: List.generate(
          5,
          (index) => PostItem(
            id: index + 1,
            authorName: "TylerBallmer invest",
            authorAvatar: "https://i.pravatar.cc/300",
            postDate: "23/04/2026",
            title: "Lorem ipsum dolor sit amet, con",
            content:
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper s...",
            images: [
              'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=400&auto=format&fit=crop',
              'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop',
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=400&auto=format&fit=crop',
              'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=400&auto=format&fit=crop',
              'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop',
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=400&auto=format&fit=crop',
            ],
            shareCount: 200,
            commentCount: 1250,
            likeCount: 1000,
            marketData: [
              MarketData(symbol: "XAU/USD", change: "+16%", isPositive: true),
              MarketData(symbol: "EUR/USD", change: "+1.25%", isPositive: true),
              MarketData(symbol: "BTC/USD", change: "-36%", isPositive: false),
              MarketData(symbol: "BTC/USD", change: "-36%", isPositive: false),
              MarketData(symbol: "BTC/USD", change: "-36%", isPositive: false),
              MarketData(symbol: "BTC/USD", change: "-36%", isPositive: false),
            ],
          ),
        ),
      ),

      financialCoursesData: FinancialCoursesData(
        items: [
          FinancialCourseItem(
            title: "Mua khóa học thực chiến giao dịch Stock",
            imageUrl: 'https://images.unsplash.com/photo-1535320903710-d993d3d77d29?q=80&w=400&auto=format&fit=crop',
            price: 54330000,
          ),
          FinancialCourseItem(
            title: "Mua khóa học thực chiến giao dịch Stock",
            imageUrl: 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?q=80&w=400&auto=format&fit=crop',
            price: 5433000,
          ),
          FinancialCourseItem(
            title: "Mua khóa học thực chiến giao dịch Stock",
            imageUrl: 'https://images.unsplash.com/photo-1535320903710-d993d3d77d29?q=80&w=400&auto=format&fit=crop',
            price: 543300000,
          ),
        ],
      ),

    ));
  }

  void refreshData() async {
    // In reality, this would fetch from API and use copyWith
    initData();
  }

  void openGlobalSearch() {
    // Logic to navigate to Global Search
    router?.navigate(GlobalSearchRoute());
  }
  
  void openSelectStore() {
    // Logic to select store
    router?.navigate(ChooseStoreRoute());
  }

  void quickActions(QuickActionItem actionItem) {
    // Logic for quick actions
    if (actionItem.key == "dat_cho") {
      router?.navigate(ReservationListRoute());
    }
    if (actionItem.key == "khoa_hoc") {
      router?.navigate(CourseListRoute());
    }
    if (actionItem.key == "trung_tam_sk") {
      router?.navigate(ActivityListRoute());
    }
  }

  void onRedeemPointsTap(BuildContext context) {
    _authHelper.requireAuth(
      context: context,
      confirmMessage: AppStrings.redeemPointsLoginMsg,
      onAuthenticated: (userData, isNewLogin) {
        debugPrint("Auth Flow Success - isNewLogin: $isNewLogin");
        if (isNewLogin) {
          FlashToastHelper.success(context, "Đăng nhập thành công !");
        }
        // AuthHelper has automatically broadcasted UserLoginSuccessEvent upon successful new login
        // NOTE: The navigate command might not execute immediately due to a race condition 
        // with the Modal Login closure in the RIBs Flow. 
        // For now, it's acceptable for the user to tap again to confirm the request.
        // Future fix: Ensure the Modal is completely closed before performing a new navigation.
        router?.navigate(MyPointListRoute());
      },
      onCancel: (error) {
        if (error.code != 100) {
          FlashToastHelper.error(context, error.message);
        }
        debugPrint("User cancelled or error login flow for points: ${error.message}");
      },
    );
  }

  void selectSeller(SellerItem item) {
    // Logic for select seller
    router?.navigate(SellerDetailRoute(item.id));
  }

  void selectCourse(CourseItem item) {
    // Logic for select course
    debugPrint("Selected course: ${item.title}");
  }

  void selectMarketTag(MarketData data) {
    // Logic for select market tag
  }

  void selectPost(PostItem item) {
    router?.navigate(PostDetailRoute(item.id));
  }

  void playVideo(CourseVideoItem item) {
    // Logic to play video
    // Use flick_video_player or chewie for video playback
    debugPrint("Playing video: ${item.videoUrl}");
  }

  void addToCart(FinancialCourseItem item) {
    // Logic to add to cart
    debugPrint("Added to cart: ${item.title}");
  }

  void onAnnouncementTap(Announcement announcement) {
    router?.navigate(AnnouncementDetailRoute(announcement.id));
  }
}
