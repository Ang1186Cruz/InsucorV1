import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/carrier.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final customer = Provider.of<Customers>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Mis Pedidos'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (customer.customerActive != null)
                  ? Text(
                      "Cliente: " +
                          customer.customerActive!.nombre +
                          "\nDirección: " +
                          customer.customerActive!.direccion,
                      style: TextStyle(fontSize: 20, color: Colors.white))
                  : Text("PRIMERO DEBE SELECCIONAR UN CLIENTE",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Card(
              margin: EdgeInsets.all(15),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleLarge!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => CartItem(
                    cart.items.values.toList()[index].id,
                    cart.items.keys.toList()[index],
                    cart.items.values.toList()[index].price,
                    cart.items.values.toList()[index].quantity,
                    cart.items.values.toList()[index].title,
                    cart.items.values.toList()[index].priceRequested ?? 0),
                itemCount: cart.items.length,
              ),
            ),
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  late OrderItem orderEnviar;
  var _isLoading = false;
  var buttonEnabled = "0";
  final myControllerDate = TextEditingController();
  final myControllerObservacion = TextEditingController();
  bool isUserNameValidate = false;
  bool isFirst = true;
  // int _value = 1;
  // String _modo = "A";

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<Customers>(context);
    final product = Provider.of<Products>(context);
    final order = Provider.of<Orders>(context);
    final carrier = Provider.of<Carriers>(context);
    final today = DateTime.now();
    //
    if (isFirst) {
      orderEnviar = order.getActivated();
      isFirst = false;
    }
    //
    return TextButton(
        child:
            _isLoading ? CircularProgressIndicator() : Text("FINALIZAR ORDEN"),
        onPressed: (widget.cart.totalAmount <= 0 ||
                _isLoading ||
                customer.customerActive == null)
            ? null
            : () {
                Alert(
                    context: context,
                    content: Column(
                      children: <Widget>[
                        DropdownButtonFormField(
                          value: orderEnviar.modo,
                          isExpanded: true,
                          decoration: InputDecoration(labelText: "Modo"),
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                              child: Text("A"),
                              value: "A",
                            ),
                            DropdownMenuItem(
                              child: Text("B"),
                              value: "B",
                            )
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              orderEnviar.modo = value ?? '';
                            });
                          },
                        ),

                        DropdownButtonFormField(
                          disabledHint:
                              Text(orderEnviar.idTransportista.toString()),
                          value: orderEnviar.idTransportista,
                          // hint: Text(
                          //   'SELECCIONE LA FACTURA A COBRAR',
                          // ),
                          isExpanded: true,
                          decoration:
                              InputDecoration(labelText: "Transportista"),

                          onChanged: (int? value) {
                            setState(() {
                              orderEnviar.idTransportista = value ?? 0;
                            });
                          },

                          items: carrier.items.map((CarrierOne val) {
                            return DropdownMenuItem(
                              value: val.id,
                              child: Text(
                                val.nombre,
                              ),
                            );
                          }).toList(),
                        ),

                        // DropdownButtonFormField(
                        //   value: orderEnviar.idTransportista,
                        //   isExpanded: true,
                        //   decoration:
                        //       InputDecoration(labelText: "Transportista"),
                        //   items: <DropdownMenuItem<int>>[
                        //     DropdownMenuItem(
                        //       child: Text("Mostrador"),
                        //       value: 1,
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text("Astrada Armando"),
                        //       value: 4,
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text("Echenique Juan"),
                        //       value: 8,
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text("Sciutto Mauro"),
                        //       value: 9,
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text("Cisneros Leonardo"),
                        //       value: 12,
                        //     ),
                        //     DropdownMenuItem(
                        //       child: Text("Miranda Nicolas"),
                        //       value: 14,
                        //     )
                        //   ],
                        //   onChanged: (int value) {
                        //     setState(() {
                        //       orderEnviar.idTransportista = value;
                        //     });
                        //   },
                        //   hint: Text("SELECCIONE TRANSPORTISTA"),
                        //   // value: _value,
                        // ),

                        TextField(
                            controller: myControllerDate,
                            decoration: InputDecoration(
                                labelText: "Fecha Entrega",
                                errorText: isUserNameValidate
                                    ? 'por favor ingrese la fecha de entrega'
                                    : null //label text of field
                                ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  locale: const Locale("es", "ES"),
                                  initialDate: (DateTime.now().hour <= 15)
                                      ? today.add(const Duration(days: 1))
                                      : today.add(const Duration(days: 2)),
                                  firstDate: (DateTime.now().hour <= 15)
                                      ? today.add(const Duration(days: 1))
                                      : today.add(const Duration(days: 2)),
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(pickedDate);
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate);
                                setState(() {
                                  isUserNameValidate = false;
                                  myControllerDate.text = formattedDate;
                                });
                              } else {
                                isUserNameValidate = true;
                                print("Date is not selected");
                              }
                            }),
                        TextField(
                          controller: myControllerObservacion,
                          decoration: InputDecoration(
                            labelText: 'Observación',
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 1,
                          maxLines: 5,
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          if (buttonEnabled == "0") {
                            if (myControllerDate.text.isNotEmpty) {
                              buttonEnabled = "1";
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(
                                      orderEnviar.idOrder,
                                      widget.cart.items.values.toList(),
                                      widget.cart.totalAmount,
                                      int.parse(customer.customerActive!.id),
                                      orderEnviar.idTransportista,
                                      myControllerDate.text,
                                      myControllerObservacion.text,
                                      orderEnviar.modo);
                              setState(() {
                                _isLoading = false;
                              });
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "EXITOSO!!",
                                desc:
                                    "Los pedidos se almacenarón de forma exitosa!!",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Aceptar",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      widget.cart.clearCart();
                                      customer.clearCustomer("");
                                      product.clearProducts();
                                      Navigator.of(context)
                                          .pushReplacementNamed('/');
                                    },
                                    width: 120,
                                  )
                                ],
                              ).show();
                            } else {
                              setState(() {
                                isUserNameValidate = true;
                                _isLoading = true;
                              });
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Error",
                                desc:
                                    "Debe ingresar una fecha antes de continuar.",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Aceptar",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                  )
                                ],
                              ).show();
                            }
                          } else {
                            return null;
                          }
                        },
                        child: Text("ACEPTAR "),
                      )
                    ]).show();
              });
  }
}
