import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RouteItem with ChangeNotifier {
  final String id;
  final String cliente;
  final String codCli;
  final String nroComprobante;
  final String? idPedido;
  final double? importe;
  final String? accion; // podria ser ENTREGADO COBRADO;

  RouteItem(
      {required this.id,
      required this.cliente,
      required this.codCli,
      this.nroComprobante = '',
      this.idPedido,
      this.importe,
      this.accion});

  factory RouteItem.fromJson(Map<String, dynamic> parseJson) {
    return RouteItem(
      id: parseJson['idRuta'],
      cliente: parseJson['cliente'],
      codCli: parseJson['codCli'],
      nroComprobante: parseJson['nroComprobante'],
      idPedido: parseJson['idPedido'],
      importe: double.parse(parseJson['importe'] ?? "0"),
      accion: parseJson['accion'],
    );
  }
}

class Routes with ChangeNotifier {
  final String authToken;
  final String userId;
  Routes(this.authToken, this.userId, this.routers);

  List<RouteItem> routers = [];

  List<RouteItem> get routes {
    return [...routers];
  }

  RouteItem findById(String id) {
    return routers.firstWhere((custome) => custome.id == id);
  }

  Future<void> refreshRiuter() async {
    var url =
        'https://distribuidorainsucor.com/APP_Api/api/rutas.php?idCobrador=' +
            this.userId;
    try {
      final response = await http.get(Uri.parse(url));
      List<RouteItem> loadedRoutes = (json.decode(response.body) as List)
          .map((e) => new RouteItem.fromJson(e))
          .toList();
      routers = loadedRoutes;
      notifyListeners();
    } catch (exception) {
      print("Error de Listado: " + exception.toString());
      throw exception;
    }
  }

  static Future<void> UpdateRoute(String idRuta) async {
    if (idRuta != '') {
      final url = 'https://distribuidorainsucor.com/APP_Api/api/rutas.php';
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'idRuta': idRuta,
          }));
    }
  }
}
