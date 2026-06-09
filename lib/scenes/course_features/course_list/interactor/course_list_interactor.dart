// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_interactor.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/data/repository/course_repository.dart';
import 'package:coffee_bean/scenes/course_features/course_list/course_list_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_event_state.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';

class CourseListInteractor extends CubitInteractor<CourseListRoutable, CourseListState> {
  final CourseRepository _courseRepository = locator<CourseRepository>();

  CourseListInteractor(CourseListRoutable router)
      : super(CourseListState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  Future<void> _initData() async {
    emit(state.copyWith(isLoading: true));
    
    final cats = await _courseRepository.getCategories();
    final items = await _courseRepository.getCourses();
    
    emit(state.copyWith(
      categories: cats,
      courses: items,
      isLoading: false,
    ));
  }

  void onCategorySelected(TblCategory? category) async {
    if (state.selectedCategory?.serverId == category?.serverId && category != null) return;

    emit(state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
      isLoading: true,
    ));

    final items = await _courseRepository.getCourses(
      query: state.searchQuery,
      catId: category?.serverId,
    );

    emit(state.copyWith(courses: items, isLoading: false));
  }

  void onSearchChanged(String query) async {
    emit(state.copyWith(searchQuery: query, isLoading: true));

    final items = await _courseRepository.getCourses(
      query: query,
      catId: state.selectedCategory?.serverId,
    );

    emit(state.copyWith(courses: items, isLoading: false));
  }
}
