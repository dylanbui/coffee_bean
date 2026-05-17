import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/custom_app_bar.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/core/utils/locator.dart';
import 'package:coffee_bean/core/utils/logger.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/model/cart_item.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/scenes/rib_samples/product_list/interactor/product_list_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/product_list/interactor/product_list_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:coffee_bean/shared/widget/empty_view.dart';
import 'package:coffee_bean/shared/widget/error_view.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ProductListPage extends CubitStateFulWidget<ProductListInteractor, ProductListState> {
  ProductListPage({super.key, required super.interactor});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends CubitState<ProductListPage, ProductListInteractor, ProductListState> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      interactor.loadMoreData();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  dynamic getAppBar(BuildContext context) {
    return CustomAppBar(
      "Sản phẩm", 
      hideBackButton: true, 
      appBarActions: [_CartBadge(onTap: () => interactor.router?.gotoProductCart())]
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<ProductListInteractor, ProductListState>(
      listener: (context, state) {
        if (state is ProductListGetDataError) {
          eLog("Error: ${state.error.message}");
        }
      },
      builder: (context, state) {
        if (state is ProductListInitial || state is ProductListInProgress) {
          return const Center(child: LoadingView(width: 150, height: 150));
        }

        if (state is ProductListGetDataSuccess || state is ProductListInLoadMoreProgress) {
          List<Product> items = [];
          bool hasReachedMax = false;

          if (state is ProductListGetDataSuccess) {
            items = state.items;
            hasReachedMax = state.hasReachedMax;
          } else if (state is ProductListInLoadMoreProgress) {
            items = state.items;
            hasReachedMax = false;
          }

          if (items.isEmpty) {
            return const EmptyView(message: "Không tìm thấy sản phẩm nào");
          }

          return _ProductListView(
            products: items, 
            hasReachedMax: hasReachedMax, 
            scrollController: _scrollController, 
            onRefresh: interactor.onRefresh
          );
        }

        if (state is ProductListGetDataError) {
          return ErrorView(message: state.error.message, onRetry: () => interactor.loadData());
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _CartBadge extends StatelessWidget {
  final VoidCallback? onTap;
  const _CartBadge({this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartItem>>(
      stream: locator<CartService>().cartStream,
      builder: (context, snapshot) {
        final int count = snapshot.data?.length ?? 0;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: onTap,
            ),
            if (count > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$count',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProductListView extends StatelessWidget {
  final List<Product> products;
  final bool hasReachedMax;
  final ScrollController scrollController;
  final RefreshCallback onRefresh;

  const _ProductListView({required this.products, required this.hasReachedMax, required this.scrollController, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: hasReachedMax ? products.length : products.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return const _LoadMoreIndicator();
          }
          return _ProductCard(product: products[index]);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final interactor = context.read<ProductListInteractor>();

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        interactor.router?.gotoProductDetail(product.id);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImage(product: product),
              const SizedBox(width: 12),
              _ProductInfo(product: product),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;

  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedImageWidget(imageUrl: product.images?.firstOrNull, width: 100, height: 100, borderRadius: 8),
        Positioned(top: 4, right: 4, child: _LikeButton(product: product)),
      ],
    );
  }
}

class _LikeButton extends StatelessWidget {
  final Product product;

  const _LikeButton({required this.product});

  @override
  Widget build(BuildContext context) {
    final interactor = context.read<ProductListInteractor>();
    final isLiked = interactor.isProductLiked(product.id);

    return GestureDetector(
      onTap: () => interactor.toggleLike(product),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
        child: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 20),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    final interactor = context.read<ProductListInteractor>();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title ?? '',
            style: DefaultStyle.textLarge.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(product.description ?? '', style: DefaultStyle.textSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${product.price?.toStringAsFixed(0)}đ",
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  interactor.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã thêm ${product.title} vào giỏ hàng"), duration: const Duration(seconds: 1)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(60, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Thêm", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
