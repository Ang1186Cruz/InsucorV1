import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class Event {
  final String title;
  final String details;
  const Event(this.title, this.details);
  @override
  String toString() => title;
}

Map<DateTime, List<Event>> listEventSource = {};

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
//)..addAll(_kEventSource);
)..addAll(listEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1,
        (index) => Event('CREMA LEDEVIT CHANTILLY X 4.7 KGS',
            'Lote: 35867 \n Fecha Compra: 2024-10-01 \n Cantidad: 40')))
  ..addAll({
    kToday: [
      Event('CREMA LEDEVIT SUAVE X 5 LTS ',
          'Lote: 35867 \n Fecha Compra: 2024-10-01 \n Cantidad: 40'),
      Event('CREMA LEDEVIT VAINILLA X 4.7 KGS',
          'Lote: 35867 \n Fecha Compra: 2024-10-01 \n Cantidad: 40'),
    ],
  });

class Events with ChangeNotifier {
  final String authToken;
  final String userId;
  Events(this.authToken, this.userId);

  Future<void> fetchEventsFromAPI() async {
    final url =
        'https://distribuidorainsucor.com/APP_Api/api/productos.php?agrupados=true';
    try {
      final response = await http.get(Uri.parse(url));
      List eventsData = (json.decode(response.body) as List);
      Map<DateTime, List<Event>> events = {};
      for (var event in eventsData) {
        DateTime eventDate =
            DateFormat('yyyy-MM-dd').parse(event['fechaVencimiento']).toUtc();
        events[eventDate] = events[eventDate] ?? [];
        events[eventDate]?.add(Event(event['nombre'],
            'Lote: ${event['lote']} \n Fecha Compra: ${event['fechaCompra']} \n Cantidad: ${event['cantidad']}'));
      }
      listEventSource = events;
      notifyListeners();
    } catch (exception) {
      print("NO hay información: " + exception.toString());
      throw exception;
    }
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
