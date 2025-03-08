import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/note_orders.dart';
import 'package:flutter_shop_app/providers/auth.dart';

import '../widgets/note_order_item.dart';
import 'note_order_details_screen .dart';

class NoteOrdersScreen extends StatefulWidget {
  static const routeName = "./noteOrders";

  @override
  _NoteOrdersScreenState createState() => _NoteOrdersScreenState();
}

class _NoteOrdersScreenState extends State<NoteOrdersScreen> {
  var _searchName = "";
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<NoteOrders>(context, listen: false).fetchAndSetOrder();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pedidos'),
      ),
      drawer: AppDrawer(),
      body: Container(
          child: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: _ordersFuture,
            builder: (_, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('Ha ocurrido un error!'),
                  );
                } else {
                  return Consumer<NoteOrders>(
                    builder: (_, orderData, child) => ListView.separated(
                      itemBuilder: (_, index) {
                        final order = orderData.NoteOrderGroupeds[index];
                        return ListTile(
                          tileColor:
                              Colors.white, // Color de fondo del ListTile
                          selectedTileColor: Colors.blue,
                          title: Text("(" +
                              DateFormat("dd/MM/yyyy").format(
                                  order.fechaEntrega ?? DateTime.now()) +
                              ")  (" +
                              NumberFormat.simpleCurrency()
                                  .format(order.importe) +
                              ")  (" +
                              order.cantidad.toString() +
                              " rutas)"), // Ajusta según tu modelo
                          subtitle: Text("-----------------------------"),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NoteOrdersDetailsScreen(
                                    orderData.NoteOrderGroupeds[index]
                                            .fechaEntrega ??
                                        DateTime.now()),
                              ),
                            );
                          },
                        );
                      },
                      itemCount: orderData.NoteOrderGroupeds.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.blueGrey, // Color del separador
                        height: 1,
                        // thickness: 1,       // Grosor del separador
                        // indent: 16,         // Sangría desde la izquierda
                        // endIndent: 16,      // Sangría desde la derecha
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ])),
      // body: ListView.builder(
      //   itemCount: _ordersFuture.length,  // Tamaño de la lista
      //   itemBuilder: (ctx, index) {
      //     return ListTile(
      //       leading: Icon(Icons.shopping_cart),
      //       title: Text(_ordersFuture[index] ),  // Mostrar el nombre del pedido
      //       onTap: () {
      //         // Aquí puedes navegar a los detalles del pedido si lo deseas
      //         Navigator.of(context).push(
      //           MaterialPageRoute(
      //             builder: (context) => OrderDetailsScreen(orders[index]),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );

    // final auth = Provider.of<Auth>(context, listen: false);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Preparar Pedidos"),
    //   ),
    //   drawer: AppDrawer(),
    //   body: Container(
    //     child: Column(
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: TextField(
    //             style: TextStyle(color: Colors.white),
    //             onChanged: (value) {
    //               setState(() {
    //                 _searchName = value;
    //               });
    //             },
    //             decoration: MyApp().inputDecorationCustom(),
    //           ),
    //         ),
    //         Expanded(
    //           child: FutureBuilder(
    //             future: _ordersFuture,
    //             builder: (_, dataSnapshot) {
    //               if (dataSnapshot.connectionState == ConnectionState.waiting) {
    //                 return Center(
    //                   child: CircularProgressIndicator(),
    //                 );
    //               } else {
    //                 if (dataSnapshot.error != null) {
    //                   return Center(
    //                     child: Text('Ha ocurrido un error!'),
    //                   );
    //                 } else {
    //                   return Consumer<NoteOrders>(
    //                     builder: (_, orderData, child) => ListView.builder(
    //                       itemBuilder: (_, index) => NotesOrderItem(
    //                           orderData.noteOrders[index], _searchName),
    //                       itemCount: orderData.noteOrders.length,
    //                     ),
    //                   );
    //                 }
    //               }
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
