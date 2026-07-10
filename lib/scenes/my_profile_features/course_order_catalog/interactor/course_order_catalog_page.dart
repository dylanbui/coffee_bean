import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/course_order_catalog_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/course_order_catalog_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/widgets/course_order_item_widget.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CourseOrderCatalogPage extends AppCubitStateFulWidget<CourseOrderCatalogInteractor, CourseOrderCatalogState> {
  CourseOrderCatalogPage({super.key, required super.interactor});

  @override
  State<CourseOrderCatalogPage> createState() => _CourseOrderCatalogPageState();
}

class _CourseOrderCatalogPageState extends AppCubitState<CourseOrderCatalogPage, CourseOrderCatalogInteractor, CourseOrderCatalogState> {
  
  @override
  String? getTitle() => "Đơn hàng khóa học";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CourseOrderCatalogInteractor, CourseOrderCatalogState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildTabSelection(state.activeTabIndex),
            Expanded(
              child: state.isLoading 
                ? getLoadingView() 
                : _buildOrderList(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabSelection(int activeTabIndex) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTabButton("Tất cả", 0, activeTabIndex),
              const SizedBox(width: 20),
              _buildTabButton("Chờ thanh toán", 1, activeTabIndex),
              const SizedBox(width: 20),
              _buildTabButton("Đã hoàn thành", 2, activeTabIndex),
              const SizedBox(width: 20),
              _buildTabButton("Đã hủy", 3, activeTabIndex),
            ],
          ),
          const SizedBox(height: 4),
          // Sliding Underline
          AnimatedPadding(
            duration: 300.ms,
            curve: Curves.easeInOut,
            padding: EdgeInsets.only(
              left: _getTabUnderlineOffset(activeTabIndex),
            ),
            child: Container(
              height: 2,
              width: _getTabUnderlineWidth(activeTabIndex),
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
        ],
      ),
    );
  }

  double _getTabUnderlineOffset(int index) {
    switch (index) {
      case 0: return 0;
      case 1: return 62;  // 42 (Tất cả) + 20 (SizedBox)
      case 2: return 184; // 62 + 102 (Chờ thanh toán) + 20
      case 3: return 304; // 184 + 100 (Đã hoàn thành) + 20
      default: return 0;
    }
  }

  double _getTabUnderlineWidth(int index) {
    switch (index) {
      case 0: return 42;
      case 1: return 102;
      case 2: return 100;
      case 3: return 48;
      default: return 0;
    }
  }

  Widget _buildTabButton(String title, int index, int activeTabIndex) {
    final isSelected = index == activeTabIndex;
    return TapEffect(
      onTap: () => interactor.onTabChanged(index),
      child: Text(
        title,
        style: TMLabsTextStyle.bodyBold.copyWith(
          color: isSelected ? Colors.black : TMLabsColor.grey.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildOrderList(CourseOrderCatalogState state) {
    if (state.orders.isEmpty) {
      return getEmptyItemView(caption: "Không có đơn hàng nào");
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: state.orders.length,
      itemBuilder: (context, index) {
        final order = state.orders[index];
        return CourseOrderItemWidget(
          order: order,
          onTap: () => interactor.onOrderDetail(order),
          onPay: () => interactor.onPayOrder(order),
          onReview: () => interactor.onReviewOrder(order),
          onLearn: () => interactor.onStartLearning(order),
          onExpired: () => interactor.onOrderExpired(order),
        );
      },
    );
  }
}
