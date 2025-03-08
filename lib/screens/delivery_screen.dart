import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../screens/orders_screen.dart';
import '../providers/deliverys.dart' show Deliverys;
import '../widgets/delivery_item.dart';

class DeliverysScreen extends StatefulWidget {
  static const routeName = "./delivery";

  @override
  _DeliverysScreenState createState() => _DeliverysScreenState();
}

class _DeliverysScreenState extends State<DeliverysScreen> {
  var _searchName = "";
  late Future _deliverysFuture;

  Future _obtainDeliverysFuture() {
    return Provider.of<Deliverys>(context, listen: false).fetchAndSetDelivery();
  }

  @override
  void initState() {
    _deliverysFuture = _obtainDeliverysFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Entregas"),
        actions: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.add_box_rounded),
              tooltip: 'NUEVA ENTREGA',
              onPressed: () {
                Navigator.of(context).pushNamed(OrdersScreen.routeName);
              },
            ),
          ),
        ],
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
                future: _deliverysFuture,
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
                      return Consumer<Deliverys>(
                        builder: (_, deliveryData, child) => ListView.builder(
                          itemBuilder: (_, index) => DeliveryItem(
                              deliveryData.deliverys[index], _searchName),
                          itemCount: deliveryData.deliverys.length,
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
