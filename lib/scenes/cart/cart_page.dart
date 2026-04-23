/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 22/4/26 - 19:04
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

// lib/scenes/cart/cart_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/utils/app_colors.dart';
import 'package:coffee_bean/data/local/live_service/model/cart_item.dart';
import 'package:coffee_bean/scenes/cart/cart_bloc.dart';

class CartPage extends StatelessWidget {
    const CartPage({super.key});

    @override
    Widget build(BuildContext context) {
        return BlocProvider(
            create: (context) => CartBloc(),
            child: Scaffold(
                appBar: AppBar(
                    title: const Text("Giỏ hàng", style: TextStyle(color: Colors.black)),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: const BackButton(color: Colors.black),
                ),
                body: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                        if (state.items.isEmpty) {
                            return const Center(child: Text("Giỏ hàng của bạn đang trống"));
                        }
                        return Column(
                            children: [
                                Expanded(
                                    child: ListView.separated(
                                        padding: const EdgeInsets.all(16),
                                        itemCount: state.items.length,
                                        separatorBuilder: (_, __) => const Divider(height: 32),
                                        itemBuilder: (context, index) => _CartItemRow(item: state.items[index]),
                                    ),
                                ),
                                _CartSummary(total: state.totalAmount),
                            ],
                        );
                    },
                ),
            ),
        );
    }
}

class _CartItemRow extends StatelessWidget {
    final CartItem item;
    const _CartItemRow({required this.item});

    @override
    Widget build(BuildContext context) {
        final bloc = context.read<CartBloc>();
        return Row(
            children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                        item.product.images?.first ?? '',
                        width: 70, height: 70, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], width: 70, height: 70),
                    ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(item.product.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            if (item.note != null) Text(item.note!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            const SizedBox(height: 8),
                            Text("${item.product.price?.toStringAsFixed(0)}đ", style: TextStyle(color: AppColor.orangeDark)),
                        ],
                    ),
                ),
                Row(
                    children: [
                        _qtyBtn(Icons.remove, () => bloc.updateQuantity(item.cartItemId, item.quantity - 1)),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text("${item.quantity}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        _qtyBtn(Icons.add, () => bloc.updateQuantity(item.cartItemId, item.quantity + 1)),
                    ],
                )
            ],
        );
    }

    Widget _qtyBtn(IconData icon, VoidCallback onTap) {
        return InkWell(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), shape: BoxShape.circle),
                child: Icon(icon, size: 16),
            ),
        );
    }
}

class _CartSummary extends StatelessWidget {
    final double total;
    const _CartSummary({required this.total});

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
                child: Column(
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                const Text("Tổng cộng", style: TextStyle(fontSize: 16)),
                                Text("${total.toStringAsFixed(0)}đ",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.orangeDark)),
                            ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () { /* Logic Checkout */ },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.orangeDark,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text("THANH TOÁN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}