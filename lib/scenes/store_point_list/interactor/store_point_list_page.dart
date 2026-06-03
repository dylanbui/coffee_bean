import 'package:coffee_bean/scenes/store_point_list/interactor/store_point_list_event_state.dart';
import 'package:coffee_bean/scenes/store_point_list/interactor/store_point_list_interactor.dart';
import 'package:coffee_bean/scenes/store_point_list/widget/point_store_card.dart';
import 'package:coffee_bean/scenes/store_point_list/widget/point_store_header.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

//ignore: must_be_immutable
class StorePointListPage extends AppCubitStateFulWidget<StorePointListInteractor, StorePointListState> {
  StorePointListPage({super.key, required super.interactor});

  @override
  State<StorePointListPage> createState() => _StorePointListPageState();
}

class _StorePointListPageState extends AppCubitState<StorePointListPage, StorePointListInteractor, StorePointListState> {
  @override
  String? getTitle() => "TÍCH ĐIỂM";

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    if (interactor.state.isSearchMode) {
      return CoffeeAppBar(
        hideBackButton: false,
        onBackTap: () => interactor.toggleSearchMode(false),
        titleWidget: SizedBox(
          height: 40,
          child: AppSearchBar(
            hintText: "Tìm kiếm...",
            backgroundColor: TMLabsColor.bgLight,
            leftIcon: AppAssets.icons.icSearch,
            onSearch: interactor.onSearchChanged,
          ),
        ),
      );
    }
    return super.getAppBar(context);
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: TMLabsColor.bgMain,
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<StorePointListInteractor, StorePointListState>(
      builder: (context, state) {
        return Column(
          children: [
            // Header with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: state.isSearchMode ? 0 : 160,
              curve: Curves.easeInOut,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: PointStoreHeader(
                  points: state.userPoints,
                  onDetailTap: () {},
                  onMoreTap: () {},
                ),
              ),
            ),
            
            // Content area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: TMLabsColor.white,
                  borderRadius: state.isSearchMode 
                      ? BorderRadius.zero 
                      : const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    if (!state.isSearchMode) const SizedBox(height: 16),
                    _buildTopActionArea(state),
                    _buildCategoryBar(state),
                    Expanded(
                      child: state.isLoading 
                        ? const Center(child: LoadingView(width: 150, height: 150)) 
                        : _buildGridContent(state),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopActionArea(StorePointListState state) {
    if (state.isSearchMode) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Cửa hàng điểm",
            style: TMLabsTextStyle.h2,
          ),
          IconButton(
            icon: AppIcon(AppAssets.icons.icSearch, size: 24, color: TMLabsColor.primary),
            onPressed: () => interactor.toggleSearchMode(true),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(StorePointListState state) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final cat = state.categories[index];
          final isSelected = state.selectedCatId == cat.id;
          return GestureDetector(
            onTap: () => interactor.onCategorySelected(cat.id),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? TMLabsColor.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                cat.name,
                style: TMLabsTextStyle.body.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? TMLabsColor.primary : TMLabsColor.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridContent(StorePointListState state) {
    if (state.items.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 176 / 250,
      ),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        return PointStoreCard(item: state.items[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.images.imgNoneItem,
            width: 160,
          ),
          const SizedBox(height: 16),
          const Text(
            "Không tìm thấy nội dung liên quan",
            style: TMLabsTextStyle.body,
          ),
        ],
      ),
    );
  }

}
