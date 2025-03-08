import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import '../main.dart';
import '../providers/routes.dart';
import 'package:provider/provider.dart';
import '../widgets/routes_item.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/customers.dart';

class RoutesScreen extends StatefulWidget {
  static const routeName = "./routes";

  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  var _searchName = "";
  late Future _routersFuture;
  var _isLoading = false;
  var _isInit = true;

  Future _obtainRoutersFuture() {
    return Provider.of<Routes>(context, listen: false).refreshRiuter();
  }

  @override
  void initState() {
    _routersFuture = _obtainRoutersFuture();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Customers>(context, listen: false).refreshCustomer('0');
      Provider.of<Orders>(context).fetchAndSetOrderFacturado().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mis Rutas Asignadas'),
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
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : FutureBuilder(
                        future: _routersFuture,
                        builder: (_, dataSnapshot) {
                          if (dataSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (dataSnapshot.error != null) {
                              return Center(
                                child: Text('No tiene rutas asignadas!',
                                    style: TextStyle(color: Colors.white)),
                              );
                            } else {
                              return Consumer<Routes>(
                                builder: (_, routerData, child) =>
                                    ListView.builder(
                                  itemBuilder: (_, index) => RoutesItem(
                                      routerData.routers[index], _searchName),
                                  itemCount: routerData.routers.length,
                                ),
                              );
                            }
                          }
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}
