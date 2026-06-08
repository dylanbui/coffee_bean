import 'package:coffee_bean/scenes/point_features/my_point_list/interactor/my_point_list_event_state.dart';
import 'package:coffee_bean/scenes/point_features/my_point_list/interactor/my_point_list_interactor.dart';
import 'package:coffee_bean/scenes/point_features/my_point_list/widget/point_store_card.dart';
import 'package:coffee_bean/scenes/point_features/my_point_list/widget/point_store_header.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_ui.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class MyPointListPage extends AppCubitStateFulWidget<MyPointListInteractor, MyPointListState> {
  MyPointListPage({super.key, required super.interactor});

  @override
  State<MyPointListPage> createState() => _MyPointListPageState();
}

class _MyPointListPageState extends AppCubitState<MyPointListPage, MyPointListInteractor, MyPointListState> {
  @override
  String? getTitle() => "TÍCH ĐIỂM";

  @override
  bool get tapToUnfocus => true;

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<MyPointListInteractor, MyPointListState>(
        bloc: interactor,
        buildWhen: (prev, curr) => prev.isSearchMode != curr.isSearchMode,
        builder: (context, state) {
          if (state.isSearchMode) {
            return CoffeeAppBar(
              hideBackButton: false,
              onBackTap: () => interactor.toggleSearchMode(false),
              titleWidget: SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    AppSearchBar(
                      hintText: "Tìm kiếm...",
                      backgroundColor: TMLabsColor.bgLight,
                      leftIcon: AppAssets.icons.icSearch,
                      rightIcon: Icons.close,
                      clearIcon: Icons.close,
                      onSearch: (value) {
                        if (value.isEmpty) {
                          // Tạm thời không auto close khi empty để tránh giật lag khi đang gõ
                          // interactor.toggleSearchMode(false);
                          interactor.onSearchChanged("");
                        } else {
                          interactor.onSearchChanged(value);
                        }
                      },
                    ),
                    // Lớp phủ để bắt sự kiện tap vào nút X (vì AppSearchBar chưa hỗ trợ callback riêng cho nút này)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 40,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => interactor.toggleSearchMode(false),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return CoffeeAppBar(title: getTitle());
        },
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return Container(
      width: double.infinity,
      color: TMLabsColor.white,
      child: BlocBuilder<MyPointListInteractor, MyPointListState>(
        bloc: interactor,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: state.isSearchMode ? 0 : 135,
                curve: Curves.easeInOut,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: PointStoreHeader(
                    points: state.userPoints,
                    onDetailTap: interactor.onPointBreakdownTap,
                    onMoreTap: interactor.onEarnPointsTap,
                  ),
                ),
              ),
              
              _buildTitleArea(state),
              _buildCategoryBar(state),
              
              Expanded(
                child: state.isLoading 
                  ? getLoadingView() 
                  : _buildGridContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitleArea(MyPointListState state) {
    if (state.isSearchMode) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Text(
        "Cửa hàng điểm",
        style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryBar(MyPointListState state) {
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
                onPressed: () {
                  // Guard against double tap
                  if (!state.isSearchMode) {
                    interactor.toggleSearchMode(true);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGridContent(MyPointListState state) {
    if (state.items.isEmpty) {
      return AppUi.getEmptyItemWidget();
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
        return PointStoreCard(
          item: state.items[index],
          onTap: interactor.onStorePointTap,
        );
      },
    );
  }
}
