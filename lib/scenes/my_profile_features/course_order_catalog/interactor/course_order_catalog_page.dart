import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/course_order_catalog_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/course_order_catalog_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/widgets/course_order_item_widget.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_sliding_tab_bar.dart';
import 'package:db_core/utils/common_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSlidingTabBar<int>(
            currentItem: activeTabIndex,
            style: TMLabsTabBarStyle.defaultStyle,
            items: [
              AppTabItem(value: 0, label: "Tất cả"),
              AppTabItem(value: 1, label: "Chờ thanh toán"),
              AppTabItem(value: 2, label: "Đã hoàn thành"),
              AppTabItem(value: 3, label: "Đã hủy"),
            ],
            onTabChanged: (index) => interactor.onTabChanged(index),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
        ],
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
