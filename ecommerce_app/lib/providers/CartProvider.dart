import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  /// 🔥 ADD TO CART (DÙNG variantId)
 void addToCart(CartItem newItem) {
  final index = _items.indexWhere(
    (item) => item.variantId == newItem.variantId,
  );

  if (index != -1) {
    _items[index] = _items[index].copyWith(
      quantity: _items[index].quantity + newItem.quantity,
    );
  } else {
    _items.add(newItem);
  }

  notifyListeners();
}

  /// ❌ REMOVE
 void removeItem(CartItem item) {
  _items.removeWhere(
    (e) => e.variantId == item.variantId,
  );

  notifyListeners();
}

  /// ➕ INCREASE
  void increaseQty(CartItem item) {
    final index = _items.indexWhere(
      (e) => e.variantId == item.variantId,
    );

    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: item.quantity + 1,
      );
      notifyListeners();
    }
  }

  /// ➖ DECREASE
  void decreaseQty(CartItem item) {
    final index = _items.indexWhere(
      (e) => e.variantId == item.variantId,
    );

    if (index != -1) {
      if (item.quantity > 1) {
        _items[index] = _items[index].copyWith(
          quantity: item.quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// 🧹 CLEAR
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// 💰 SUBTOTAL
  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  double get shipping => 0;

  double get discount => 0;

  double get total {
    return subtotal + shipping - discount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// ✅ CHECK EXIST
  bool isInCart(CartItem item) {
  return _items.any(
    (e) => e.variantId == item.variantId,
  );
}
}