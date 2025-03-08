import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:http/http.dart' as http;
import './cart.dart';
import './routes.dart';

class DeliveryItem {
  final String idEntrega;
  final String nombre;
  final DateTime? fechaAlta;
  final String? estadoEntrega;
  final List<CartItem> products;

  DeliveryItem(
      {required this.idEntrega,
      required this.nombre,
      this.fechaAlta,
      this.estadoEntrega,
      this.products = const []});
  factory DeliveryItem.fromJson(Map<String, dynamic> parseJson) {
    return DeliveryItem(
      idEntrega: parseJson['IdEntrega'],
      nombre: parseJson['nombre'],
      fechaAlta: DateTime.parse(parseJson['FechaAlta']),
      estadoEntrega: parseJson['EstadoEntrega'],
      products: (parseJson['product'] as List<dynamic>)
          .map((item) => CartItem(
              idPedidP: int.parse(item['IdDetalle']),
              id: item['idProducto'],
              price: double.parse(item['Precio'] ?? "0"),
              quantity: int.parse(item['Cantidad'] ?? "0"),
              title: item['nombrePro']
              //  priceRequested: double.parse(item['priceRequested'] ?? "0")
              ))
          .toList(),
    );
  }
}

class Deliverys with ChangeNotifier {
  DeliveryItem? deliveryActive;
  List<DeliveryItem> _deliverys = [];
  final String? authToken;
  final String? userId;

  Deliverys(this.authToken, this.userId, this._deliverys);

  List<DeliveryItem> get deliverys {
    return [..._deliverys];
  }

  Future<void> fetchAndSetDelivery() async {
    final url =
        'https://distribuidorainsucor.com/APP_Api/api/Entrega.php?idUser=' +
            (this.userId ?? '0');
    try {
      final response = await http.get(Uri.parse(url));
      List<DeliveryItem> loadedCustomers = (json.decode(response.body) as List)
          .map((e) => new DeliveryItem.fromJson(e))
          .toList();
      _deliverys = loadedCustomers.reversed.toList();
      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
  }

  Future<void> addDelivery(int time, DateTime fechaInicio, DateTime fechaFin,
      OrderItem order, String idRuta) async {
    String estadoEntrega = order.products.any((element) => element.todo != true)
        ? "PENDIENTE"
        : "COMPLETO";
    List<CartItem> listCar = [];
    for (var i = 0; i < order.products.length; i++) {
      if (order.products[i].todo == true) {
        listCar.add(order.products[i]);
      }
    }
    await Routes.UpdateRoute(idRuta);

    final url = 'https://distribuidorainsucor.com/APP_Api/api/Entrega.php';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'idUser': this.userId,
          'idPedido': order.idOrder,
          'fechaInicio': fechaInicio.toString(),
          'fechaFin': fechaFin.toString(),
          'timeE': time,
          'estadoEntrega': estadoEntrega,
          'idRuta': idRuta,
          'detalle': listCar
              .map((e) => {
                    'idProducto': e.id,
                    'cantidad': e.quantity,
                    'precio': e.price,
                    'estadoMotivo': e.motivo,
                    'detalleMotivo': e.descripcion
                  })
              .toList(),
        }));
    notifyListeners();
  }
}
