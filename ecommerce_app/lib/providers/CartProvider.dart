import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // ================= ADD =================
  void addToCart(CartItem newItem) {
    final index = _items.indexWhere(
      (item) =>
          item.productId == newItem.productId &&
          item.color == newItem.color &&
          item.size == newItem.size,
    );

    if (index != -1) {
      // update quantity
      final updated = _items[index].copyWith(
        quantity: _items[index].quantity + newItem.quantity,
      );

      _items[index] = updated;
    } else {
      _items.add(newItem);
    }

    notifyListeners();
  }

  // ================= REMOVE =================
  void removeItem(CartItem item) {
    _items.removeWhere(
      (e) =>
          e.productId == item.productId &&
          e.color == item.color &&
          e.size == item.size,
    );

    notifyListeners();
  }

  // ================= UPDATE QTY =================
  void increaseQty(CartItem item) {
    final index = _items.indexOf(item);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: item.quantity + 1);
      notifyListeners();
    }
  }

  void decreaseQty(CartItem item) {
    final index = _items.indexOf(item);

    if (index != -1) {
      if (item.quantity > 1) {
        _items[index] = _items[index].copyWith(quantity: item.quantity - 1);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // ================= CLEAR =================
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ================= TOTAL =================
  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  double get shipping => 0; // sau này tính API

  double get discount => 0;

  double get total {
    return subtotal + shipping - discount;
  }

  // ================= COUNT =================
  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // ================= CHECK =================
  bool isInCart(CartItem item) {
    return _items.any(
      (e) =>
          e.productId == item.productId &&
          e.color == item.color &&
          e.size == item.size,
    );
  }
}
