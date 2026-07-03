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
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:db_core/db_core.dart';

class CourseListInteractor extends CubitInteractor<CourseListRoutable, CourseListState> {
  final CourseRepository _courseRepository = locator<CourseRepository>();

  CourseListInteractor(CourseListRoutable router)
      : super(const CourseListState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  Future<void> _initData() async {
    emit(state.copyWith(isLoading: true));
    
    final catResult = await _courseRepository.getCourseCategories();
    final courseResult = await _courseRepository.getCoursePage();
    
    List<DictionaryData> cats = [];
    if (catResult case DbSuccess(data: final data)) {
      cats = data;
    }

    List<CourseInfo> items = [];
    if (courseResult case DbSuccess(data: final data)) {
      items = data.list;
    }
    
    emit(state.copyWith(
      categories: cats,
      courses: items,
      isLoading: false,
    ));
  }

  void onCategorySelected(DictionaryData? category) async {
    if (state.selectedCategory?.id == category?.id && category != null) return;

    emit(state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
      isLoading: true,
    ));

    final courseResult = await _courseRepository.getCoursePage(
      keyword: state.searchQuery,
      courseType: category?.id,
    );

    if (courseResult case DbSuccess(data: final data)) {
      emit(state.copyWith(courses: data.list, isLoading: false));
    } else {
      emit(state.copyWith(courses: [], isLoading: false));
    }
  }

  void onSearchChanged(String query) async {
    emit(state.copyWith(searchQuery: query, isLoading: true));

    final courseResult = await _courseRepository.getCoursePage(
      keyword: query,
      courseType: state.selectedCategory?.id,
    );

    if (courseResult case DbSuccess(data: final data)) {
      emit(state.copyWith(courses: data.list, isLoading: false));
    } else {
      emit(state.copyWith(courses: [], isLoading: false));
    }
  }
}
