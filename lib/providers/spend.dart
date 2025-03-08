import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Spends with ChangeNotifier {
  final String authToken;
  final String userId;

  Spends(this.authToken, this.userId);

  Future<void> addSpend(String tipoGasto, String motivo, String vehiculo,
      String comentario, String kms, String litros, String importe) async {
    final url = 'https://distribuidorainsucor.com/APP_Api/api/Gasto.php';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'tipoGasto': tipoGasto,
          'motivo': motivo,
          'comentario': comentario,
          'vehiculo': vehiculo,
          'kms': double.parse((kms == '') ? '0' : kms),
          'litros': double.parse((litros == '') ? '0' : litros),
          'importe': double.parse((importe == '') ? '0' : importe),
          'idUser': this.userId,
        }));
    notifyListeners();
  }
}
