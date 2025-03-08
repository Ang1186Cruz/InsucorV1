import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../screens/products_overview_screen.dart';

class ProductEditStock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final myController = TextEditingController();
    myController.text = product.stock.toString();
    return new Column(children: <Widget>[
      new Container(
          color: product.solicitoStock
              ? Color.fromARGB(255, 233, 139, 32)
              : Colors.white,
          height: 120,
          width: MediaQuery.of(context).size.width - 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ],
          ),
          child: new ListTile(
            title: Text(product.title),
            subtitle: Text(product.description +
                "\n Stock: " +
                product.stock.toString() +
                "\n Actualizado: " +
                DateFormat("dd/MM/yyyy HH:mm")
                    .format(product.fechaUltimaStock ?? DateTime.now()) +
                "\n Usuario: " +
                product.nombreUsuario),
            leading: CircleAvatar(child: Text(product.id)),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(Icons.edit_road),
              onPressed: () {
                Alert(
                    context: context,
                    content: Column(
                      children: <Widget>[
                        TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            labelText: 'Stock',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () {
                          product.updateStock(
                              product.id, myController.text, authData.userId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Se actualizo el Stock del Producto',
                              ),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'DESHACER',
                                onPressed: () {},
                              ),
                            ),
                          );
                          Navigator.of(context).pushReplacementNamed(
                              ProductsOverviewScreen.routeName);
                        },
                        child: Text("GUARDAR"),
                      )
                    ]).show();
              },
            ),
          )),
      // new Divider(color: Colors.blue,),
    ]);
  }
}
