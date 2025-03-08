import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../providers/message.dart';
import '../providers/spend.dart' show Spends;
import '../widgets/app_drawer.dart';

class SpendScreen extends StatefulWidget {
  static const routeName = "./gasto";

  @override
  _SpendScreenState createState() => _SpendScreenState();
}

class _SpendScreenState extends State<SpendScreen> {
  var _isLoading = false;

  // Future _obtainCobrosFuture() {
  //   return Provider.of<Cobros>(context, listen: false).fetchAndSetCobro();
  // }

  @override
  void initState() {
    // _cobrosFuture = _obtainCobrosFuture();
    super.initState();
  }

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController Kms = new TextEditingController();
  TextEditingController importe = new TextEditingController();
  TextEditingController litros = new TextEditingController();
  TextEditingController comentario = new TextEditingController();

  String _vehiculo = "";
  String _motivos = "";
  String _tipoGasto = "combustible";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GASTOS'),
        actions: <Widget>[],
      ),
      drawer: AppDrawer(),
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
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Title(
                                  color: Colors.amber,
                                  child: Text(
                                    "NUEVO GASTO",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              formHeader(),
                              Divider(
                                color: Colors.black,
                                //color: Color.fromARGB(255, 228, 224, 224),
                                thickness: 1,
                              ),
                              (_tipoGasto == "combustible")
                                  ? formBodyCombustible()
                                  : formBodyGastosComunes(),
                              formFooter(),
                            ],
                          ),
                        )),
                  )
            //     }
            // }
            ),
      ),
    );
  }

  Widget formHeader() {
    return Column(
      children: <Widget>[
        new Text("SELECCIONE TIPO DE GASTO ", textAlign: TextAlign.center),
        DropdownButtonFormField(
          disabledHint: Text(_tipoGasto),
          value: _tipoGasto,
          isExpanded: true,
          onChanged: (String? value) {
            setState(() {
              _tipoGasto = value ?? '';
            });
          },
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem(
              child: Text("COMBUSTIBLE"),
              value: "combustible",
            ),
            DropdownMenuItem(
              child: Text("GASTOS COMUNES"),
              value: "gastosComunes",
            ),
          ],
        ),
      ],
    );
  }

  Widget formBodyCombustible() {
    return Row(
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: new Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Text("COMBUSTIBLE ", textAlign: TextAlign.center),
                  DropdownButtonFormField(
                    disabledHint: Text(_vehiculo),
                    value: _vehiculo,
                    isExpanded: true,
                    onChanged: (String? value) {
                      setState(() {
                        _vehiculo = value ?? '';
                      });
                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        child: Text("VEHICULO"),
                        value: "",
                      ),
                      DropdownMenuItem(
                        child: Text("MASTER"),
                        value: "master",
                      ),
                      DropdownMenuItem(
                        child: Text("EXPRINTER"),
                        value: "exprinter",
                      ),
                      DropdownMenuItem(
                        child: Text("KANGOO"),
                        value: "kangoo",
                      ),
                      DropdownMenuItem(
                        child: Text("OTROS"),
                        value: "otros",
                      )
                    ],
                  ),
                  formItemsDesign(TextFormField(
                      decoration: InputDecoration(labelText: "KMS"),
                      controller: Kms,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
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
                          //recalcularEfectivo();
                        });
                      })),
                  formItemsDesign(TextFormField(
                      decoration: InputDecoration(labelText: "IMPORTE"),
                      controller: importe,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
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
                          //recalcularEfectivo();
                        });
                      })),
                  formItemsDesign(TextFormField(
                      decoration: InputDecoration(labelText: "LITROS"),
                      controller: litros,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
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
                        setState(() {});
                      })),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget formBodyGastosComunes() {
    return Row(
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: new Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Text("GASTOS COMUNES ", textAlign: TextAlign.center),
                  DropdownButtonFormField(
                    disabledHint: Text(_motivos),
                    value: _motivos,
                    isExpanded: true,
                    onChanged: (String? value) {
                      setState(() {
                        _motivos = value ?? '';
                      });
                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        child: Text("MOTIVO"),
                        value: "",
                      ),
                      DropdownMenuItem(
                        child: Text("PEAJE"),
                        value: "peaje",
                      ),
                      DropdownMenuItem(
                        child: Text("COMIDA"),
                        value: "comida",
                      ),
                      DropdownMenuItem(
                        child: Text("RETIRO"),
                        value: "retiro",
                      ),
                      DropdownMenuItem(
                        child: Text("OTROS"),
                        value: "otros",
                      )
                    ],
                  ),
                  formItemsDesign(TextFormField(
                    decoration: InputDecoration(labelText: "DESCRIPCION"),
                    controller: comentario,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 5,
                    // onChanged: (String value) {
                    //   setState(() {
                    //   });
                    // }
                  )),
                  formItemsDesign(TextFormField(
                    decoration: InputDecoration(labelText: "IMPORTE"),
                    controller: importe,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
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
                    // onChanged: (String value) {
                    //   setState(() {
                    //   });
                    // }
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget formFooter() {
    return Column(
      children: <Widget>[
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
                  Color(0xFFFBC02D),
                  //Color(0xFF0EDED2),
                  //Color(0xFF03A0FE),
                  Color(0xFFF9A825),
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

  formItemsDesign(item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Card(child: ListTile(title: item)),
    );
  }

  save() {
    bool validarCampo = true;

    if (_tipoGasto == "combustible" && _vehiculo == '') {
      validarCampo = false;
    }

    if (_tipoGasto == "gastosComunes" && _motivos == '') {
      validarCampo = false;
    }

    if (_tipoGasto == "combustible") {
      _motivos = "COMBUSTIBLE";
    }

    if (keyForm.currentState!.validate() && validarCampo) {
      Provider.of<Spends>(context, listen: false).addSpend(
        _tipoGasto,
        _motivos,
        _vehiculo,
        comentario.text,
        Kms.text,
        litros.text,
        importe.text,
      );
      setState(() {});
      Alert(
        context: context,
        type: AlertType.success,
        title: "EXITOSO!!",
        desc: "EL NUEVO GASTO SE GUARDO DE FORMA EXITOSA!!",
        buttons: [
          DialogButton(
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(SpendScreen.routeName);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      MessageWidget.error(
          context, "DEBE SELECCIONAR AL MENOS UN VEHICULO / MOTIVO", 10);
    }
  }
}
