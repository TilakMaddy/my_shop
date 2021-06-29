import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get count {
    return _orders.length;
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://valuejoyoptimism.firebaseio.com/orders.json?auth=$authToken";
    final response = await http.get(Uri.parse(url));

    if (response.body == "null") return;

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData['error'] != null) {
      print("throwing exception!");
      throw HttpException(extractedData['error']);
    }

    List<OrderItem> loadedOrders = [];

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: [...orderData['products']].map((e) {
            print(e);
            return CartItem(
              id: e['id'],
              price: e['price'],
              title: e['title'],
              quantity: e['quantity'],
            );
          }).toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });

    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final url =
        "https://valuejoyoptimism.firebaseio.com/orders.json?auth=$authToken";

    final timestamp = DateTime.now();

    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartItems.map((e) {
            return {
              'id': e.id,
              'title': e.title,
              'price': e.price,
              'quantity': e.quantity,
            };
          }).toList(),
        },
      ),
    );

    final id = json.decode(response.body)['name'];

    _orders.insert(
      0,
      OrderItem(
        id: id,
        amount: total,
        products: cartItems,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
