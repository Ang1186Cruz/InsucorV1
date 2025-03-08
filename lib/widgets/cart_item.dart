import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final double priceRequested;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      this.priceRequested);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final products = Provider.of<Products>(context, listen: false);
    final myController = TextEditingController();
    final myControllerSolicitado = TextEditingController();

    myController.text = quantity.toString();
    myControllerSolicitado.text = priceRequested.toString();
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (innerContext) => AlertDialog(
            title: Text('Esta Seguro!'),
            content: Text('¿Quieres eliminar el artículo del carrito?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(innerContext).pop(false);
                },
              ),
              TextButton(
                child: Text("Si"),
                onPressed: () {
                  Navigator.of(innerContext).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        products.removeIsAgregate(productId);
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: FittedBox(
                child: Text("\$$price"),
              ),
            )),
            title: Text(title),
            subtitle: Text("Cantidad: " +
                quantity.toString() +
                "\nTotal: \$${(price * quantity)}"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              //////////////////////////////////////////////////////////////////////////
              onPressed: () {
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
                        onPressed: () {
                          cart.addItem(
                              productId,
                              price,
                              title,
                              myController.text,
                              myControllerSolicitado.text,
                              0);
                          Navigator.pop(context);
                        },
                        child: Text("EDIT"),
                      )
                    ]).show();
              },
              //////////////////////////////////////////////////////////////////////////
              color: Theme.of(context).primaryColor,
            ), //Text("$quantity x"),
            contentPadding: EdgeInsets.all(10.0),
          ),
        ),
      ),
    );
  }
}
