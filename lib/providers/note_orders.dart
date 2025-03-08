import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class NoteOrderGrouped {
  double? importe;
  DateTime? fechaEntrega;
  int? cantidad;
  NoteOrderGrouped({this.importe, this.fechaEntrega, this.cantidad});

  factory NoteOrderGrouped.fromJson(Map<String, dynamic> parseJson) {
    return NoteOrderGrouped(
      importe: double.parse(parseJson['importe'] ?? "0"),
      fechaEntrega: DateTime.parse(parseJson['fechaEntrega']),
      cantidad: int.parse(parseJson['cantidad'] ?? "0"),
    );
  }
}

class NoteOrderItem {
  final String idNoteOrder;
  final String nameCustommer;
  final String nroPedido;
  final String codigo;
  final String transportista;
  final String note;
  int? idTransportista;
  DateTime? fechaEntrega;
  double? importe;
  final List<CartItem> products;

  NoteOrderItem(
      {required this.idNoteOrder,
      required this.nameCustommer,
      this.nroPedido = '',
      this.codigo = '',
      this.transportista = '',
      this.idTransportista,
      this.fechaEntrega,
      this.note = '',
      this.importe,
      this.products = const []});
  factory NoteOrderItem.fromJson(Map<String, dynamic> parseJson) {
    return NoteOrderItem(
      idNoteOrder: parseJson['idPedido'],
      nameCustommer: parseJson['nombreCliente'],
      nroPedido: parseJson['nroPedido'],
      note: parseJson['note'],
      codigo: parseJson['codigo'],
      transportista: parseJson['transportista'],
      fechaEntrega: DateTime.parse(parseJson['fechaEntrega']),
      products: (parseJson['product'] as List<dynamic>)
          .map((item) => CartItem(
                idPedidP: int.parse(item['idPedidoP']),
                id: item['idProducto'],
                price: double.parse(item['precio_Compra'] ?? "0"),
                quantity: int.parse(item['cantidad'] ?? "0"),
                title: item['nameProducto'],
                cantidadPreparada: int.parse(item['cantidadPreparada'] ?? "0"),
                controlado: (item['controlado'] == "1"),
                preparado: (item['preparado'] == "1"),
                retiroDespacho: (item['retiroDespacho'] == "1"),
                camaraFriogorifico: (item['camaraFriogorifico'] == "1"),
                inputCantidadPrepa: TextEditingController(
                    text: (item['cantidadPreparada'] ?? "0")),
              ))
          .toList(),
    );
  }
}

class NoteOrders with ChangeNotifier {
  late NoteOrderItem orderActive;
  List<NoteOrderItem> _noteOrders = [];

  late NoteOrderGrouped orderActiveGrouped;
  List<NoteOrderGrouped> _noteOrdersGrouped = [];

  final String authToken;
  final String userId, rolId;

  NoteOrders(this.authToken, this.userId, this.rolId);

  List<NoteOrderItem> get noteOrders {
    return [..._noteOrders];
  }

  List<NoteOrderGrouped> get NoteOrderGroupeds {
    return [..._noteOrdersGrouped];
  }

  Future<void> fetchAndSetOrder() async {
    _noteOrdersGrouped = [];
    final url = 'https://distribuidorainsucor.com/APP_Api/api/notaOrdenes.php';
    try {
      final response = await http.get(Uri.parse(url));
      List<NoteOrderGrouped> loadedCustomers =
          (json.decode(response.body) as List)
              .map((e) => new NoteOrderGrouped.fromJson(e))
              .toList();
      _noteOrdersGrouped = loadedCustomers.toList();
      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
  }

  Future<void> fetchAndSetOrderDetails(DateTime fechaEntrega) async {
    _noteOrders = [];
    final url =
        'https://distribuidorainsucor.com/APP_Api/api/notaOrdenes.php?fechaEntrega=' +
            fechaEntrega.toString();
    try {
      final response = await http.get(Uri.parse(url));
      List<NoteOrderItem> loadedCustomers = (json.decode(response.body) as List)
          .map((e) => new NoteOrderItem.fromJson(e))
          .toList();
      _noteOrders = loadedCustomers.toList();
      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
  }

  Future<NoteOrderItem> getOrder(idNotaPedido) async {
    return orderActive;
  }

  Future<void> changeStatus(
      int idPedido, String campo, String value, String cantidadPre) async {
    final url = 'https://distribuidorainsucor.com/APP_Api/api/notaOrdenes.php';
    await http.post(
      Uri.parse(url),
      body: json.encode({
        'idnotaPedido': idPedido,
        'campo': campo,
        'value': value,
        'cantidadPre': cantidadPre,
        'userId': userId,
        'rolId': rolId,
      }),
    );
    notifyListeners();
  }

  // Future<void> fetchAndSetOrderFacturado() async {
  //   _noteOrders = [];
  //   if (_ordersOrdenesFacturadas.length <= 0) {
  //     final url =
  //         'https://distribuidorainsucor.com/APP_Api/api/ordenesFacturadas.php';
  //     try {
  //       final response = await http.get(Uri.parse(url));
  //       List<NoteOrderItem> loadedCustomers =
  //           (json.decode(response.body) as List)
  //               .map((e) => new NoteOrderItem.fromJson(e))
  //               .toList();
  //       _ordersOrdenesFacturadas = loadedCustomers.reversed.toList();
  //       notifyListeners();
  //     } catch (exception) {
  //       print("NO hay información: " + exception.toString());
  //       throw exception;
  //     }
  //   }
  //   _noteOrders = _ordersOrdenesFacturadas;
  // }

  // void addOrderModificad(NoteOrderItem order) {
  //   orderActive = order;
  // }

  // void clearOrderActive() {
  //   orderActive = null;
  // }

  // void activateOrder(String idOrder) {
  //   _noteOrders.forEach((item) {
  //     if (item.idNoteOrder == idOrder) {
  //       orderActive = item;
  //     }
  //   });
  // }

  // NoteOrderItem getActivated() {
  //   return orderActive;
  // }

  // Future<void> addOrder(
  //     String idOrder,
  //     List<CartItem> cartProducts,
  //     double total,
  //     int idCustommer,
  //     int idCarrier,
  //     String dateDelivery,
  //     String observation,
  //     String modo) async {
  //   //
  //   final url = 'https://distribuidorainsucor.com/APP_Api/api/ordenes.php';

  //   final response = await http.post(Uri.parse(url),
  //       body: json.encode(cartProducts
  //           .map((product) => {
  //                 'idPedido': idOrder,
  //                 'idCliente': idCustommer,
  //                 'idProducto': product.id,
  //                 'cantidad': product.quantity,
  //                 'precioCompra': product.price,
  //                 'precioSolicitado': product.priceRequested,
  //                 'observacion': observation,
  //                 'dateDelivery': dateDelivery,
  //                 'idCarrier': idCarrier,
  //                 'modo': modo,
  //                 'userId': userId
  //               })
  //           .toList()));
  //   notifyListeners();
  // }
}
