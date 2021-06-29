import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.description,
    required this.id,
    required this.imageUrl,
    this.isFavourite = false,
    required this.price,
    required this.title,
  });

  Future<void> toggleFavoutiteStatus(String token, String userId) async {
    this.isFavourite = !this.isFavourite;
    notifyListeners();

    final url =
        'https://valuejoyoptimism.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Could not favorite');
      }
    } catch (error) {
      this.isFavourite = !this.isFavourite;
      notifyListeners();
      throw error;
    }
  }
}
