import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../screens/collect_screen.dart';
import '../screens/entrega_screen.dart';
import '../providers/routes.dart' as ord;
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_shop_app/screens/routes_screen.dart';

class RoutesItem extends StatefulWidget {
  final ord.RouteItem routes;
  final String value;

  RoutesItem(this.routes, this.value);

  @override
  _RoutesItemState createState() => _RoutesItemState();
}

class _RoutesItemState extends State<RoutesItem> {
  var _expanded = false;
  int length = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final customersData = Provider.of<Customers>(context);
    final customer = customersData.findByCode(widget.routes.codCli);
    bool search = true;
    if (!(widget.value.isEmpty || widget.value == "")) {
      search = (widget.routes.cliente
          .toUpperCase()
          .contains(widget.value.toUpperCase()));
    }

    return search
        ? AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: 150,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      " " + widget.routes.cliente,
                      style: TextStyle(color: Colors.blue),
                    ),
                    subtitle: Text(
                        "#Factura: " +
                            widget.routes.nroComprobante +
                            "\nImporte " +
                            NumberFormat.simpleCurrency()
                                .format(widget.routes.importe) +
                            "\nAccion : " +
                            widget.routes.accion!.replaceAll('DO', 'R'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    leading: CircleAvatar(
                        radius: 30.0, child: Text(widget.routes.codCli)),
                    trailing: Wrap(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.download_done_rounded,
                            color: Colors.blue,
                          ),
                          onPressed: (widget.routes.accion == 'NUEVO')
                              ? null
                              : () {
                                  if (widget.routes.nroComprobante == '0') {
                                    Alert(
                                        context: context,
                                        content: Column(
                                          children: <Widget>[
                                            Text(
                                                'SI YA HA REALIZADO LA ACCION CORRESPODIENTE?, POR FAVOR  PRESIONE "ACEPTAR" PARA FINALIZAR LA RUTA '),
                                          ],
                                        ),
                                        buttons: [
                                          DialogButton(
                                            onPressed: () {
                                              ord.Routes.UpdateRoute(
                                                  widget.routes.id);
                                              Navigator.of(context)
                                                  .pushReplacementNamed('/');
                                            },
                                            child: Text("ACEPTAR"),
                                          )
                                        ]).show();
                                  } else {
                                    auth.setIdRuta(widget.routes.id);
                                    if (widget.routes.accion == 'ENTREGADO') {
                                      Navigator.of(context).pushNamed(
                                          EntregaScreen.routeName,
                                          arguments: widget.routes.idPedido);
                                    } else {
                                      customer.isAgregate = true;
                                      Provider.of<Customers>(context,
                                              listen: false)
                                          .addCustommer(
                                              customer.id,
                                              customer.nombre,
                                              customer.direccion,
                                              customer.idLista,
                                              customer.code,
                                              customer.empresa);
                                      Navigator.of(context).pushNamed(
                                          CollectScreen.routeName,
                                          arguments:
                                              widget.routes.nroComprobante);
                                    }
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : AnimatedContainer(duration: const Duration(seconds: 1));
  }
}
