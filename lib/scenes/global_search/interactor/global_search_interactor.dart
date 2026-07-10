/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/global_search/global_search_builder.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_event_state.dart';
import 'package:db_core/db_core.dart';


class GlobalSearchInteractor extends CubitInteractor<GlobalSearchRoutable, GlobalSearchState> {

  GlobalSearchInteractor(GlobalSearchRoutable router) : super(GlobalSearchState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    // Simulate fetching categories from server
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    // In a real app, this would be an API call
    await Future.delayed(const Duration(milliseconds: 500));
    final categories = ["Products", "Venues", "Courses", "Activities", "Posts", "Users"];
    emit(state.copyWith(categories: categories));
  }

  void onSearchChanged(String value) {
    if (value.length >= 5) {
      _performSearch(value);
    } else if (value.isEmpty) {
      emit(state.copyWith(query: '', results: []));
    }
  }

  Future<void> _performSearch(String query) async {
    emit(state.copyWith(isLoading: true, query: query, failure: null));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock English data
    final mockResults = [
      {'title': 'Premium Arabica Coffee Beans', 'price': '19.8', 'image': ''},
      {'title': 'Hand-roasted Dark Blend (Limited Edition) with rich aroma and smooth finish...', 'price': '28', 'image': ''},
      {'title': 'Ethiopian Single Origin Yirgacheffe ABC', 'price': '12.9', 'image': ''},
    ];

    if (mockResults.isEmpty) {
      emit(state.copyWith(isLoading: false, results: []));
    } else {
      emit(state.copyWith(isLoading: false, results: mockResults));
    }
  }

  void clearSearch() {
    emit(state.copyWith(query: '', results: [], failure: null));
  }
}
