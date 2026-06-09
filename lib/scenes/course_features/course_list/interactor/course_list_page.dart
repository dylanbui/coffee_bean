// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_page.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_event_state.dart';
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_interactor.dart';
import 'package:coffee_bean/scenes/course_features/course_list/interactor/widget/course_category_picker.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_modal_helper.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CourseListPage extends AppCubitStateFulWidget<CourseListInteractor, CourseListState> {
  CourseListPage({super.key, required super.interactor});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends AppCubitState<CourseListPage, CourseListInteractor, CourseListState> {
  @override
  String? getTitle() => "TẤT CẢ KHÓA HỌC";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CourseListInteractor, CourseListState>(
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

  Widget _buildFilterHeader(BuildContext context, CourseListState state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Category Picker Button
          Expanded(
            flex: 4,
            child: AppButton(
              text: state.selectedCategory?.name ?? "Tất cả các loại",
              onPressed: () => _showCategoryModal(context, state),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              rightIcon: const Icon(Icons.arrow_drop_down, color: TMLabsColor.primary, size: 20),
              style: TMLabsButtonStyle.white.copyWith(
                backgroundColor: TMLabsColor.bgLight,
                borderRadius: 18,
                textStyle: TMLabsTextStyle.bodyBold.copyWith(fontSize: 13),
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
                hintText: "Tìm kiếm khóa học",
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

  Widget _buildContent(BuildContext context, CourseListState state) {
    if (state.isLoading && state.courses.isEmpty) {
      return FadeSwitcher(stateKey: "getLoadingView", child: getLoadingView());
    }

    if (state.courses.isEmpty) {
      return FadeSwitcher(stateKey: "getEmptyItemView", child: getEmptyItemView());
    }

    final content = ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.courses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildCourseItem(context, state.courses[index]);
      },
    );
    
    return FadeSwitcher(stateKey: "content_${state.courses.length}", child: content);
  }

  Widget _buildCourseItem(BuildContext context, TblCourse item) {
    return TapEffect(
      onTap: () {
        // Navigate to details or show info
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Course Image
            DbCachedImageWidget(
              imageUrl: item.mainImage,
              width: 96,
              height: 96,
              borderRadius: 10,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            // Course Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TMLabsTextStyle.title.copyWith(fontSize: 15, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description ?? "",
                    style: TMLabsTextStyle.body.copyWith(
                      fontSize: 13,
                      color: TMLabsColor.accent.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    NumberToVietnamese.formatNumber(item.price, "vnd") ?? "0 vnd",
                    style: TMLabsTextStyle.title.copyWith(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryModal(BuildContext context, CourseListState state) {
    FlashModalHelper.showSmartModal<TblCategory?>(
      context: context,
      title: "Tất cả các loại", // Design has title in modal
      position: FlashModalPosition.top,
      childBuilder: (ctx, controller) {
        return CourseCategoryPicker(
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
