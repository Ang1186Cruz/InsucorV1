import 'package:flutter/cupertino.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/product.dart';
//import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final myController = TextEditingController();
    final myControllerSolicitado = TextEditingController();
    myControllerSolicitado.text = product.price.toString();
    return new Column(children: <Widget>[
      new Container(
          color: product.recent
              ? Color.fromARGB(255, 245, 239, 214)
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
                "\n Precio: " +
                NumberFormat.simpleCurrency().format(product.price)),
            leading: CircleAvatar(child: Text(product.id)),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,

              icon: Icon(product.isAgregate ? Icons.done : Icons.shopping_cart),
              // onPressed: (product.isAgregate || cart.nombreCustommer ==null )
              onPressed: product.isAgregate
                  ? null
                  : () {
                      Alert(
                          context: context,
                          content: Column(
                            children: <Widget>[
                              TextField(
                                controller: myController,
                                decoration: InputDecoration(
                                  labelText: 'Cantidad',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              TextField(
                                controller: myControllerSolicitado,
                                decoration: InputDecoration(
                                  labelText: 'Precio Solicitado',
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: false,
                                ),
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              //onPressed: () => Navigator.pop(context),
                              onPressed: () {
                                cart.addItem(
                                    product.id,
                                    product.price,
                                    product.description,
                                    myController.text,
                                    myControllerSolicitado.text,
                                    0);
                                product.toggleAgregate(
                                    authData.token, authData.userId);
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'El Producto fue agregado a su Carro!',
                                    ),
                                    duration: Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'DESHACER',
                                      onPressed: () {
                                        cart.removeSingleItem(product.id);
                                      },
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text("ADD"
                                  //style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                            )
                          ]).show();
                    },
            ),
          )),
      // new Divider(color: Colors.blue,),
    ]);
  }
}
