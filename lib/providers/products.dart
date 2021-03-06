import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import '../models/Product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  final String authToken;
  final String userId;
  List<Product> _items = [];

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get fav_items {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterStr =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url =
        'https://valuejoyoptimism.firebaseio.com/products.json?auth=$authToken&$filterStr';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.body == "null") return;

      final favUrl =
          'https://valuejoyoptimism.firebaseio.com/userFavourites/$userId.json?auth=$authToken';

      final favResponse = await http.get(Uri.parse(favUrl));

      final favData = json.decode(favResponse.body);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedItems = [];
      extractedData.forEach((prodId, prodData) {
        loadedItems.add(
          Product(
            id: prodId,
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavourite: favData == null ? false : favData[prodId] ?? false,
          ),
        );
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product p) {
    final url =
        'https://valuejoyoptimism.firebaseio.com/products.json?auth=$authToken';

    return http
        .post(
      Uri.parse(url),
      body: json.encode(
        {
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
          'creatorId': userId,
        },
      ),
    )
        .then((response) {
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: p.description,
        imageUrl: p.imageUrl,
        price: p.price,
        title: p.title,
      );

      _items.add(newProduct);

      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex < 0) return;

    final url =
        'https://valuejoyoptimism.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(
      Uri.parse(url),
      body: json.encode(
        {
          'title': newProduct.title,
          'imageUrl': newProduct.imageUrl,
          'description': newProduct.description,
          'price': newProduct.price
        },
      ),
    );

    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://valuejoyoptimism.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((p) => p.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    await http.delete(Uri.parse(url)).then((response) {
      if (response.statusCode >= 400)
        throw HttpException('Couldnt delete product');
    }).catchError((error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw error;
    });

    notifyListeners();
  }
}
