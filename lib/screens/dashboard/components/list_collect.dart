import 'package:flutter/material.dart';
//import 'package:flutter_shop_app/models/RecentFile.dart';
import 'package:flutter_shop_app/providers/infoDashboard.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class ListCollects extends StatelessWidget {
  const ListCollects({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Title(
        color: Colors.white,
        child: Text('Listado de Cobro',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      Container(
          margin: EdgeInsets.symmetric(vertical: 1.0),
          //height: MediaQuery.of(context).size.height * 0.99,
          height: ((listInfoRouter.length * 30) + 90).toDouble(),
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child:
              new ListView(scrollDirection: Axis.horizontal, children: <Widget>[
            DataTable(
              columnSpacing: 5,
              dataRowHeight: 30,
              columns: [
                DataColumn(
                  label: Text("Hora",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text("Transportista",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text("Cliente",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text("Cheques",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text("Efectivo",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text("Total",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text("Factura",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
              rows: List.generate(
                listInfoRouter.length,
                (index) => collectDataRow(listInfoRouter[index]),
              ),
            ),
          ]))
    ]);
  }
}

DataRow collectDataRow(ListDashboard fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Text(fileInfo.date.substring(11),
            style: TextStyle(fontSize: 10.0, color: Colors.white)),
      ),
      DataCell(Text(fileInfo.transportista,
          style: TextStyle(fontSize: 10.0, color: Colors.white))),
      DataCell(Text(fileInfo.customer,
          style: TextStyle(fontSize: 10.0, color: Colors.white))),
      DataCell(Text(NumberFormat.simpleCurrency().format(fileInfo.cheques),
          style: TextStyle(fontSize: 10.0, color: Colors.white))),
      DataCell(Text(NumberFormat.simpleCurrency().format(fileInfo.import),
          style: TextStyle(fontSize: 10.0, color: Colors.white))),
      DataCell(Text(NumberFormat.simpleCurrency().format(fileInfo.total),
          style: TextStyle(fontSize: 10.0, color: Colors.white))),
      DataCell(Text(fileInfo.invoice,
          style: TextStyle(fontSize: 10.0, color: Colors.white))),
    ],
  );
}
