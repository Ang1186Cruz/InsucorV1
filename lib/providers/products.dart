import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import 'package:flutter_shop_app/providers/cart.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = []; //DUMMY_PRODUCTS;

  Products(this.authToken, this.userId, this._items);
  Products.empty()
      : authToken = '',
        userId = '',
        _items = [];

  var _showFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isAgregate).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void clearProducts() {
    // if (_items.length > 0) {
    //   _items.forEach((item) {
    //     item.isAgregate = false;
    //   });
    // }
    _items = [];
    notifyListeners();
  }

  Future<void> fetchAndSetProduct(
      String idLista, Map<String, CartItem> itemsCard, String idCliente) async {
    List<String> listaProducto = [];
    if (itemsCard.length > 0) {
      itemsCard.forEach((key, value) {
        listaProducto.add(value.id);
      });
    }
    if (_items.length == 0) {
      var url =
          'https://distribuidorainsucor.com/APP_Api/api/productos.php?idLista=' +
              idLista +
              "&idCliente=" +
              idCliente;
      try {
        final response = await http.get(Uri.parse(url));
        List<Product> loadedProducts = (json.decode(response.body) as List)
            .map((e) => new Product.fromJson(e, listaProducto))
            .toList();
        _items = loadedProducts;
        notifyListeners();
      } catch (exception) {
        print("Error listado: " + exception.toString());
        throw exception;
      }
    }
  }

  void removeIsAgregate(String productId) {
    final int position =
        _items.indexWhere((element) => element.id == productId);
    if (position != -1) {
      _items[position].isAgregate = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    if (_items.length == 0) {
      final url =
          'https://flutter-shop-app-b3619.firebaseio.com/products.json?auth=$authToken';
      try {
        final response = await http.post(
          Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }),
        );

        final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'],
        );
        _items.add(newProduct);
        notifyListeners();
      } catch (exception) {
        print(exception);
        throw exception;
      }
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url =
          'https://flutter-shop-app-b3619.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shop-app-b3619.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }
}
