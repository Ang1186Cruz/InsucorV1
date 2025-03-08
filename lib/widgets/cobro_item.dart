import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/cobros.dart' as ord;

class CobroItem extends StatefulWidget {
  final ord.CobroItem cobro;
  final String value;

  CobroItem(this.cobro, this.value);

  @override
  _CobroItemState createState() => _CobroItemState();
}

class _CobroItemState extends State<CobroItem> {
  var _expanded = false;
  int length = 0;

  @override
  Widget build(BuildContext context) {
    bool search = true;
    if (!(widget.value.isEmpty || widget.value == "")) {
      search = (widget.cobro.nombre!
          .toUpperCase()
          .contains(widget.value.toUpperCase()));
    }

    return search
        ? AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: 130,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "(${widget.cobro.noFactura ?? ''}) ${widget.cobro.nombre ?? ''}",
                    ),
                    subtitle: Text("Fecha Cobro: " +
                        DateFormat("dd/MM/yyyy")
                            .format(widget.cobro.fechaCobro ?? DateTime.now()) +
                        "\nTotal Efectivo.: " +
                        NumberFormat.simpleCurrency()
                            .format(widget.cobro.totalEfectivo) +
                        "\nTotal Cheques: " +
                        NumberFormat.simpleCurrency()
                            .format(widget.cobro.totalCheque) +
                        "\nEntrega Total : " +
                        NumberFormat.simpleCurrency()
                            .format(widget.cobro.totalRecibido)),
                  ),
                ],
              ),
            ),
          )
        : AnimatedContainer(duration: const Duration(seconds: 1));
  }
}
