import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './routes.dart';

class ChequesItem {
  String? numero;
  double? importe;
  ChequesItem({this.numero, this.importe});
}

class CobroItem {
  final String idCobro;
  final String idCliente;
  String? nombre;
  String? noFactura;
  double? totalEfectivo;
  double? totalCheque;
  double? totalRecibido;
  DateTime? fechaCobro;

  CobroItem(
      {required this.idCobro,
      required this.idCliente,
      this.nombre,
      this.noFactura,
      this.totalEfectivo,
      this.totalCheque,
      this.totalRecibido,
      this.fechaCobro});

  factory CobroItem.fromJson(Map<String, dynamic> parseJson) {
    return CobroItem(
      idCobro: parseJson['IdCobro'],
      idCliente: parseJson['IdCliente'],
      nombre: parseJson['nombre'],
      noFactura: parseJson['NoFactura'],
      totalEfectivo: double.parse(parseJson['TotalEfectivo']),
      totalCheque: double.parse(parseJson['TotalCheque']),
      totalRecibido: double.parse(parseJson['TotalRecibido']),
      fechaCobro: DateTime.parse(parseJson['FechaCobro']),
    );
  }
}

class Cobros with ChangeNotifier {
  late CobroItem cobroActive;
  List<CobroItem> _cobros = [];
  final String authToken;
  final String userId;

  Cobros(this.authToken, this.userId, this._cobros);

  List<CobroItem> get cobros {
    return [..._cobros];
  }

  Future<void> fetchAndSetCobro() async {
    final url =
        'https://distribuidorainsucor.com/APP_Api/api/Cobro.php?idUser=' +
            this.userId;
    try {
      final response = await http.get(Uri.parse(url));
      List<CobroItem> loadedCustomers = (json.decode(response.body) as List)
          .map((e) => new CobroItem.fromJson(e))
          .toList();
      _cobros = loadedCustomers.reversed.toList();
      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
  }

  Future<void> addCobro(
      String idCliente,
      String numFactura,
      String eveinteMil,
      String ediezMil,
      String edosMil,
      String eMil,
      String eQuinientos,
      String eDocientos,
      String eCien,
      String eCincuenta,
      String eVeinte,
      String eDiez,
      String numero1,
      String importe1,
      String numero2,
      String importe2,
      String numero3,
      String importe3,
      String numero4,
      String importe4,
      String numero5,
      String importe5,
      String numero6,
      String importe6,
      String comentario,
      String iDolar,
      String iRecibido,
      String tEfectivo,
      String tCheque,
      String tRecibido,
      String idRuta,
      bool notControl) async {
    List<ChequesItem> _items = [];
    _items.add(new ChequesItem(
        numero: numero1,
        importe: double.parse((importe1 == '') ? '0' : importe1)));
    _items.add(new ChequesItem(
        numero: numero2,
        importe: double.parse((importe2 == '') ? '0' : importe2)));
    _items.add(new ChequesItem(
        numero: numero3,
        importe: double.parse((importe3 == '') ? '0' : importe3)));
    _items.add(new ChequesItem(
        numero: numero4,
        importe: double.parse((importe4 == '') ? '0' : importe4)));
    _items.add(new ChequesItem(
        numero: numero5,
        importe: double.parse((importe5 == '') ? '0' : importe5)));
    _items.add(new ChequesItem(
        numero: numero6,
        importe: double.parse((importe6 == '') ? '0' : importe6)));
    await Routes.UpdateRoute(idRuta);
    final url = 'https://distribuidorainsucor.com/APP_Api/api/Cobro.php';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'idCliente': idCliente,
          'idUser': this.userId,
          'numFactura': numFactura,
          'eveinteMil': int.parse((eveinteMil == '') ? '0' : eveinteMil),
          'ediezMil': int.parse((ediezMil == '') ? '0' : ediezMil),
          'edosMil': int.parse((edosMil == '') ? '0' : edosMil),
          'eMil': int.parse((eMil == '') ? '0' : eMil),
          'eQuinientos': int.parse((eQuinientos == '') ? '0' : eQuinientos),
          'eDocientos': int.parse((eDocientos == '') ? '0' : eDocientos),
          'eCien': int.parse((eCien == '') ? '0' : eCien),
          'eCincuenta': int.parse((eCincuenta == '') ? '0' : eCincuenta),
          'eVeinte': int.parse((eVeinte == '') ? '0' : eVeinte),
          'eDiez': int.parse((eDiez == '') ? '0' : eDiez),
          'ListaItem': _items
              .map((e) => {
                    'numero': e.numero,
                    'importe': e.importe,
                  })
              .toList(),
          'comentario': comentario,
          'iDolar': double.parse((iDolar == '') ? '0' : iDolar),
          'iRecibido': double.parse((iRecibido == '') ? '0' : iRecibido),
          'tEfectivo': double.parse((tEfectivo == '') ? '0' : tEfectivo),
          'tCheque': double.parse((tCheque == '') ? '0' : tCheque),
          'tRecibido': double.parse((tRecibido == '') ? '0' : tRecibido),
          'notControl': notControl ? 1 : 0,
        }));
    notifyListeners();
  }
}
