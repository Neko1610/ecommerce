import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<int> _wishlist = {};

  Set<int> get wishlist => _wishlist;

  bool isFavorite(int productId) {
    return _wishlist.contains(productId);
  }

  void toggle(int productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }
}