import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isAgregate;
  bool recent;
  int stock;
  bool solicitoStock;
  DateTime? fechaUltimaStock;
  String nombreUsuario;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      this.imageUrl = '',
      this.isAgregate = false,
      this.recent = false,
      this.stock = 0,
      this.solicitoStock = false,
      this.fechaUltimaStock,
      this.nombreUsuario = ''});

  factory Product.fromJson(Map<String, dynamic> parseJson, List<String> lista) {
    bool isAgregado = lista
        .any((e) => e == parseJson['id']); // any(d=>d.id== parseJson['id']);
    return Product(
      id: parseJson['id'],
      title: parseJson['codigo'],
      description: parseJson['nombre'],
      price: double.parse(parseJson['precio'] ?? "0"),
      recent: (parseJson['recent'] == "1") ? true : false,
      imageUrl: '',
      isAgregate: isAgregado,
      stock: int.parse(parseJson['stock'] ?? "0"),
      solicitoStock: (parseJson['solicitoStock'] == "1") ? true : false,
      fechaUltimaStock: DateTime.parse(parseJson['fechaUltimaStock']),
      nombreUsuario: parseJson['usuario'] ?? "",
    );
  }

  void _setFavValue(bool newValue) {
    isAgregate = newValue;
    notifyListeners();
  }

  Future<void> toggleAgregate(String token, String userId) async {
    // final oldStatus = isAgregate;
    isAgregate = !isAgregate;
    // notifyListeners();
    _setFavValue(true);
    // final url =
    //     'https://flutter-shop-app-b3619.firebaseio.com/userFavorite/$userId/$id.json?auth=$token';

    // try {
    //   final response = await http.put(url, body: json.encode(isAgregate));
    //   if (response.statusCode >= 400) {
    //     _setFavValue(oldStatus);
    //   }
    // } catch (error) {
    //   _setFavValue(oldStatus);
    // }
  }

  Future<void> updateStock(
      String idProduct, String stock, String userId) async {
    //
    final url = 'https://distribuidorainsucor.com/APP_Api/api/productos.php';
    await http.post(
      Uri.parse(url),
      body: json
          .encode({'idProduct': idProduct, 'stock': stock, 'userId': userId}),
    );
    notifyListeners();
  }
}
