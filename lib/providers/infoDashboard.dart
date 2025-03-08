import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/constants.dart';
import 'package:http/http.dart' as http;

class ListDashboard {
  final String date, customer, invoice, status, transportista;
  final double? import, cheques, total;

  ListDashboard(
      {this.date = '',
      this.customer = '',
      this.invoice = '',
      this.status = '',
      this.import,
      this.cheques,
      this.total,
      this.transportista = ''});

  factory ListDashboard.fromJson(Map<String, dynamic> parseJson) {
    return ListDashboard(
      date: parseJson['fecha'],
      customer: parseJson['nombre'],
      invoice: parseJson['factura'],
      status: parseJson['status'],
      import: double.parse(parseJson['importe'] ?? "0"),
      transportista: parseJson['transportista'],
      cheques: double.parse(parseJson['cheques'] ?? "0"),
      total: double.parse(parseJson['total'] ?? "0"),
    );
  }
}

class RouterInfo {
  final String svgSrc, title, cantidadCliente, tabla;
  final int totaltarea, percentage;
  final double? total;
  final Color? color;

  RouterInfo({
    this.svgSrc = '',
    this.title = '',
    this.cantidadCliente = '',
    this.tabla = '',
    this.totaltarea = 0,
    this.percentage = 0,
    this.color,
    this.total,
  });

  factory RouterInfo.fromJson(Map<String, dynamic> parseJson) {
    return RouterInfo(
        title: parseJson['title'],
        totaltarea: int.parse(parseJson['totalTarea'] ?? "0"),
        svgSrc: "assets/icons/Documents.svg",
        cantidadCliente: parseJson['cantidadCliente'],
        tabla: parseJson['tabla'],
        color: (parseJson['isPrimary'] == "1") ? primaryColor : Colors.red,
        percentage: int.parse(parseJson['porcentaje'] ?? "0"),
        total: double.parse(parseJson['total'] ?? "0"));
  }
}

List<RouterInfo> listRouterInfo = [];
List<RouterInfo> listRutasAdminInfo = [];
List<ListDashboard> listInfoRouter = [];

class InfoListDashboard with ChangeNotifier {
  final String authToken;
  final String userId, rolId;
  InfoListDashboard(this.authToken, this.userId, this.rolId);

  Future<void> fetchAndSetListsDashboard() async {
    final urlRouter =
        'https://distribuidorainsucor.com/APP_Api/api/listadoDashboard.php?idUser=' +
            this.userId +
            '&idRol=' +
            this.rolId +
            '&isdetalle=0';

    final urlListDashboard =
        'https://distribuidorainsucor.com/APP_Api/api/listadoDashboard.php?idUser=' +
            this.userId +
            '&idRol=' +
            this.rolId +
            '&isdetalle=1';

    try {
      final response1 = await http.get(Uri.parse(urlRouter));
      List<RouterInfo> listaAxiliar = (json.decode(response1.body) as List)
          .map((e) => new RouterInfo.fromJson(e))
          .toList();
      listRouterInfo =
          listaAxiliar.where((element) => element.tabla != "Rutas").toList();
      listRutasAdminInfo =
          listaAxiliar.where((element) => element.tabla == "Rutas").toList();

      //       /// lista la informacion de la ruta o rencion del dia
      final response = await http.get(Uri.parse(urlListDashboard));
      List<ListDashboard> listInfoAuxiliar =
          (json.decode(response.body) as List)
              .map((e) => new ListDashboard.fromJson(e))
              .toList();
      listInfoRouter = listInfoAuxiliar.toList();

      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
  }
}
