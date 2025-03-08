import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:flutter_shop_app/providers/deliverys.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/providers/message.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_shop_app/providers/auth.dart';

class EntregaScreen extends StatefulWidget {
  static const routeName = '/entrega';
  @override
  _EntregaScreenState createState() => _EntregaScreenState();
}

List<DropdownMenuItem<String>> get motivosDropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("COMPLETO"), value: "completo"),
    DropdownMenuItem(child: Text("PENDIENTE"), value: "pendiente"),
    DropdownMenuItem(child: Text("NO CARGADO"), value: "nocargado"),
    DropdownMenuItem(child: Text("VENCIDO"), value: "vencido"),
    DropdownMenuItem(child: Text("ROTO"), value: "roto"),
  ];
  return menuItems;
}

class _EntregaScreenState extends State<EntregaScreen> {
  var _isInit = true;
  var _isLoading = false;
  late Timer _timer;
  int _time = 0;
  String _motivo = "completo";
  late DateTime fechaInicio;
  late DateTime fechafin;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final idOrder = ModalRoute.of(context)?.settings.arguments as String;
      Provider.of<Orders>(context, listen: false).activateOrder(idOrder);
      setState(() {
        _isLoading = false;
        _time = 0;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController cantidadC = new TextEditingController();
  TextEditingController comentarioC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final orderActivate =
        Provider.of<Orders>(context, listen: false).getActivated();
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.amber,
          title: new Text('Entrega'),
          actions: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                tooltip: 'VOLVER',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        body: new SingleChildScrollView(
          child: new Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Form(
                key: keyForm,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(15))),
                          // color: Colors.redAccent,
                          // padding: EdgeInsets.all(15),
                          child: _isLoading
                              ? Text("Entregando..")
                              : Text("INICIAR ENTREGA"),
                          onPressed: _isLoading
                              ? () {}
                              : () {
                                  setState(() {
                                    _isLoading = true;
                                    fechaInicio = DateTime.now();
                                    startTimer();
                                  });
                                },
                        ),
                        Padding(padding: const EdgeInsets.all(8.0)),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.greenAccent),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(15))),
                          // color: Colors.greenAccent,
                          // padding: EdgeInsets.all(15),
                          child: Text("FINALIZAR ENTREGA"),
                          onPressed: () async {
                            _timer.cancel();
                            fechafin = DateTime.now();
                            save(orderActivate);
                          },
                        ),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Title(
                        color: Colors.amber,
                        child: Text(
                          "(" +
                              orderActivate.codigo +
                              ") " +
                              orderActivate.nameCustommer,
                          //+ customers.customerActive.nombre,
                          style: TextStyle(color: Colors.black),
                        )),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 50),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      height: 25,
                      child: Row(
                        children: <Widget>[
                          SizedBox(height: 40),
                          Expanded(
                              child: Text(
                            "PRODUCTO",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            textAlign: TextAlign.left,
                          )),
                          Expanded(
                              child: Text(
                            "CANT",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                              child: Text(
                            "P.U.",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                              child: Text(
                            "ACCION",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            textAlign: TextAlign.center,
                          )),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height:
                          min(orderActivate.products.length * 180.0 + 50, 500),
                      child: ListView.separated(
                        itemBuilder: (_, index) => Row(
                          children: <Widget>[
                            SizedBox(height: 40),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                      child: Text(
                                    orderActivate.products[index].title,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                      child: Text(
                                    "${orderActivate.products[index].quantity}",
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                      child: Text(
                                    NumberFormat.simpleCurrency().format(
                                        orderActivate.products[index].price),
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.right,
                                  )),
                                ],
                              ),
                            ),
                            Expanded(
                                child: _isLoading
                                    ? Row(children: <Widget>[
                                        IconButton(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          icon: Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              orderActivate
                                                  .products[index].todo = true;
                                            });
                                          },
                                        ),
                                        orderActivate.products[index].todo
                                            ? IconButton(
                                                onPressed: () {},
                                                icon: SizedBox())
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  cantidadC.text = orderActivate
                                                      .products[index].quantity
                                                      .toString();
                                                  Alert(
                                                      context: context,
                                                      content: Column(
                                                        children: <Widget>[
                                                          TextField(
                                                            controller:
                                                                cantidadC,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Cantidad',
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                          ),
                                                          DropdownButtonFormField(
                                                            isExpanded: true,
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        "Motivo"),
                                                            value: orderActivate
                                                                .products[index]
                                                                .motivo,
                                                            items:
                                                                motivosDropdownItems,
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _motivo =
                                                                    value ?? '';
                                                              });
                                                            },
                                                          ),
                                                          TextField(
                                                            controller:
                                                                comentarioC,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Descripcion',
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .newline,
                                                            minLines: 1,
                                                            maxLines: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      buttons: [
                                                        DialogButton(
                                                          onPressed: () {
                                                            orderActivate
                                                                    .products[index]
                                                                    .quantity =
                                                                int.parse(
                                                                    cantidadC
                                                                        .text);
                                                            int.parse(
                                                                cantidadC.text);
                                                            orderActivate
                                                                    .products[index]
                                                                    .descripcion =
                                                                comentarioC
                                                                    .text;
                                                            orderActivate
                                                                .products[index]
                                                                .motivo = _motivo;
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("EDITAR"),
                                                        )
                                                      ]).show();
                                                },
                                              ),
                                      ])
                                    : IconButton(
                                        onPressed: () {}, icon: SizedBox())),
                          ],
                        ),
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.blueGrey),
                        itemCount: orderActivate.products.length,
                      ),
                    ),
                    _isLoading ? formFooter(orderActivate) : Text(" "),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(minutes: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        _time++;
      },
    );
  }

  formItemsDesign(item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Card(child: ListTile(title: item)),
    );
  }

  Widget formFooter(OrderItem orderActive) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              setState(() {
                for (var i = 0; i < orderActive.products.length; i++) {
                  orderActive.products[i].todo = true;
                }
              });

              //  save(orderActive);
            },
            child: Container(
              margin: new EdgeInsets.all(30.0),
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                gradient: LinearGradient(colors: [
                  Color(0xFFFBC02D),
                  Color(0xFFF9A825),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Text("TODO ENTREGADO",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              padding: EdgeInsets.only(top: 16, bottom: 16),
            ))
      ],
    );
  }

  String validateName(String value) {
    if (value.length == 0 || value == '0') {
      return "El Campo es requerido";
    }
    return '';
  }

  save(OrderItem orderr) async {
    final auth = Provider.of<Auth>(context, listen: false);
    bool validar = false;
    for (var i = 0; i < orderr.products.length; i++) {
      if (orderr.products[i].todo == true) {
        validar = true;
      }
    }

    if (validar) {
      await Provider.of<Deliverys>(context, listen: false).addDelivery(
          _time,
          fechaInicio,
          fechafin,
          orderr,
          ((auth.operation == 'ruta') ? auth.IdRuta : ''));
      setState(() {
        _isLoading = false;
      });

      Alert(
        context: context,
        type: AlertType.success,
        title: "EXITOSO!!",
        desc: "La Entrega se hizo de forma exitosa!!",
        buttons: [
          DialogButton(
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Orders>(context, listen: false).clearOrderActive();
              Provider.of<Customers>(context, listen: false).clearCustomer("");
              Provider.of<Products>(context, listen: false).clearProducts();

              Navigator.of(context).pushReplacementNamed('/');
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      MessageWidget.error(context, "DEBE SELECCIONAR AL MENOR UN PRODUCTO", 7);
    }
  }
}
