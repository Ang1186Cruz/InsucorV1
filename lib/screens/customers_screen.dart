import 'package:flutter/material.dart';
import 'package:flutter_shop_app/main.dart';
import 'package:flutter_shop_app/providers/carrier.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:provider/provider.dart';
import '../widgets/customers_grid.dart';

class CustomersScreen extends StatefulWidget {
  static const routeName = "./customers";

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  // Future _customersFuture;
  var _searchName = "";
  var _isInit = true;
  var _isLoading = false;
  var _isLoading2 = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
        _isLoading2 = true;
      });
      Provider.of<Customers>(context).refreshCustomer('0').then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      Provider.of<Carriers>(context).fetchAndSetCarrier().then((_) {
        setState(() {
          _isLoading2 = false;
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
          title: Text('Clientes'),
          actions: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.refresh_outlined),
                onPressed: () {
                  Provider.of<Customers>(context, listen: false)
                      .clearCustomerALL();
                  Navigator.of(context).pushNamed(CustomersScreen.routeName);
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
                  child: (_isLoading || _isLoading2)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomersGrid(_searchName)),
            ],
          ),
        ));
  }
}
