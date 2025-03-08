import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/carrier.dart';
import '../providers/customers.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import 'package:flutter_shop_app/providers/auth.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "./orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _searchName = "";
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    Provider.of<Customers>(context).refreshCustomer('0').then((_) {
      setState(() {});
    });
    Provider.of<Carriers>(context).fetchAndSetCarrier().then((_) {
      setState(() {});
    });

    final auth = Provider.of<Auth>(context, listen: false);

    if (auth.operation == 'entrega') {
      return Provider.of<Orders>(context, listen: false)
          .fetchAndSetOrderFacturado();
    } else {
      return Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
    }
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
        title: (auth.operation == 'entrega')
            ? Text("Mis Ordenes Facturadas")
            : Text("Mis Ordenes"),
      ),
      drawer: AppDrawer(),
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
                      return Consumer<Orders>(
                        builder: (_, orderData, child) => ListView.builder(
                          itemBuilder: (_, index) =>
                              OrderItem(orderData.orders[index], _searchName),
                          itemCount: orderData.orders.length,
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
