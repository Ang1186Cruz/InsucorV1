import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/note_orders.dart';
import 'package:flutter_shop_app/providers/auth.dart';

import '../widgets/note_order_item.dart';

class NoteOrdersDetailsScreen extends StatefulWidget {
  final DateTime fechaEntrega;

  NoteOrdersDetailsScreen(this.fechaEntrega);
  @override
  _NoteOrdersDetailsState createState() => _NoteOrdersDetailsState();
}

class _NoteOrdersDetailsState extends State<NoteOrdersDetailsScreen> {
  var _searchName = "";
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<NoteOrders>(context, listen: false)
        .fetchAndSetOrderDetails(widget.fechaEntrega);
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Preparar Pedidos"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Esto cierra la pantalla actual y regresa a la anterior
          },
        ),
      ),
      //drawer: AppDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchName = value;
                  });
                },
                decoration: MyApp().inputDecorationCustom(),
              ),
            ),
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
                        builder: (_, orderData, child) => ListView.builder(
                          itemBuilder: (_, index) => NotesOrderItem(
                              orderData.noteOrders[index], _searchName),
                          itemCount: orderData.noteOrders.length,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
