import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerOne with ChangeNotifier {
  final String id;
  final String nombre;
  final String empresa;
  final String telefono;
  final String direccion;
  final String code;
  String idLista;
  final String mail;
  bool isAgregate;
  List<String> facturadropdownItems;

  CustomerOne({
    required this.id,
    required this.nombre,
    required this.empresa,
    this.telefono = '',
    this.direccion = '',
    this.code = '',
    this.idLista = '',
    this.mail = '',
    this.isAgregate = false,
    this.facturadropdownItems = const [],
  });

  bool validarCliente() {
    if (this.nombre.isEmpty ||
        this.empresa.isEmpty ||
        this.telefono.isEmpty ||
        this.direccion.isEmpty ||
        this.code.isEmpty ||
        this.mail.isEmpty) {
      return false;
    }
    return true;
  }

  factory CustomerOne.fromJson(Map<String, dynamic> parseJson) {
    return CustomerOne(
      id: parseJson['id'],
      nombre: parseJson['nombre'],
      empresa: parseJson['empresa'],
      telefono: parseJson['telefono'],
      direccion: parseJson['direccion'],
      code: parseJson['codigo'],
      idLista: parseJson['idLista'],
      mail: parseJson['mail'],
      facturadropdownItems: (parseJson['facturadropdownItems'] as List<dynamic>)
          .map((item) => item['numeroFactura'].toString())
          .toList(),
    );
  }
}

class Customers with ChangeNotifier {
  CustomerOne? customerActive;
  final String authToken;
  final String userId;
  Customers(this.authToken, this.userId, this._items);

  List<CustomerOne> _items = [];

  List<CustomerOne> get items {
    return [..._items];
  }

  CustomerOne findById(String id) {
    return _items.firstWhere((custome) => custome.id == id);
  }

  CustomerOne findByCode(String code) {
    return _items.firstWhere((custome) => custome.code == code);
  }

  Future<void> refreshCustomer(String id) async {
    if (id == "0" && _items.length > 0) {
      return;
    }

    final customerIndex = _items.indexWhere((customer) => customer.id == id);
    var url =
        'https://distribuidorainsucor.com/APP_Api/api/clientes.php?idCustomer=' +
            id;
    try {
      final response = await http.get(Uri.parse(url));

      if (id == '0') {
        List<CustomerOne> loadedCustomers = (json.decode(response.body) as List)
            .map((e) => new CustomerOne.fromJson(e))
            .toList();
        _items = loadedCustomers;
      } else {
        CustomerOne newCustomer = (json.decode(response.body) as List)
            .map((e) => new CustomerOne.fromJson(e))
            .first;
        _items[customerIndex] = newCustomer;
        notifyListeners();
      }
    } catch (exception) {
      print("Error de Listado: " + exception.toString());
      throw exception;
    }
  }

  void addCustommer(String idCustomer, String name, String direccion,
      String idLista, String codes, String empres) {
    customerActive = new CustomerOne(
        id: idCustomer,
        nombre: name,
        direccion: direccion,
        idLista: idLista,
        code: codes,
        empresa: empres,
        facturadropdownItems: this
            ._items
            .firstWhere((el) => el.id == idCustomer)
            .facturadropdownItems);
  }

  void clearCustomer(String codigo) {
    customerActive = null;
    if (_items.length > 0) {
      _items.forEach((item) {
        item.isAgregate = false;
      });
    }
    if (codigo != "") {
      _items.forEach((item) {
        if (item.code == codigo) {
          item.isAgregate = true;
          addCustommer(item.id, item.nombre, item.direccion, item.idLista,
              item.code, item.empresa);
        }
      });
    }
  }

  void clearCustomerALL() {
    _items = [];
  }

  Future<void> addCustomer(CustomerOne product) async {
    // if (_items.length == 0) {
    //   final url =
    //       'https://flutter-shop-app-b3619.firebaseio.com/products.json?auth=$authToken';
    //   try {
    //     final response = await http.post(
    //       url,
    //       body: json.encode({
    //         'title': product.title,
    //         'description': product.description,
    //         'price': product.price,
    //         'imageUrl': product.imageUrl,
    //         'creatorId': userId,
    //       }),
    //     );

    //     final newProduct = Product(
    //       title: product.title,
    //       description: product.description,
    //       price: product.price,
    //       imageUrl: product.imageUrl,
    //       id: json.decode(response.body)['name'],
    //     );
    //     _items.add(newProduct);
    //     notifyListeners();
    //   } catch (exception) {
    //     print(exception);
    //     throw exception;
    //   }
    // }
  }

  Future<void> updateCustomer(String id, CustomerOne newCustomer) async {
    //
    final customerIndex = _items.indexWhere((customer) => customer.id == id);
    if (customerIndex >= 0) {
      final url = 'https://distribuidorainsucor.com/APP_Api/api/clientes.php';
      await http.post(
        Uri.parse(url),
        body: json.encode({
          'id': newCustomer.id,
          'nombre': newCustomer.nombre,
          'empresa': newCustomer.empresa,
          'telefono': newCustomer.telefono,
          'direccion': newCustomer.direccion,
          'code': newCustomer.code,
          'idLista': newCustomer.idLista,
          'mail': newCustomer.mail,
        }),
      );
      _items[customerIndex] = newCustomer;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
