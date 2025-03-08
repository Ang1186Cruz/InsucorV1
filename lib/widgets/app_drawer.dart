import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/customers_screen.dart';
import 'package:flutter_shop_app/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_shop_app/screens/delivery_screen.dart';
import 'package:flutter_shop_app/screens/cobro_screen.dart';
import 'package:flutter_shop_app/screens/main_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/routes_screen.dart';
import '../providers/auth.dart';
import '../screens/note_orders_screen.dart';
import '../screens/orders_screen.dart';
import 'package:provider/provider.dart';

import '../screens/productCalendar.dart';
import '../screens/spend_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //child: Column(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          AppBar(
            title: Text("Menú"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.menu_open),
            title: Text("Inicio"),
            onTap: () {
              limpiar(context);
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Clientes"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false).setOperacion('pedido');
              Navigator.of(context)
                  .pushReplacementNamed(CustomersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.work),
            title: Text("Rutas"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false).setOperacion('ruta');
              Navigator.of(context)
                  .pushReplacementNamed(RoutesScreen.routeName);
              //Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Stock"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false)
                  .setOperacion('Productos');
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Ordenes"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false).setOperacion('pedido');
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.car_repair),
            title: Text("Entrega"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false).setOperacion('entrega');
              Navigator.of(context)
                  .pushReplacementNamed(DeliverysScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text("Cobro"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false).setOperacion('cobro');
              Navigator.of(context)
                  .pushReplacementNamed(CobrosScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.money),
            title: Text("Gasto"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false).setOperacion('gasto');
              Navigator.of(context).pushReplacementNamed(SpendScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.view_list_outlined),
            title: Text("Nota Pedidos"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false)
                  .setOperacion('notaPedido');
              Navigator.of(context)
                  .pushReplacementNamed(NoteOrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.view_list_outlined),
            title: Text("Calendario Productos"),
            onTap: () {
              limpiar(context);
              Provider.of<Auth>(context, listen: false)
                  .setOperacion('calendarioProductos');
              Navigator.of(context)
                  .pushReplacementNamed(ProductCalendarScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Salir"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
              Provider.of<Customers>(context, listen: false).clearCustomer("");
              Provider.of<Products>(context, listen: false).clearProducts();
              Provider.of<Cart>(context, listen: false).clearCart();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider()
        ],
      ),
    );
  }

  void limpiar(BuildContext context) {
    Provider.of<Customers>(context, listen: false).clearCustomer("");
    Provider.of<Cart>(context, listen: false).clearCart();
    Provider.of<Products>(context, listen: false).clearProducts();
  }
}
