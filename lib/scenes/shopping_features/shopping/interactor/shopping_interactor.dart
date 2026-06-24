import 'package:coffee_bean/scenes/store_list/store_list_constant.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:coffee_bean/data/repository/product_repository.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/scenes/shopping_features/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/shopping/shopping_router.dart';
import 'package:coffee_bean/utils/utils.dart';

class ShoppingInteractor extends CubitInteractor<ShoppingRoutable, ShoppingState> {
  final CartService _cartService = locator<CartService>();
  final ProductRepository _productRepo = locator<ProductRepository>();

  ShoppingInteractor(ShoppingRoutable router) : super(ShoppingState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();

    collect(locator<DbEventBus>().on<StoreChangedEvent>().listen((event) {
      _loadData(refresh: true);
    }));
  }

  Future<void> _loadData({bool refresh = false}) async {
    emit(state.copyWith(isLoading: true));

    final storeId = StoreManager().selectedStore?.id;

    // [MỚI]: Sử dụng hàm tổng hợp getShoppingData tích hợp sẵn Cache & Grouping logic
    final result = await _productRepo.getShoppingData(
      storeId,
      cacheConfig: DbCacheConfig(
        key: 'shopping_data_$storeId',
        group: 'shopping',
        forceRefresh: refresh,
        duration: const Duration(hours: 1), // Cache 1 tiếng cho Shopping
      ),
    );

    if (result case DbSuccess(data: final data)) {
      emit(state.copyWith(
        categories: data.categories,
        allProducts: data.allProducts,
        productsByCategory: data.productsByCategory,
        isLoading: false,
        isSearching: false,
        searchQuery: '',
        filteredProducts: [],
        selectedCategoryIndex: 0,
      ));
    } else {
      // Xử lý lỗi (Có thể lấy từ state cũ nếu fetch fail)
      emit(state.copyWith(isLoading: false));
    }
  }

  /* --- CODE CŨ ĐỂ SO SÁNH (OLD IMPLEMENTATION) ---
  Future<void> _loadDataOld({bool refresh = false}) async {
    emit(state.copyWith(isLoading: true));

    final storeId = StoreManager().selectedStore?.id;

    // 1. Fetch Categories từ API
    final resultCat = (await _productRepo.getProductCategoryList(storeId)).toResult();
    List<Category> categories = [];
    if (resultCat case DbSuccess(:final data)) {
      categories = data;
    }

    // 2. Fetch Products (SPU) từ API
    final resultSpu = (await _productRepo.getProductSpuPage(
      storeId: storeId,
      pageSize: 200,
    )).toResult();
    
    List<Product> products = [];
    if (resultSpu case DbSuccess(:final data)) {
      products = data.list;
    }

    // 3. Group Products by Category ID (Logic xử lý thủ công tại Interactor)
    final productsByCategory = <int, List<Product>>{};
    for (var cat in categories) {
      productsByCategory[cat.id] = products.where((p) => p.categoryId == cat.id).toList();
    }

    emit(state.copyWith(
      categories: categories,
      productsByCategory: productsByCategory,
      allProducts: products,
      isLoading: false,
      isSearching: false,
      searchQuery: '',
      filteredProducts: [],
      selectedCategoryIndex: 0,
    ));
  }
  ----------------------------------------------- */

  void selectCategory(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void onSearchChanged(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(isSearching: false, searchQuery: '', filteredProducts: []));
    } else {
      final searchKey = Utils.toNoSign(query).toLowerCase();
      
      final results = state.allProducts.where((p) {
        final nameMatch = p.name.toLowerCase().contains(query.toLowerCase());
        final searchNameMatch = Utils.toNoSign(p.name).toLowerCase().contains(searchKey);
        return nameMatch || searchNameMatch;
      }).toList();
          
      emit(state.copyWith(isSearching: true, searchQuery: query, filteredProducts: results));
    }
  }

  void addToCart(Product product) {
    // Note: Product from API doesn't have defaultSelectedOptions directly in the SPU list model.
    // If it has specs (specType == true), we should probably route to detail instead of direct add.
    if (product.specType) {
      routeToProductDetail(product);
    } else {
      _cartService.addToCart(product);
    }
  }

  void routeToProductDetail(Product product) {
    router?.navigate(ProductDetailRoute(product));
  }

  void checkout() {
    if (_cartService.currentItems.isNotEmpty) {
      router?.navigate(OrderConfirmationRoute());
    }
  }

  void openStoreList() {
    router?.navigate(StoreListRoute());
  }

  CartService get cartService => _cartService;
}
