import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/data/local/live_service/model/cart_item.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/interactor/product_cart_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/product_cart/interactor/product_cart_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:coffee_bean/shared/widget/empty_view.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ProductCartPage extends CubitStateFulWidget<ProductCartInteractor, ProductCartState> {
  ProductCartPage({super.key, required super.interactor});

  @override
  State<ProductCartPage> createState() => _ProductCartPageState();
}

class _ProductCartPageState extends CubitState<ProductCartPage, ProductCartInteractor, ProductCartState> {

  @override
  dynamic getAppBar(BuildContext context) => "Giỏ hàng";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ProductCartInteractor, ProductCartState>(
      builder: (context, state) {
        if (state is ProductCartInitial) {
          return const Center(child: LoadingView(width: 150, height: 150));
        }

        if (state is ProductCartGetDataSuccess) {
          if (state.items.isEmpty) {
            return const EmptyView(message: "Giỏ hàng của bạn đang trống");
          }

          return Column(
            children: [
              Expanded(child: _buildCartList(state.items)),
              _buildBottomSummary(state.totalAmount),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCartList(List<CartItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => interactor.gotoDetail(item.product),
          borderRadius: BorderRadius.circular(10),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedImageWidget(
                    imageUrl: item.product.images?.firstOrNull,
                    width: 80,
                    height: 80,
                    borderRadius: 8,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.title ?? '',
                          style: DefaultStyle.textNormal.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.note != null && item.note!.isNotEmpty)
                          Text(
                            "Ghi chú: ${item.note}",
                            style: DefaultStyle.textSmall.copyWith(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item.totalPrice.toStringAsFixed(0)}đ",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            _buildQuantityController(item),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityController(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: () => interactor.updateQuantity(item.cartItemId, item.quantity - 1),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "${item.quantity}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => interactor.updateQuantity(item.cartItemId, item.quantity + 1),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tổng cộng", style: TextStyle(color: Colors.grey)),
                Text(
                  "${totalAmount.toStringAsFixed(0)}đ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Logic thanh toán sau này
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("Thanh toán", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
