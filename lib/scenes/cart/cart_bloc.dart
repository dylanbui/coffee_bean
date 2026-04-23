/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 22/4/26 - 19:02
 * To change this template use File | Settings | File Templates.
 */

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/live_service/model/cart_item.dart';
import 'package:coffee_bean/data/model/product.dart';

class CartState extends Equatable {
    final List<CartItem> items;
    final double totalAmount;

    const CartState({this.items = const [], this.totalAmount = 0});

    @override
    List<Object?> get props => [items, totalAmount];
}

class CartBloc extends Cubit<CartState> {
    final CartService _cartService = CartService();
    StreamSubscription? _subscription;

    CartBloc() : super(const CartState()) {
        _subscription = _cartService.cartStream.listen((items) {
            emit(CartState(items: items, totalAmount: _cartService.totalAmount));
        });
        // Init state
        emit(CartState(items: _cartService.currentItems, totalAmount: _cartService.totalAmount));
    }

    void addToCart(Product product, {int quantity = 1, String? note}) => _cartService.addToCart(product, quantity: quantity, note: note);
    void updateQuantity(String id, int qty) => _cartService.updateQuantity(id, qty);
    void removeItem(String id) => _cartService.removeItem(id);

    @override
    Future<void> close() {
        _subscription?.cancel();
        return super.close();
    }
}