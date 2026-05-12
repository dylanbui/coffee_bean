import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/app_landing/home/home_router.dart';

class HomeInteractor extends Cubit<HomeState> {
  final HomeRoutable router;

  HomeInteractor(this.router) : super(HomeInitial());

  void initData() async {
    // Simulate initial loading
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      isInitialLoading: false,
      topImageData: TopImageData(
        images: [
          'https://images.unsplash.com/photo-1501339819358-ee5969a1f18c?q=80&w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=800&auto=format&fit=crop',
        ],
        userName: "Gigi",
      ),
      quickActionsData: QuickActionsData(
        items: [
          QuickActionItem(icon: Icons.assignment_turned_in_outlined, label: 'Đặt chỗ'),
          QuickActionItem(icon: Icons.sync_alt, label: 'Đổi điểm'),
          QuickActionItem(icon: Icons.school_outlined, label: 'Tất cả khóa học'),
          QuickActionItem(icon: Icons.business_center_outlined, label: 'Trung tâm sk'),
        ],
      ),
      announcementData: AnnouncementData(
        message: "Menu mới với combo trader health các món ăn giàu dinh dưỡng... Đặt hàng ngay để nhận ưu đãi!",
      ),
      promoData: PromoData(
        title: "Banner quảng cáo",
        description: "Hiển thị banner dạng nhỏ nhấn vào sẽ đến trang...",
      ),
      featuredCoursesData: FeaturedCoursesData(
        items: [
          CourseItem(title: "INNER CIRCLE TRADER", imageUrl: 'https://images.unsplash.com/photo-1541167760496-162955ed8a9f?q=80&w=400&auto=format&fit=crop'),
          CourseItem(title: "QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH", imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop'),
          CourseItem(title: "PHÂN TÍCH KỸ THUẬT NÂNG CAO", imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=800&auto=format&fit=crop'),
        ],
      ),
    ));
  }

  void refreshData() async {
    // In reality, this would fetch from API and use copyWith
    initData();
  }

  void openSearch() {
    // Logic to navigate to Global Search
  }
  
  void selectStore() {
    // Logic to select store
    router.navigate(ChooseStoreRoute());
  }

  void quickActions(int index) {
    // Logic to select store
    switch (index) {
      case 1:
        ;
      case 2:
        ;
    }
    if (index == 0 ) {

    }
    router.navigate(ChooseStoreRoute());
  }


}
