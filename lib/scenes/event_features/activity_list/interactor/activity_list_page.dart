// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: activity_list_page.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/event_features/activity_list/interactor/activity_list_event_state.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/interactor/activity_list_interactor.dart';
import 'package:coffee_bean/scenes/event_features/activity_list/interactor/widget/activity_category_picker.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_modal_helper.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ActivityListPage extends AppCubitStateFulWidget<ActivityListInteractor, ActivityListState> {
  ActivityListPage({super.key, required super.interactor});

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends AppCubitState<ActivityListPage, ActivityListInteractor, ActivityListState> {
  @override
  String? getTitle() => "TRUNG TÂM HOẠT ĐỘNG";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ActivityListInteractor, ActivityListState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildFilterHeader(context, state),
            Expanded(child: _buildContent(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildFilterHeader(BuildContext context, ActivityListState state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Category Picker Button
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () => _showCategoryModal(context, state),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: TMLabsColor.bgLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.selectedCategory?.name ?? "Tất cả các loại",
                        style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: TMLabsColor.primary, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Search Bar
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 36,
              child: AppSearchBar(
                hintText: "Tìm kiếm tên hoạt động",
                onSearch: interactor.onSearchChanged,
                backgroundColor: TMLabsColor.bgLight,
                borderRadius: 18,
                leftIcon: AppAssets.icons.icSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ActivityListState state) {
    if (state.isLoading && state.activities.isEmpty) {
      return FadeSwitcher(stateKey: "getLoadingView", child: getLoadingView());
    }

    if (state.activities.isEmpty) {
      return FadeSwitcher(stateKey: "getEmptyItemView", child: getEmptyItemView());
    }

    final content = ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildActivityItem(context, state.activities[index]);
      },
    );

    return FadeSwitcher(stateKey: "content_${state.activities.length}", child: content);
  }

  Widget _buildActivityItem(BuildContext context, TblActivity item) {
    return TapEffect(
      onTap: () {
        // Navigate to details
      },
      child: Container(
        height: 154,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Larger radius from image
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Activity Image
            Expanded(
              child: DbCachedImageWidget(
                imageUrl: item.mainImage,
                width: double.infinity,
                borderRadius: 24, // Matches container but we want top rounded
                // Actually image is on top, maybe only top rounded or ClipRRect
                fit: BoxFit.cover,
              ),
            ),
            // Activity Name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Text(
                item.name.toUpperCase(),
                style: TMLabsTextStyle.bodyBold.copyWith(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryModal(BuildContext context, ActivityListState state) {
    FlashModalHelper.showSmartModal<TblCategory?>(
      context: context,
      title: "TẤT CẢ CÁC LOẠI",
      position: FlashModalPosition.top,
      childBuilder: (ctx, controller) {
        return ActivityCategoryPicker(
          categories: state.categories,
          selectedCategory: state.selectedCategory,
          controller: controller,
        );
      },
    ).then((selected) {
      if (selected != null || (selected == null && state.selectedCategory != null)) {
        interactor.onCategorySelected(selected);
      }
    });
  }
}
