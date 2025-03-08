import 'dart:math';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import '../providers/orders.dart' as ord;
import '../screens/entrega_screen.dart';
import 'package:whatsapp/whatsapp.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  final String value;

  OrderItem(this.order, this.value);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  WhatsApp whatsapp = WhatsApp();
  var _expanded = false;
  int length = 0;

  @override
  void initState() {
    whatsapp.setup(
      accessToken:
          "EAADDo3arTVQBAOwsNmQumv4rH8SgZCsSN2F4joT4Odkcn7Yl8Hrao8l4JoEMc8GY39MxVMf4931s3FJMWgTu0BzUmbgVx8uHPbfbm8OG2NlFHiuBm0gKO24GXJWebNZBADXmDOdIDLGcyE5TF2PkKPjsGxzvnc4zZBUE7bM1ZCV5rMMy4b8DZBG8f51g5UoPBZCmdBofJ8tQZDZD",
      fromNumberId: 111582558617719,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    bool search = true;
    int cantidadTotal = 0;
    double montoTotal = 0;
    if (!(widget.value.isEmpty || widget.value == "")) {
      search =
          (widget.order.nameCustommer.toUpperCase().contains(
                widget.value.toUpperCase(),
              ) ||
              widget.order.codigo.toUpperCase().contains(
                widget.value.toUpperCase(),
              ) ||
              widget.order.transportista.toUpperCase().contains(
                widget.value.toUpperCase(),
              ));
    }
    length =
        (widget.order.products.length == 0) ? 1 : widget.order.products.length;

    for (var i = 0; i < widget.order.products.length; i++) {
      cantidadTotal += widget.order.products[i].quantity;
      montoTotal +=
          (widget.order.products[i].price * widget.order.products[i].quantity);
    }
    return search
        ? AnimatedContainer(
          duration: Duration(milliseconds: 40),
          height: _expanded ? 500 : 120,
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
                    style: TextStyle(color: Colors.blue),
                  ),
                  // visualDensity: VisualDensity(vertical: 10),
                  subtitle: Text(
                    widget.order.transportista +
                        " " +
                        DateFormat(
                          "dd/MM/yyyy HH:mm",
                        ).format(widget.order.fecha ?? DateTime.now()) +
                        "\n " +
                        NumberFormat.simpleCurrency().format(montoTotal),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Container(
                    width: 120,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more,
                          ),
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                        (auth.operation == 'entrega')
                            ? IconButton(
                              icon: Icon(Icons.done, color: Colors.blue),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  EntregaScreen.routeName,
                                  arguments: widget.order.idOrder,
                                );
                              },
                            )
                            : IconButton(
                              icon: Icon(
                                Icons.edit,
                                color:
                                    (widget.order.noCerrado == "1")
                                        ? Colors.amber
                                        : const Color.fromARGB(
                                          255,
                                          247,
                                          242,
                                          250,
                                        ),
                              ),
                              onPressed:
                                  (widget.order.noCerrado == "1")
                                      ? () {
                                        reloadCard(
                                          context,
                                          widget.order.products,
                                          widget.order,
                                        );
                                      }
                                      : null,
                            ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color:
                                (auth.operation == 'entrega')
                                    ? Colors.white
                                    : Colors.blue,
                          ),
                          onPressed: () {
                            final url =
                                "https://distribuidorainsucor.com/tuPedido.php?id=" +
                                widget.order.idOrder;
                            (auth.operation == 'entrega') ? null : null;
                            whatsapp.messagesText(
                              to: int.parse("54" + widget.order.telefono),
                              message: url,
                              previewUrl: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 50),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
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
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "CANT",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "P.U.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  height:
                      _expanded
                          ? //length * 60//((widget.order.products.length + 1) * 50.0) +20
                          min(widget.order.products.length * 80.0 + 50, 300)
                          : 0,
                  child: ListView.separated(
                    itemBuilder:
                        (_, index) => Row(
                          children: <Widget>[
                            SizedBox(height: 40),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      widget.order.products[index].title,
                                      style: TextStyle(fontSize: 10),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  ((length - 1) == index)
                                      ? Container(
                                        margin: const EdgeInsets.only(
                                          top: 30.0,
                                        ),
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
                                      "${widget.order.products[index].quantity}",
                                      style: TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ((length - 1) == index)
                                      ? Container(
                                        margin: const EdgeInsets.only(
                                          top: 40.0,
                                        ),
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
                                        widget.order.products[index].price,
                                      ),
                                      style: TextStyle(fontSize: 10),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  ((length - 1) == index)
                                      ? Container(
                                        margin: const EdgeInsets.only(
                                          top: 40.0,
                                        ),
                                        child: Text(
                                          NumberFormat.simpleCurrency().format(
                                            montoTotal,
                                          ),
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
                    separatorBuilder:
                        (context, index) =>
                            Divider(height: 1, color: Colors.blueGrey),
                    itemCount: widget.order.products.length,
                  ),
                ),
              ],
            ),
          ),
        )
        : AnimatedContainer(duration: const Duration(seconds: 1));
  }
}

void reloadCard(
  BuildContext context,
  List<CartItem> _items,
  ord.OrderItem order,
) {
  // primero limpio todo
  Provider.of<Customers>(context, listen: false).clearCustomer(order.codigo);
  Provider.of<Products>(context, listen: false).clearProducts();
  Provider.of<Cart>(context, listen: false).clearCart();
  Provider.of<Cart>(context, listen: false).addCart(_items);
  Provider.of<ord.Orders>(context, listen: false).addOrderModificad(order);

  // recargo customer Productos
  Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
}
