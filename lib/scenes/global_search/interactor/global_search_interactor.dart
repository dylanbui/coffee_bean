/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/global_search/global_search_router.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_event_state.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';


// Interactor

class GlobalSearchInteractor extends CubitInteractor<GlobalSearchRouter, GlobalSearchState> {

  GlobalSearchInteractor(GlobalSearchRouter router) : super(GlobalSearchInitial(), router: router);

  @override
  void didBecomeActive() {
    super.didBecomeActive();
    // Simulate fetching categories from server
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    // In a real app, this would be an API call
    await Future.delayed(const Duration(milliseconds: 500));
    final categories = ["Products", "Venues", "Courses", "Activities", "Posts", "Users"];
    emit(GlobalSearchInitial(categories: categories));
  }

  void onSearchChanged(String value) {
    if (value.length >= 5) {
      _performSearch(value);
    } else if (value.isEmpty) {
      emit(GlobalSearchInitial(categories: state.categories));
    }
  }

  Future<void> _performSearch(String query) async {
    emit(GlobalSearchInProgress(query: query, categories: state.categories));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock English data
    final mockResults = [
      {'title': 'Premium Arabica Coffee Beans', 'price': '19.8', 'image': ''},
      {'title': 'Hand-roasted Dark Blend (Limited Edition) with rich aroma and smooth finish...', 'price': '28', 'image': ''},
      {'title': 'Ethiopian Single Origin Yirgacheffe ABC', 'price': '12.9', 'image': ''},
    ];

    if (mockResults.isEmpty) {
      emit(GlobalSearchEmpty(query: query, categories: state.categories));
    } else {
      emit(GlobalSearchSuccess(query: query, results: mockResults, categories: state.categories));
    }
  }

  void clearSearch() {
    emit(GlobalSearchInitial(categories: state.categories));
  }
}
