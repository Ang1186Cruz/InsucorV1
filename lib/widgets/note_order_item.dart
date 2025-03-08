import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/widgets/product_order_item.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import '../providers/note_orders.dart' as ord;
import '../providers/note_orders.dart';
import '../screens/dashboard/components/file_info_card.dart';
import '../screens/entrega_screen.dart';

class NotesOrderItem extends StatefulWidget {
  final ord.NoteOrderItem order;
  final String value;

  NotesOrderItem(this.order, this.value);

  @override
  _NotesOrderItemState createState() => _NotesOrderItemState();
}

class _NotesOrderItemState extends State<NotesOrderItem> {
  var _expanded = false;
  bool forAndroid = true;
  int length = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    bool search = true;
    int cantidadTotal = 0;
    int cantidadPrepa = 0;
    int cantidadContro = 0;

    double porcentajePrepa = 0;
    double porcentajeContro = 0;

    double montoTotal = 0;

    if (!(widget.value.isEmpty || widget.value == "")) {
      search = (widget.order.nameCustommer
              .toUpperCase()
              .contains(widget.value.toUpperCase()) ||
          widget.order.codigo
              .toUpperCase()
              .contains(widget.value.toUpperCase()) ||
          widget.order.transportista
              .toUpperCase()
              .contains(widget.value.toUpperCase()));
    }
    length =
        (widget.order.products.length == 0) ? 1 : widget.order.products.length;

    for (var i = 0; i < widget.order.products.length; i++) {
      cantidadPrepa += widget.order.products[i].preparado ? 1 : 0;
      cantidadContro += (widget.order.products[i].controlado) ? 1 : 0;
      cantidadTotal += widget.order.products[i].quantity;
      montoTotal +=
          (widget.order.products[i].price * widget.order.products[i].quantity);
    }
    porcentajePrepa = (cantidadPrepa * 100) / widget.order.products.length;
    porcentajeContro = (cantidadContro * 100) / widget.order.products.length;
    return search
        ? AnimatedContainer(
            duration: Duration(milliseconds: 40),
            height: _expanded ? 500 : 100,
            child: Card(
              margin: EdgeInsets.all(2),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                        "(" +
                            widget.order.codigo +
                            ") " +
                            widget.order.nameCustommer,
                        style: TextStyle(color: Colors.blue)),
                    subtitle: Text(
                        "Transportista: " +
                            widget.order.transportista +
                            "\n " +
                            "(" +
                            widget.order.nroPedido +
                            ") " +
                            NumberFormat.simpleCurrency().format(montoTotal) +
                            "\n" +
                            DateFormat("dd/MM/yyyy").format(
                                widget.order.fechaEntrega ?? DateTime.now()),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    leading: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          new CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 5.0,
                            percent: (porcentajePrepa / 100),
                            center: new Text(
                                porcentajePrepa.toStringAsFixed(0) + "%"),
                            progressColor: Colors.purple,
                          ),
                          new CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 5.0,
                            percent: (porcentajeContro / 100),
                            center: new Text(
                                porcentajeContro.toStringAsFixed(0) + "%"),
                            progressColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                        width: 60,
                        child: Row(children: <Widget>[
                          IconButton(
                            icon: Icon(_expanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _expanded = !_expanded;
                                // activarTiempo(
                                //     _expanded, widget.order.idNoteOrder);
                              });
                            },
                          ),
                        ])),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    height: _expanded ? 25 : 0,
                    child: Row(
                      children: <Widget>[
                        SizedBox(height: 40),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "PRODUCTO",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              textAlign: TextAlign.left,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "CANT",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "PREP",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              textAlign: TextAlign.center,
                            )),
                        (auth.rolId == "1")
                            ? Expanded(
                                flex: 2,
                                child: Text(
                                  "CONTROL",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                  textAlign: TextAlign.center,
                                ))
                            : Expanded(child: Text("")),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "ACCIONES",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              textAlign: TextAlign.left,
                            )),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    height: _expanded
                        ? min(widget.order.products.length * 80.0 + 50, 300)
                        : 0,
                    child: ListView.separated(
                      itemBuilder: (_, index) =>
                          ProductOrderItem(widget.order.products[index]),
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.blueGrey),
                      itemCount: widget.order.products.length,
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Text(widget.order.note)
                ],
              ),
            ),
          )
        : AnimatedContainer(duration: const Duration(seconds: 1));
  }

  activarTiempo(bool expanded, String id) {
    final noteOrder = Provider.of<NoteOrders>(context, listen: false);

    Timer? miTimer;
    if (expanded) {
      miTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        var order = noteOrder.getOrder(id);
        setState(() {
          if (widget.order == order) {}
          print('Hola 1');
        });
      });

      print(id);
    } else {
      miTimer!.cancel();
    }
  }
}
