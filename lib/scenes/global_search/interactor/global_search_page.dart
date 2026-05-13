/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/global_search/interactor/global_search_event_state.dart';
import 'package:coffee_bean/scenes/global_search/interactor/global_search_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/custom_search_app_bar.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/base_cubit_statefull_widget.dart';

//ignore: must_be_immutable
class GlobalSearchPage extends BaseCubitStateFulWidget with ViewControllable {
  GlobalSearchPage({super.key});

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends BaseCubitState<GlobalSearchPage, GlobalSearchInteractor, GlobalSearchState> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) {
    return CustomSearchAppBar(
      controller: _searchController,
      onChanged: (value) {
        interactor.onSearchChanged(value);
        setState(() {}); // Update to show/hide clear icon
      },
      onClear: () {
        setState(() {
          _searchController.clear();
        });
        interactor.clearSearch();
      },
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<GlobalSearchInteractor, GlobalSearchState>(
        builder: (context, state) {
          // Initialize or update TabController when categories are available
          if (_tabController == null || _tabController!.length != state.categories.length) {
            _tabController?.dispose();
            _tabController = TabController(length: state.categories.length, vsync: this);
          }

          return Column(
            children: [
              _buildTabBar(state.categories),
              Expanded(
                child: _buildContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar(List<String> categories) {
    if (_tabController == null) return const SizedBox.shrink();
    
    return Container(
      color: AppColor.white,
      width: double.infinity,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.only(left: 0),
        labelColor: AppColor.basicAccent,
        unselectedLabelColor: AppColor.basicSecondaryText,
        indicatorColor: AppColor.basicAccent,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: BasicStyle.tabLabel,
        unselectedLabelStyle: BasicStyle.tabUnselectedLabel,
        tabs: categories.map((name) => Tab(text: name)).toList(),
      ),
    );
  }

  Widget _buildContent(GlobalSearchState state) {
    if (state is GlobalSearchInProgress) {
      return const Center(child: LoadingView(width: 150, height: 150));
    }
    if (state is GlobalSearchEmpty) {
      return _buildEmptyState();
    }
    if (state is GlobalSearchSuccess) {
      return _buildResultsList(state.results);
    }
    return Container(color: AppColor.basicBackground);
  }

  Widget _buildResultsList(List<dynamic> results) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildProductItem(results[index]);
      },
    );
  }

  Widget _buildProductItem(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColor.basicSearchBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image, color: AppColor.basicSecondaryText),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: BasicStyle.primaryText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item['price']}",
                      style: BasicStyle.priceText,
                    ),
                    _buildAddButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.basicAccent,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 16),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No relevant content found", style: BasicStyle.secondaryText),
        ],
      ),
    );
  }
}
