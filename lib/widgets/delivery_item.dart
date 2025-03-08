import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/deliverys.dart' as ord;

class DeliveryItem extends StatefulWidget {
  final ord.DeliveryItem delivery;
  final String value;

  DeliveryItem(this.delivery, this.value);

  @override
  _DeliveryItemState createState() => _DeliveryItemState();
}

class _DeliveryItemState extends State<DeliveryItem> {
  var _expanded = false;
  int length = 0;

  @override
  Widget build(BuildContext context) {
    bool search = true;
    int cantidadTotal = 0;
    double montoTotal = 0;
    if (!(widget.value.isEmpty || widget.value == "")) {
      search = (widget.delivery.nombre
              .toUpperCase()
              .contains(widget.value.toUpperCase()) ||
          widget.delivery.estadoEntrega!
              .toUpperCase()
              .contains(widget.value.toUpperCase()));
    }
    length = (widget.delivery.products.length == 0)
        ? 1
        : widget.delivery.products.length;

    for (var i = 0; i < widget.delivery.products.length; i++) {
      cantidadTotal += widget.delivery.products[i].quantity;
      montoTotal += (widget.delivery.products[i].price *
          widget.delivery.products[i].quantity);
    }
    return search
        ? AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: _expanded ? 500 : 120,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(widget.delivery.nombre,
                        style: TextStyle(color: Colors.blue)),
                    // visualDensity: VisualDensity(vertical: 10),
                    subtitle: Text(
                        DateFormat("dd/MM/yyyy HH:mm").format(
                            widget.delivery.fechaAlta ?? DateTime.now()),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    trailing: Container(
                        width: 100,
                        child: Row(children: <Widget>[
                          IconButton(
                            icon: Icon(_expanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                          ),
                        ])),
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
                            child: Text(
                          "PRODUCTO",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.left,
                        )),
                        Expanded(
                            child: Text(
                          "CANT",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                            child: Text(
                          "P.U.",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    height: _expanded
                        ? min(widget.delivery.products.length * 80.0 + 50, 300)
                        : 0,
                    child: ListView.separated(
                      itemBuilder: (_, index) => Row(
                        children: <Widget>[
                          SizedBox(height: 40),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                    child: Text(
                                  widget.delivery.products[index].title,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                                ((length - 1) == index)
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(top: 30.0),
                                        child: Text(
                                          "TOTAL",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                    child: Text(
                                  "${widget.delivery.products[index].quantity}",
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                )),
                                ((length - 1) == index)
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(top: 40.0),
                                        child: Text(
                                          "${cantidadTotal}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                    child: Text(
                                  NumberFormat.simpleCurrency().format(
                                      widget.delivery.products[index].price),
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.right,
                                )),
                                ((length - 1) == index)
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(top: 40.0),
                                        child: Text(
                                          NumberFormat.simpleCurrency()
                                              .format(montoTotal),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.blueGrey),
                      itemCount: widget.delivery.products.length,
                    ),
                  ),
                ],
              ),
            ),
          )
        : AnimatedContainer(duration: const Duration(seconds: 1));
  }
}
