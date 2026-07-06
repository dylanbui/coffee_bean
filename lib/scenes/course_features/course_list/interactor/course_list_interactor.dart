// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_interactor.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: Interactor for Course List module, implementing Smart Cache.
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

  /// Khởi tạo dữ liệu sử dụng Smart Cache cho Categories
  void _initData() {
    // 1. Vừa vào trang, mặc nhiên hiển thị loading
    emit(state.copyWith(isLoading: true));
    // 2. Category load từ cache hay server ta không quan tâm, cứ có data là update Tab
    observe(_courseRepository.watchCourseCategories(), (result) {
      if (result is (List<DictionaryData>, DataOrigin)) {
        final (data, origin) = result;
        
        final List<DictionaryData> categories = [
          DictionaryData(id: 0, label: "Tất cả khóa học", value: "", dictType: ""),
          ...data
        ];

        emit(state.copyWith(
          categories: categories,
          selectedCategory: state.selectedCategory ?? categories.first,
        ));

        // Tự động gọi fetch khóa học. 
        // Chỉ hiện Loading Spinner nếu đây là lần đầu (chưa có danh sách khóa học)
        _fetchCourses(showLoading: state.courses.isEmpty);
      } 
      // Nếu lỗi Category, vẫn phải tắt loading để user không bị kẹt ở Spinner
      else if (result is DbFailure) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }

  /// Hàm fetch danh sách khóa học tập trung
  /// [showLoading]: Nếu false, dữ liệu sẽ được cập nhật ngầm (Silent Sync)
  Future<void> _fetchCourses({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(isLoading: true));

    final courseResult = await _courseRepository.getCoursePage(
      keyword: state.searchQuery,
      courseType: (state.selectedCategory?.id == 0) ? null : state.selectedCategory?.id,
    );

    // 3. Khi _fetchCourses xong thì mới thực sự ẩn loading
    if (courseResult case DbSuccess(data: final pageData)) {
      emit(state.copyWith(courses: pageData.list, isLoading: false));
    } else {
      emit(state.copyWith(courses: [], isLoading: false));
    }
  }

  /// Xử lý khi người dùng chọn một Category
  void onCategorySelected(DictionaryData? category) {
    if (state.selectedCategory?.id == category?.id && category != null) return;

    emit(state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
    ));
    
    // Gọi fetch lại dữ liệu
    _fetchCourses();
  }

  /// Xử lý khi người dùng thay đổi nội dung tìm kiếm
  void onSearchChanged(String query) {
    emit(state.copyWith(searchQuery: query));
    
    // Gọi fetch lại dữ liệu
    _fetchCourses();
  }
}
