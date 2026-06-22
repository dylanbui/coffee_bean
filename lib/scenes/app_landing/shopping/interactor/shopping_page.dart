import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/data/model/category.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_category_list.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_footer.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_header.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_product_item.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';

//ignore: must_be_immutable
class ShoppingPage extends AppCubitStateFulWidget<ShoppingInteractor, ShoppingState> {
  ShoppingPage({super.key, required super.interactor});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends AppCubitState<ShoppingPage, ShoppingInteractor, ShoppingState> {
  final ItemScrollController _productScrollController = ItemScrollController();
  final ItemPositionsListener _productPositionsListener = ItemPositionsListener.create();

  final ItemScrollController _categoryScrollController = ItemScrollController();

  final double _itemHeight = 110.0;
  final double _headerHeight = 40.0;
  final double _spacing = 12.0;

  bool _isAutoScrolling = false;
  List<dynamic> _flattenedItems = [];
  Map<int, int> _categoryToIndexMap = {}; // CategoryIndex -> FlattenedIndex

  @override
  void initState() {
    super.initState();
    _productPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
  }

  @override
  void dispose() {
    _productPositionsListener.itemPositions.removeListener(_onItemPositionsChanged);
    super.dispose();
  }

  void _onItemPositionsChanged() {
    if (_isAutoScrolling || interactor.state.isSearching) return;

    final positions = _productPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Find the first visible item that is fully or mostly at the top
    final firstVisibleIndex = positions
        .where((pos) => pos.itemTrailingEdge > 0)
        .reduce((min, pos) => pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min)
        .index;

    // Determine which category this index belongs to
    int newCategoryIndex = -1;
    for (int i = 0; i < interactor.state.categories.length; i++) {
      int headerIndex = _categoryToIndexMap[i] ?? -1;
      int nextHeaderIndex = _categoryToIndexMap[i + 1] ?? _flattenedItems.length;

      if (firstVisibleIndex >= headerIndex && firstVisibleIndex < nextHeaderIndex) {
        newCategoryIndex = i;
        break;
      }
    }

    if (newCategoryIndex != -1 && newCategoryIndex != interactor.state.selectedCategoryIndex) {
      interactor.selectCategory(newCategoryIndex);
      _categoryScrollController.scrollTo(
        index: newCategoryIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToCategory(int categoryIndex) {
    final targetIndex = _categoryToIndexMap[categoryIndex];
    if (targetIndex == null) return;

    _isAutoScrolling = true;
    interactor.selectCategory(categoryIndex);

    _productScrollController.scrollTo(
      index: targetIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ).then((_) => _isAutoScrolling = false);
  }

  void _prepareFlattenedItems(ShoppingState state) {
    _flattenedItems = [];
    _categoryToIndexMap = {};

    for (int i = 0; i < state.categories.length; i++) {
      final category = state.categories[i];
      _categoryToIndexMap[i] = _flattenedItems.length;
      _flattenedItems.add(category); // Add Header

      final products = state.productsByCategory[category.id] ?? [];
      _flattenedItems.addAll(products); // Add Products
    }
  }

  @override
  String? getTitle() => null;

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ShoppingHeader(interactor: interactor),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ShoppingInteractor, ShoppingState>(
                buildWhen: (p, c) =>
                    p.categories != c.categories ||
                    p.productsByCategory != c.productsByCategory ||
                    p.isSearching != c.isSearching ||
                    p.filteredProducts != c.filteredProducts ||
                    p.isLoading != c.isLoading,
                builder: (context, state) {
                  if (state.isLoading && state.categories.isEmpty) {
                    return getLoadingView();
                  }

                  if (state.isSearching) {
                    return _buildSearchResults(state);
                  }
                  _prepareFlattenedItems(state);
                  return _buildMainContent(state);
                },
              ),
            ),
          ],
        ),
        ShoppingFooter(interactor: interactor),
      ],
    );
  }

  Widget _buildMainContent(ShoppingState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Categories
        BlocBuilder<ShoppingInteractor, ShoppingState>(
          buildWhen: (p, c) => p.selectedCategoryIndex != c.selectedCategoryIndex || p.categories != c.categories,
          builder: (context, state) {
            return ShoppingCategoryList(
              categories: state.categories,
              selectedIndex: state.selectedCategoryIndex,
              itemScrollController: _categoryScrollController,
              onCategoryTap: _scrollToCategory,
            );
          },
        ),

        // Right: Products
        Expanded(
          child: ScrollablePositionedList.builder(
            itemScrollController: _productScrollController,
            itemPositionsListener: _productPositionsListener,
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 100),
            itemCount: _flattenedItems.length,
            itemBuilder: (context, index) {
              final item = _flattenedItems[index];

              if (item is Category) {
                return Container(
                  height: _headerHeight,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.name.toUpperCase(),
                    style: TMLabsTextStyle.bodyBold.copyWith(color: TMLabsColor.grey),
                  ),
                );
              }

              if (item is Product) {
                return Padding(
                  padding: EdgeInsets.only(bottom: _spacing),
                  child: ShoppingProductItem(product: item, interactor: interactor, height: _itemHeight),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(ShoppingState state) {
    if (state.filteredProducts.isEmpty && state.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "Không tìm thấy sản phẩm nào cho \"${state.searchQuery}\"",
              style: TMLabsTextStyle.title.copyWith(color: TMLabsColor.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.filteredProducts.length + 1,
      itemBuilder: (context, index) {
        if (index == state.filteredProducts.length) {
          return const SizedBox(height: 100);
        }
        return Padding(
          padding: EdgeInsets.only(bottom: _spacing),
          child: ShoppingProductItem(product: state.filteredProducts[index], interactor: interactor, height: _itemHeight),
        );
      },
    );
  }
}
