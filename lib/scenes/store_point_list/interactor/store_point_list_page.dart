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
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return BlocBuilder<StorePointListInteractor, StorePointListState>(
      builder: (context, state) {
        PreferredSizeWidget? effectiveAppBar;
        if (state.isSearchMode) {
          effectiveAppBar = CoffeeAppBar(
            hideBackButton: false,
            onBackTap: () => interactor.toggleSearchMode(false),
            titleWidget: SizedBox(
              height: 40,
              child: AppSearchBar(
                hintText: "Tìm kiếm...",
                backgroundColor: TMLabsColor.bgLight,
                leftIcon: AppAssets.icons.icSearch,
                onSearch: (value) {
                  if (value.isEmpty) {
                    interactor.toggleSearchMode(false);
                  } else {
                    interactor.onSearchChanged(value);
                  }
                },
              ),
            ),
          );
        } else {
          effectiveAppBar = CoffeeAppBar(title: getTitle());
        }

        return Scaffold(
          backgroundColor: TMLabsColor.bgMain,
          appBar: effectiveAppBar,
          body: body,
        );
      },
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<StorePointListInteractor, StorePointListState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          color: TMLabsColor.white, // Cả khối thống nhất màu trắng
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with animation inside the white block
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: state.isSearchMode ? 0 : 135,
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
              
              _buildTitleArea(state),
              _buildCategoryBar(state),
              
              Expanded(
                child: state.isLoading 
                  ? const Center(child: LoadingView(width: 150, height: 150)) 
                  : _buildGridContent(state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleArea(StorePointListState state) {
    if (state.isSearchMode) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Text(
        "Cửa hàng điểm",
        style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryBar(StorePointListState state) {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(top: 0, bottom: 4),
      child: Row(
        children: [
          Expanded(
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
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cat.name,
                            style: TMLabsTextStyle.caption.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? TMLabsColor.primary : TMLabsColor.grey,
                            ),
                          ),
                          if (isSelected)
                            Container(height: 2, color: TMLabsColor.primary,),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!state.isSearchMode)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: AppIcon(AppAssets.icons.icSearch, size: 20, color: TMLabsColor.primary),
                onPressed: () => interactor.toggleSearchMode(true),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGridContent(StorePointListState state) {
    if (state.items.isEmpty) {
      return _buildEmptyState();
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
