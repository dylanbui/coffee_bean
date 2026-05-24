/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/state_management/lib_bloc/constants.dart';

// ----------- EVENT ---------------
abstract class GlobalSearchEvent extends BaseBlocEvent {}

// ----------- STATE ---------------
abstract class GlobalSearchState extends BaseBlocState {
  final String query;
  final List<dynamic> results;
  final List<String> categories;

  GlobalSearchState({
    this.query = '', 
    this.results = const [],
    this.categories = const ["Products", "Venues", "Courses", "Activities", "Posts", "Users"],
  });
}

class GlobalSearchInitial extends GlobalSearchState {
  GlobalSearchInitial({super.categories});
}

class GlobalSearchInProgress extends GlobalSearchState {
  GlobalSearchInProgress({super.query, super.categories});
}

class GlobalSearchSuccess extends GlobalSearchState {
  GlobalSearchSuccess({required super.query, required super.results, super.categories});
}

class GlobalSearchEmpty extends GlobalSearchState {
  GlobalSearchEmpty({required super.query, super.categories});
}

class GlobalSearchError extends GlobalSearchState {
  final String message;

  GlobalSearchError({this.message = "", super.query, super.categories});
}
