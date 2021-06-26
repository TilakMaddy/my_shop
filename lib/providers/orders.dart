import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [...orders];
  }

  int get count {
    return _orders.length;
  }

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toIso8601String(),
        amount: total,
        products: cartItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
