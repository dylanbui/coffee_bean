/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/db_core.dart';

// ----------- EVENT ---------------
abstract class GlobalSearchEvent extends BaseBlocEvent {}

// ----------- STATE ---------------
class GlobalSearchState extends BaseBlocState {
  final String query;
  final List<dynamic> results;
  final List<String> categories;
  final bool isLoading;
  final DbFailure? failure;

  GlobalSearchState({
    this.query = '', 
    this.results = const [],
    this.categories = const ["Products", "Venues", "Courses", "Activities", "Posts", "Users"],
    this.isLoading = false,
    this.failure,
  });

  @override
  List<Object?> get props => [query, results, categories, isLoading, failure];

  GlobalSearchState copyWith({
    String? query,
    List<dynamic>? results,
    List<String>? categories,
    bool? isLoading,
    DbFailure? failure,
  }) {
    return GlobalSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      failure: failure, // Reset to null if not provided
    );
  }

  // Helper getters for UI
  bool get isInitial => query.isEmpty && !isLoading && failure == null;
  bool get isEmpty => query.isNotEmpty && !isLoading && failure == null && results.isEmpty;
  bool get isSuccess => results.isNotEmpty && !isLoading && failure == null;
}
