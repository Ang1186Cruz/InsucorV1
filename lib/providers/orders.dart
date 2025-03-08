import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String idOrder;
  final String nameCustommer;
  final String mailCustomer;
  final String address;
  final DateTime? fecha;
  final String codigo;
  final String transportista;
  final String noCerrado;
  int idTransportista;
  DateTime? fechaEntrega;
  String observacion;
  String modo;
  String telefono;
  double? importe;
  final List<CartItem> products;

  OrderItem(
      {required this.idOrder,
      required this.nameCustommer,
      this.mailCustomer = '',
      this.address = '',
      this.fecha,
      this.codigo = '',
      this.transportista = '',
      this.noCerrado = '',
      this.idTransportista = 0,
      this.fechaEntrega,
      this.observacion = '',
      this.modo = '',
      this.telefono = '',
      this.importe,
      this.products = const []});
  factory OrderItem.fromJson(Map<String, dynamic> parseJson) {
    return OrderItem(
      idOrder: parseJson['idPedido'],
      nameCustommer: parseJson['nombreCliente'],
      mailCustomer: parseJson['mailCliente'],
      address: parseJson['direccionCliente'],
      fecha: DateTime.parse(parseJson['fechaPedido']),
      codigo: parseJson['codigo'],
      transportista: parseJson['transportista'],
      noCerrado: parseJson['noCerrado'],
      idTransportista: int.parse(parseJson['idTransportista']),
      fechaEntrega: DateTime.parse(parseJson['fechaEntrega']),
      observacion: parseJson['observacion'],
      modo: parseJson['modo'],
      telefono: parseJson['telefono'],
      importe: double.parse(parseJson['importe'] ?? "0"),
      products: (parseJson['product'] as List<dynamic>)
          .map((item) => CartItem(
              idPedidP: int.parse(item['idPedidoP']),
              id: item['idProducto'],
              price: double.parse(item['precio_Compra'] ?? "0"),
              quantity: int.parse(item['cantidad'] ?? "0"),
              title: item['nameProducto'],
              priceRequested: double.parse(item['priceRequested'] ?? "0")))
          .toList(),
    );
  }
}

class Orders with ChangeNotifier {
  OrderItem? orderActive;
  List<OrderItem> _orders = [];
  List<OrderItem> _ordersOrdenes = [];
  List<OrderItem> _ordersOrdenesFacturadas = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    _orders = [];
    //if (_ordersOrdenes.length <= 0) {
    final url = 'https://distribuidorainsucor.com/APP_Api/api/ordenes.php';
    try {
      final response = await http.get(Uri.parse(url));
      List<OrderItem> loadedCustomers = (json.decode(response.body) as List)
          .map((e) => new OrderItem.fromJson(e))
          .toList();
      _ordersOrdenes = loadedCustomers.reversed.toList();
      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
    //}
    _orders = _ordersOrdenes;
  }

  Future<void> fetchAndSetOrderFacturado() async {
    _orders = [];
    if (_ordersOrdenesFacturadas.length <= 0) {
      final url =
          'https://distribuidorainsucor.com/APP_Api/api/ordenesFacturadas.php';
      try {
        final response = await http.get(Uri.parse(url));
        List<OrderItem> loadedCustomers = (json.decode(response.body) as List)
            .map((e) => new OrderItem.fromJson(e))
            .toList();
        _ordersOrdenesFacturadas = loadedCustomers.reversed.toList();
        notifyListeners();
      } catch (exception) {
        print("NO hay información: " + exception.toString());
        throw exception;
      }
    }
    _orders = _ordersOrdenesFacturadas;
  }

  void addOrderModificad(OrderItem order) {
    orderActive = order;
  }

  void clearOrderActive() {
    orderActive = null;
  }

  void activateOrder(String idOrder) {
    _orders.forEach((item) {
      if (item.idOrder == idOrder) {
        orderActive = item;
      }
    });
  }

  OrderItem getActivated() {
    return orderActive ??
        OrderItem(
          idOrder: '',
          nameCustommer: '',
          mailCustomer: '',
          address: '',
          fecha: null,
          codigo: '',
          transportista: '',
          noCerrado: '',
          idTransportista: 0,
          fechaEntrega: null,
          observacion: '',
          modo: '',
          telefono: '',
          importe: 0.0,
          products: [],
        );
  }

  Future<void> addOrder(
      String idOrder,
      List<CartItem> cartProducts,
      double total,
      int idCustommer,
      int idCarrier,
      String dateDelivery,
      String observation,
      String modo) async {
    //
    final url = 'https://distribuidorainsucor.com/APP_Api/api/ordenes.php';

    final response = await http.post(Uri.parse(url),
        body: json.encode(cartProducts
            .map((product) => {
                  'idPedido': idOrder,
                  'idCliente': idCustommer,
                  'idProducto': product.id,
                  'cantidad': product.quantity,
                  'precioCompra': product.price,
                  'precioSolicitado': product.priceRequested,
                  'observacion': observation,
                  'dateDelivery': dateDelivery,
                  'idCarrier': idCarrier,
                  'modo': modo,
                  'userId': userId
                })
            .toList()));
    notifyListeners();
  }
}
