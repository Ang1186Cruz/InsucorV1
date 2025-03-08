import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import 'package:flutter/services.dart';

import '../providers/note_orders.dart';

class ProductOrderItem extends StatefulWidget {
  final CartItem product;

  ProductOrderItem(this.product);

  @override
  _ProductOrderItem createState() => _ProductOrderItem();
}

class _ProductOrderItem extends State<ProductOrderItem> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Dismissible(
      key: ValueKey(widget.product.id),
      direction: (widget.product.controlado || widget.product.preparado)
          ? DismissDirection.none
          : DismissDirection.horizontal,
      background: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Text('PREPARADO CON CANTIDAD',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('SIN STOCK', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (innerContext) => AlertDialog(
            title: Text('Esta Seguro!'),
            content: Text('¿Quieres cambiar a Preparado?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(innerContext).pop(false);
                },
              ),
              TextButton(
                child: Text("Si"),
                onPressed: () {
                  widget.product.preparado = true;
                  if (direction == DismissDirection.startToEnd) {
                    save(widget.product.idPedidP, "Preparado", true,
                        widget.product.inputCantidadPrepa!.text);
                  } else {
                    widget.product.inputCantidadPrepa!.text = "0";
                    save(widget.product.idPedidP, "Preparado", true, "0");
                  }
                  Navigator.of(innerContext).pop(false);
                  setState(() {});
                },
              )
            ],
          ),
        );
      },
      // onDismissed: (direction) {
      //   widget.product.preparado = true;
      //   if (direction == DismissDirection.startToEnd) {
      //     save(widget.product.idPedidP, "Preparado", true,
      //         widget.product.inputCantidadPrepa.text);
      //   } else {
      //     widget.product.inputCantidadPrepa.text = "0";
      //     save(widget.product.idPedidP, "Preparado", true, "0");
      //   }
      //   //debugger();
      //   // setState(() => widget.product.preparado = true);
      //   setState(() {});
      // },
      child: Container(
        color: (widget.product.controlado || widget.product.preparado)
            ? Color.fromARGB(255, 245, 239, 214)
            : Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(height: 40),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                      child: Text(
                    widget.product.title,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.left,
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                      child: Text(
                    "${widget.product.quantity}",
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  TextField(
                    enabled: !(widget.product.controlado ||
                        widget.product.preparado),
                    style: TextStyle(fontSize: 10),
                    controller: widget.product.inputCantidadPrepa,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.black), //<-- SEE HERE
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ],
              ),
            ),
            (auth.rolId == "1")
                ? Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                          child: Switch(
                              activeColor: Color.fromARGB(255, 216, 239, 217),
                              activeTrackColor: Colors.green,
                              inactiveThumbColor:
                                  Color.fromARGB(255, 253, 222, 220),
                              inactiveTrackColor: Colors.red,
                              splashRadius: 50.0,
                              value: widget.product.controlado,
                              onChanged: (value) {
                                save(
                                    widget.product.idPedidP,
                                    "Controlado",
                                    !widget.product.controlado,
                                    widget.product.inputCantidadPrepa!.text);
                                setState(
                                    () => widget.product.controlado = value);
                              }),
                        ),
                      ],
                    ))
                : Expanded(child: Text("")),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    (widget.product.controlado || widget.product.preparado)
                        ? Container(
                            child: widget.product.controlado
                                ? Text(
                                    "CONTROLADO",
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      save(
                                          widget.product.idPedidP,
                                          "Preparado",
                                          false,
                                          widget.product.inputCantidadPrepa!
                                              .text);
                                      setState(() {
                                        widget.product.preparado = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit_attributes,
                                      color: Colors.green,
                                    ),
                                  ),
                          )
                        : Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: () {
                                        save(
                                            widget.product.idPedidP,
                                            "RetiroDespacho",
                                            !widget.product.retiroDespacho,
                                            "0");
                                        setState(() {
                                          widget.product.retiroDespacho =
                                              !widget.product.retiroDespacho;
                                        });
                                      },
                                      icon: Icon(
                                          widget.product.retiroDespacho
                                              ? Icons.done_all_outlined
                                              : Icons.home,
                                          color: Colors.white),
                                    )),
                                CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: () {
                                        save(
                                            widget.product.idPedidP,
                                            "CamaraFrigorifico",
                                            !widget.product.camaraFriogorifico,
                                            "0");
                                        setState(() {
                                          widget.product.camaraFriogorifico =
                                              !widget
                                                  .product.camaraFriogorifico;
                                        });
                                      },
                                      icon: Icon(
                                          widget.product.camaraFriogorifico
                                              ? Icons.done_all_outlined
                                              : Icons.meeting_room_outlined,
                                          color: Colors.white),
                                    )),
                              ],
                            ),
                          ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  save(int idPedido, String campo, bool value, String cantidadPre) {
    Provider.of<NoteOrders>(context, listen: false)
        .changeStatus(idPedido, campo, value ? "1" : "0", cantidadPre);
    //debugger();
    //setState(() {});
  }
}
