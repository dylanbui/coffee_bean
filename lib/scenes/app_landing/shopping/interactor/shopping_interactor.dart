import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/model/category.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_router.dart';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:flutter/cupertino.dart';

class ShoppingInteractor extends CubitInteractor<ShoppingRoutable, ShoppingState> {
  final CartService _cartService = locator<CartService>();

  ShoppingInteractor(ShoppingRoutable router) : super(ShoppingState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();
  }

  Future<void> _loadData() async {
    emit(state.copyWith(isLoading: true));

    // Mocking data for now as per requirements
    final categories = [
      Category(id: 1, name: 'Coffee', image: AppAssets.icons.icCatCoffee),
      Category(id: 2, name: 'Milk tea', image: AppAssets.icons.icCatMilkTea),
      Category(id: 3, name: 'Cake', image: AppAssets.icons.icCatCake),
      Category(id: 4, name: 'Snack', image: AppAssets.icons.icCatSnack),
      Category(id: 5, name: 'Tea', image: AppAssets.icons.icCatTea),
    ];

    final products = [
      Product(id: 1, title: '1 BẠC XỈU ĐÁ / NÓNG', price: 44000, category: categories[0], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 2, title: '2 CÀ PHÊ SỮA ĐÁ', price: 35000, category: categories[0], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 3, title: '3 BẠC XỈU ĐÁ / NÓNG', price: 44000, category: categories[0], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 4, title: '4 CÀ PHÊ SỮA ĐÁ', price: 35000, category: categories[0], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 5, title: '5 BẠC XỈU ĐÁ / NÓNG', price: 44000, category: categories[0], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 6, title: '6 CÀ PHÊ SỮA ĐÁ', price: 35000, category: categories[0], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),

      Product(id: 7, title: '7 TRÀ SỮA TRÂN CHÂU', price: 55000, category: categories[1], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 8, title: '8 TRÀ SỮA KHOAI MÔN', price: 55000, category: categories[1], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 9, title: '9 TRÀ SỮA TRÂN CHÂU', price: 55000, category: categories[1], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 10, title: '10 TRÀ SỮA KHOAI MÔN', price: 55000, category: categories[1], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 11, title: '11 TRÀ SỮA TRÂN CHÂU', price: 55000, category: categories[1], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 12, title: '12 TRÀ SỮA KHOAI MÔN', price: 55000, category: categories[1], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),

      Product(id: 13, title: '13 TIRAMISU', price: 45000, category: categories[2], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 14, title: '14 TIRAMISU', price: 45000, category: categories[2], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 15, title: '15 TIRAMISU', price: 45000, category: categories[2], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 16, title: '16 TIRAMISU', price: 45000, category: categories[2], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),

      Product(id: 17, title: '17 BANH QUY', price: 25000, category: categories[3], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 18, title: '18 BANH QUY', price: 25000, category: categories[3], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 19, title: '19 BANH QUY', price: 25000, category: categories[3], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 20, title: '20 BANH QUY', price: 25000, category: categories[3], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 21, title: '21 BANH QUY', price: 25000, category: categories[3], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
      Product(id: 22, title: '22 BANH QUY', price: 25000, category: categories[3], images: ['https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=400&auto=format&fit=crop']),
    ];

    final productsByCategory = <int, List<Product>>{};
    for (var category in categories) {
      productsByCategory[category.id!] = products.where((p) => p.category?.id == category.id).toList();
    }

    emit(state.copyWith(
      categories: categories,
      productsByCategory: productsByCategory,
      allProducts: products,
      isLoading: false,
    ));
  }

  void selectCategory(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(isSearching: false, searchQuery: '', filteredProducts: []));
    } else {
      final filtered = state.allProducts
          .where((p) => p.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
      emit(state.copyWith(isSearching: true, searchQuery: query, filteredProducts: filtered));
    }
  }

  void addToCart(Product product) {
    _cartService.addToCart(product);
  }

  void routeToProductDetail(Product product) {
    // router.routeToProductDetail(product);
    debugPrint(product.title);
  }

  CartService get cartService => _cartService;
}
