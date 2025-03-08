import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarrierOne with ChangeNotifier {
  final int id;
  final String nombre;
  bool isAgregate;

  CarrierOne({
    required this.id,
    required this.nombre,
    this.isAgregate = false,
  });

  factory CarrierOne.fromJson(Map<String, dynamic> parseJson) {
    return CarrierOne(
      id: int.parse(parseJson['idTransportista'] ?? "0"),
      nombre: parseJson['nombre'],
    );
  }
}

class Carriers with ChangeNotifier {
  final String authToken;
  final String userId;
  Carriers(this.authToken, this.userId, this._items);
  List<CarrierOne> _items = [];

  List<CarrierOne> get items {
    return [..._items];
  }

  Future<void> fetchAndSetCarrier() async {
    _items = [];
    final url =
        'https://distribuidorainsucor.com/APP_Api/api/transportistas.php';
    try {
      final response = await http.get(Uri.parse(url));
      List<CarrierOne> loadedCarrier = (json.decode(response.body) as List)
          .map((e) => new CarrierOne.fromJson(e))
          .toList();
      _items = loadedCarrier.toList();
      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
  }
}
