import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../providers/cobros.dart' show Cobros;
import 'package:flutter_shop_app/providers/auth.dart';

class CollectScreen extends StatefulWidget {
  static const routeName = '/collect';
  @override
  _CollectScreenState createState() => _CollectScreenState();
}

class _CollectScreenState extends State<CollectScreen> {
  var _isInit = true;
  var _isLoading = false;
  var nroComprobante = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      nroComprobante = ModalRoute.of(context)?.settings.arguments as String;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController eveinteMil = new TextEditingController();
  TextEditingController ediezMil = new TextEditingController();
  TextEditingController edosMil = new TextEditingController();
  TextEditingController eMil = new TextEditingController();
  TextEditingController eQuinientos = new TextEditingController();
  TextEditingController eDocientos = new TextEditingController();
  TextEditingController eCien = new TextEditingController();
  TextEditingController eCincuenta = new TextEditingController();
  TextEditingController eVeinte = new TextEditingController();
  TextEditingController eDiez = new TextEditingController();
  TextEditingController numero1 = new TextEditingController();
  TextEditingController importe1 = new TextEditingController();
  TextEditingController numero2 = new TextEditingController();
  TextEditingController importe2 = new TextEditingController();
  TextEditingController numero3 = new TextEditingController();
  TextEditingController importe3 = new TextEditingController();
  TextEditingController numero4 = new TextEditingController();
  TextEditingController importe4 = new TextEditingController();
  TextEditingController numero5 = new TextEditingController();
  TextEditingController importe5 = new TextEditingController();
  TextEditingController numero6 = new TextEditingController();
  TextEditingController importe6 = new TextEditingController();
  TextEditingController comentario = new TextEditingController();

  TextEditingController iDolar = new TextEditingController();
  TextEditingController iRecibido = new TextEditingController();
  TextEditingController tEfectivo = new TextEditingController();
  TextEditingController tCheque = new TextEditingController();
  TextEditingController tRecibido = new TextEditingController();
  bool notControl = false;
  String _numFactura = "";

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<Customers>(context, listen: false);
    if (this.nroComprobante != '') {
      _numFactura = nroComprobante;
    } else {
      if (customers.customerActive != null) {
        _numFactura = customers.customerActive!.facturadropdownItems.first;
      }
    }
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blue,
          title: new Text('Cobro'),
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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Form(
                        key: keyForm,
                        child: Column(
                          children: [
                            Title(
                                color: Colors.amber,
                                child: Text(
                                  "Nombre Cliente \n" +
                                      customers.customerActive!.nombre,
                                  style: TextStyle(color: Colors.black),
                                )),
                            formItemsDesign(
                              DropdownButtonFormField(
                                disabledHint: Text(_numFactura),
                                value: _numFactura,
                                isExpanded: true,
                                onChanged: (this.nroComprobante != '')
                                    ? null
                                    : (String? value) {
                                        setState(() {
                                          _numFactura = value ?? '';
                                        });
                                      },
                                items: customers
                                    .customerActive!.facturadropdownItems
                                    .map((String val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(
                                      val,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: new Column(
                                    children: <Widget>[
                                      new Text("EFECTIVO ",
                                          textAlign: TextAlign.center),
                                      formEfectivo(),
                                    ],
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.all(8.0)),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: new Column(
                                    children: <Widget>[
                                      new Text("CHEQUES ",
                                          textAlign: TextAlign.center),
                                      formUIcheques(numero1, importe1),
                                      formUIcheques(numero2, importe2),
                                      formUIcheques(numero3, importe3),
                                      formUIcheques(numero4, importe4),
                                      formUIcheques(numero5, importe5),
                                      formUIcheques(numero6, importe6),
                                      TextField(
                                        controller: comentario,
                                        decoration: InputDecoration(
                                          labelText: 'COMENTARIO',
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        textInputAction:
                                            TextInputAction.newline,
                                        minLines: 1,
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            formFooter(),
                          ],
                        ),
                      ),
                    )
              //     }
              // }
              ),
        ),
      ),
    );
  }

  formItemsDesign(item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Card(child: ListTile(title: item)),
    );
  }

  Widget formFooter() {
    return Column(
      children: <Widget>[
        formItemsDesign(TextFormField(
            decoration: InputDecoration(labelText: "Importe en Dolar"),
            controller: iDolar,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            })),
        formItemsDesign(TextFormField(
            decoration: InputDecoration(labelText: "Importe Recibido"),
            controller: iRecibido,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            })),
        formItemsDesign(TextFormField(
          readOnly: true,
          decoration: InputDecoration(labelText: "Total Efectivo"),
          controller: tEfectivo,
        )),
        formItemsDesign(TextFormField(
          readOnly: true,
          decoration: InputDecoration(labelText: "Total Cheques"),
          controller: tCheque,
        )),
        formItemsDesign(TextFormField(
          readOnly: true,
          decoration: InputDecoration(labelText: "Total Recibido"),
          controller: tRecibido,
          validator: validateName,
        )),
        formItemsDesign(CheckboxListTile(
          title: Text('MONTO NO CONTROLADO'),
          value: notControl,
          onChanged: (bool? newValue) {
            setState(() {
              notControl = newValue ?? false;
            });
          },
        )),
        GestureDetector(
            onTap: () {
              save();
            },
            child: Container(
              margin: new EdgeInsets.all(30.0),
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                gradient: LinearGradient(colors: [
                  Colors.blue
                  // Color.fromARGB(255, 45, 144, 251),
                  // Color(0xFFF9A825),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Text("Guardar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              padding: EdgeInsets.only(top: 16, bottom: 16),
            ))
      ],
    );
  }

  Widget formEfectivo() {
    return Column(
      children: <Widget>[
        TextField(
            decoration: InputDecoration(labelText: "\$ 20000"),
            controller: eveinteMil,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextField(
            decoration: InputDecoration(labelText: "\$ 10000"),
            controller: ediezMil,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextField(
            decoration: InputDecoration(labelText: "\$ 2000"),
            controller: edosMil,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextField(
            decoration: InputDecoration(labelText: "\$ 1000"),
            controller: eMil,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextFormField(
            decoration: InputDecoration(labelText: "\$ 500"),
            controller: eQuinientos,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextFormField(
            decoration: InputDecoration(labelText: "\$ 200"),
            controller: eDocientos,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextFormField(
            decoration: InputDecoration(labelText: "\$ 100"),
            controller: eCien,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextFormField(
            decoration: InputDecoration(labelText: "\$ 50"),
            controller: eCincuenta,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextFormField(
            decoration: InputDecoration(labelText: "\$ 20"),
            controller: eVeinte,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
        TextFormField(
            decoration: InputDecoration(labelText: "\$ 10"),
            controller: eDiez,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (String value) {
              setState(() {
                recalcularEfectivo();
              });
            }),
      ],
    );
  }

  Widget formUIcheques(numero, importe) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: "número"),
            controller: numero,
            keyboardType: TextInputType.number,
          ),
        ),
        Expanded(
          child: TextFormField(
              decoration: InputDecoration(labelText: "importe"),
              controller: importe,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  try {
                    final text = newValue.text;
                    if (text.isNotEmpty) double.parse(text);
                    return newValue;
                  } catch (e) {}
                  return oldValue;
                }),
              ],
              onChanged: (String value) {
                setState(() {
                  recalculareCheque();
                });
              }),
        ),
      ],
    );
  }

  void recalcularEfectivo() {
    if (iRecibido.text.isNotEmpty && iRecibido.text != '0') {
      tEfectivo.text = iRecibido.text;
    } else {
      tEfectivo
          .text = (int.parse(eveinteMil.text.isEmpty ? '0' : eveinteMil.text) *
                  20000 +
              int.parse(ediezMil.text.isEmpty ? '0' : ediezMil.text) * 10000 +
              int.parse(edosMil.text.isEmpty ? '0' : edosMil.text) * 2000 +
              int.parse(eMil.text.isEmpty ? '0' : eMil.text) * 1000 +
              int.parse(eQuinientos.text.isEmpty ? '0' : eQuinientos.text) *
                  500 +
              int.parse(eDocientos.text.isEmpty ? '0' : eDocientos.text) * 200 +
              int.parse(eCien.text.isEmpty ? '0' : eCien.text) * 100 +
              int.parse(eCincuenta.text.isEmpty ? '0' : eCincuenta.text) * 50 +
              int.parse(eVeinte.text.isEmpty ? '0' : eVeinte.text) * 20 +
              int.parse(eDiez.text.isEmpty ? '0' : eDiez.text) * 10)
          .toString();
    }
    recalcularTotal();
  }

  void recalculareCheque() {
    tCheque.text = (double.parse(importe1.text.isEmpty ? '0' : importe1.text) +
            double.parse(importe2.text.isEmpty ? '0' : importe2.text) +
            double.parse(importe3.text.isEmpty ? '0' : importe3.text) +
            double.parse(importe4.text.isEmpty ? '0' : importe4.text) +
            double.parse(importe5.text.isEmpty ? '0' : importe5.text) +
            double.parse(importe6.text.isEmpty ? '0' : importe6.text))
        .toString();
    recalcularTotal();
  }

  void recalcularTotal() {
    tRecibido.text =
        ((double.parse(tEfectivo.text.isEmpty ? '0' : tEfectivo.text)) +
                (double.parse(tCheque.text.isEmpty ? '0' : tCheque.text)))
            .toString();
  }

  String validateName(String? value) {
    if (value != null && value.length == 0 || value == '0') {
      return "El Campo es requerido";
    }
    return '';
  }

  save() {
    final auth = Provider.of<Auth>(context, listen: false);
    final customer = Provider.of<Customers>(context, listen: false);
    final product = Provider.of<Products>(context, listen: false);
    final listNum = _numFactura.split("|");
    String numeroFact = listNum[0];
    if (keyForm.currentState!.validate() && numeroFact != '') {
      if (iRecibido.text.isNotEmpty && iRecibido.text != '0') {
        eveinteMil.text = '0';
        ediezMil.text = '0';
        edosMil.text = '0';
        eMil.text = '0';
        eQuinientos.text = '0';
        eDocientos.text = '0';
        eCien.text = '0';
        eCincuenta.text = '0';
        eVeinte.text = '0';
        eDiez.text = '0';
      }
      Provider.of<Cobros>(context, listen: false).addCobro(
          customer.customerActive!.id,
          numeroFact,
          eveinteMil.text,
          ediezMil.text,
          edosMil.text,
          eMil.text,
          eQuinientos.text,
          eDocientos.text,
          eCien.text,
          eCincuenta.text,
          eVeinte.text,
          eDiez.text,
          numero1.text,
          importe1.text,
          numero2.text,
          importe2.text,
          numero3.text,
          importe3.text,
          numero4.text,
          importe4.text,
          numero5.text,
          importe5.text,
          numero6.text,
          importe6.text,
          comentario.text,
          iDolar.text,
          iRecibido.text,
          tEfectivo.text,
          tCheque.text,
          tRecibido.text,
          ((auth.operation == 'ruta') ? auth.IdRuta : ''),
          notControl);
      setState(() {});
      Alert(
        context: context,
        type: AlertType.success,
        title: "EXITOSO!!",
        desc: "EL COBRO FUE REALIZADO DE FORMA EXITOSA!!",
        buttons: [
          DialogButton(
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              customer.clearCustomer("");
              product.clearProducts();
              Navigator.of(context).pushReplacementNamed('/');
            },
            width: 120,
          )
        ],
      ).show();
    }
  }
}
