import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/customers_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/cobros.dart' show Cobros;
import '../widgets/cobro_item.dart';

class CobrosScreen extends StatefulWidget {
  static const routeName = "./cobro";

  @override
  _CobrosScreenState createState() => _CobrosScreenState();
}

class _CobrosScreenState extends State<CobrosScreen> {
  var _searchName = "";
  late Future _cobrosFuture;

  Future _obtainCobrosFuture() {
    return Provider.of<Cobros>(context, listen: false).fetchAndSetCobro();
  }

  @override
  void initState() {
    _cobrosFuture = _obtainCobrosFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Cobros"),
        actions: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.add_box_rounded),
              tooltip: 'NUEVO COBRO',
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(CustomersScreen.routeName);
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
                future: _cobrosFuture,
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
                      return Consumer<Cobros>(
                        builder: (_, cobroData, child) => ListView.builder(
                          itemBuilder: (_, index) =>
                              CobroItem(cobroData.cobros[index], _searchName),
                          itemCount: cobroData.cobros.length,
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
