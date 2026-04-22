import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/custom_app_bar.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/scenes/product_list/interactor/product_list_event_state.dart';
import 'package:coffee_bean/scenes/product_list/interactor/product_list_interactor.dart';
import 'package:coffee_bean/scenes/product_list/product_list_router.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/utils/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/widget/error_view.dart';
import 'package:coffee_bean/widget/empty_view.dart';
import 'package:coffee_bean/widget/loading_view.dart';

class ProductListPage extends StatefulWidget with ViewControllable {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductListInteractor pageInteractor;
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
      pageInteractor.loadMoreData();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Kích hoạt load more khi cuộn được 90%
  }

  String getTitle() {
    return "Product List Page";
  }

  @override
  Widget build(BuildContext context) {
    pageInteractor = BlocProvider.of<ProductListInteractor>(context);
    // BlocConsumer. Chỉ bọc Builder quanh những gì thực sự cần thay đổi.
    return Scaffold(
      appBar: CustomAppBar(getTitle(), hideBackButton: true),
      body: BlocConsumer<ProductListInteractor, ProductListState>(
        listener: (context, state) {
          if (state is ProductListGetDataError) {
            eLog("Error: ${state.error.message}");
          }
        },
        buildWhen: (previousState, currentState) {
          return true;
        },
        builder: (context, state) {
          return getBody(context, state);
        },
      ),
    );
  }

  Widget getBody(BuildContext context, ProductListState state) {
    if (state is ProductListInitial || state is ProductListInProgress) {
      // return const Center(child: CircularProgressIndicator());
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
        hasReachedMax = false; // Dang load more thi chua coi la ket thuc
      }

      if (items.isEmpty) {
        return EmptyView(message: "Không tìm thấy sản phẩm nào");
      }

      return _buildListView(items, hasReachedMax, state is ProductListInLoadMoreProgress);
    }

    if (state is ProductListGetDataError) {
      return ErrorView(message: state.error.message, onRetry: () => pageInteractor.loadData());
    }

    return const SizedBox.shrink();
  }

  Widget _buildListView(List<Product> products, bool hasReachedMax, bool isLoadMore) {
    return RefreshIndicator(
      onRefresh: pageInteractor.onRefresh,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        // Thêm 1 item ở cuối để hiển thị Loading indicator khi load more
        itemCount: hasReachedMax ? products.length : products.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          // Get product by index
          final product = products[index];
          return InkWell(
            onTap: () {
              if (product.id case final id?) {
                pageInteractor.router?.gotoPostDetail(ProductDetailRoute(id), nextContext: context);
              }
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProductImage(imageUrl: product.images?.firstOrNull),
                    const SizedBox(width: 12),
                    _ProductContent(id: product.id, title: product.title, description: product.description),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? Image.network(
              imageUrl!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(width: 100, height: 100, color: Colors.grey[300], child: const Icon(Icons.error)),
            )
          : Container(width: 100, height: 100, color: Colors.grey[300], child: const Icon(Icons.image)),
    );
  }
}

class _ProductContent extends StatelessWidget {
  final int? id;
  final String? title;
  final String? description;

  const _ProductContent({this.id, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: $id', style: DefaultStyle.textSmall),
          const SizedBox(height: 4),
          Text(title ?? '', style: DefaultStyle.textLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(description ?? '', style: DefaultStyle.textNormal, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
