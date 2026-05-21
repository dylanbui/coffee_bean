import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_category_list.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_footer.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_header.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/widget/shopping_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ShoppingPage extends CubitStateFulWidget<ShoppingInteractor, ShoppingState> {
  ShoppingPage({super.key, required super.interactor});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends CubitState<ShoppingPage, ShoppingInteractor, ShoppingState> {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();
  final double _itemHeight = 110.0;
  final double _headerHeight = 40.0;
  final double _spacing = 12.0;

  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _productScrollController.addListener(_onProductScroll);
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    _productScrollController.dispose();
    super.dispose();
  }

  void _onProductScroll() {
    if (_isAutoScrolling) return;

    final state = interactor.state;
    if (state.isSearching) return;

    double offset = _productScrollController.offset;
    double currentTotalHeight = 0;
    int newIndex = 0;

    for (int i = 0; i < state.categories.length; i++) {
      final catId = state.categories[i].id!;
      final productsCount = state.productsByCategory[catId]?.length ?? 0;
      double sectionHeight = _headerHeight + (productsCount * (_itemHeight + _spacing));
      
      if (offset >= currentTotalHeight && offset < currentTotalHeight + sectionHeight) {
        newIndex = i;
        break;
      }
      currentTotalHeight += sectionHeight;
    }

    if (newIndex != state.selectedCategoryIndex) {
      interactor.selectCategory(newIndex);
      _categoryScrollController.animateTo(
        newIndex * 120.0, // Updated: height 110 + margin 10
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToCategory(int categoryIndex) {
    _isAutoScrolling = true;
    interactor.selectCategory(categoryIndex);

    final state = interactor.state;
    double targetOffset = 0;
    for (int i = 0; i < categoryIndex; i++) {
      final catId = state.categories[i].id!;
      final productsCount = state.productsByCategory[catId]?.length ?? 0;
      targetOffset += _headerHeight + (productsCount * (_itemHeight + _spacing));
    }

    _productScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ).then((_) => _isAutoScrolling = false);
  }

  @override
  dynamic getAppBar(BuildContext context) {
    return null; // Custom header in body
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ShoppingInteractor, ShoppingState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                ShoppingHeader(interactor: interactor, state: state),
                const SizedBox(height: 20),
                Expanded(
                  child: state.isSearching ? _buildSearchResults(state) : _buildMainContent(state),
                ),
              ],
            ),
            ShoppingFooter(interactor: interactor),
          ],
        );
      },
    );
  }

  Widget _buildMainContent(ShoppingState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Categories
        ShoppingCategoryList(
          state: state,
          controller: _categoryScrollController,
          onCategoryTap: _scrollToCategory,
        ),

        // Right: Products
        Expanded(
          child: ListView.builder(
            controller: _productScrollController,
            padding: const EdgeInsets.only(left: 8, right: 8),
            itemCount: state.categories.length + 1, // +1 for bottom spacing item
            itemBuilder: (context, index) {
              if (index == state.categories.length) {
                return const SizedBox(height: 100); // Spacer for footer
              }

              final category = state.categories[index];
              final products = state.productsByCategory[category.id] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: _headerHeight,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      category.name?.toUpperCase() ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  ...products.map((p) => Padding(
                    padding: EdgeInsets.only(bottom: _spacing),
                    child: ShoppingProductItem(product: p, interactor: interactor, height: _itemHeight),
                  )),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(ShoppingState state) {
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
