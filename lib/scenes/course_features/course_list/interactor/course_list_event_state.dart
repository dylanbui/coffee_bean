// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_event_state.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/db_core.dart';

class CourseListState extends Equatable {
  final List<TblCategory> categories;
  final List<TblCourse> courses;
  final TblCategory? selectedCategory;
  final String searchQuery;
  final bool isLoading;

  const CourseListState({
    this.categories = const [],
    this.courses = const [],
    this.selectedCategory,
    this.searchQuery = "",
    this.isLoading = false,
  });

  CourseListState copyWith({
    List<TblCategory>? categories,
    List<TblCourse>? courses,
    TblCategory? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    bool clearSelectedCategory = false,
  }) {
    return CourseListState(
      categories: categories ?? this.categories,
      courses: courses ?? this.courses,
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [categories, courses, selectedCategory, searchQuery, isLoading];
}

class CourseListInitial extends CourseListState {
  const CourseListInitial() : super();
}

class CourseListLoading extends CourseListState {
  const CourseListLoading({
    super.courses,
    super.categories,
    super.selectedCategory,
    super.searchQuery,
  }) : super(isLoading: true);
}