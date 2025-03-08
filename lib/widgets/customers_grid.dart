import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:provider/provider.dart';
import '../widgets/customer_item.dart';

class CustomersGrid extends StatelessWidget {
  final String value;
  bool notcobro = true;
  CustomersGrid(this.value);
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    if (auth.operation == 'cobro') {
      notcobro = false;
    }

    final customersData = Provider.of<Customers>(context);
    final customers = customersData.items
        .where((element) =>
            (element.nombre
                    .toUpperCase()
                    .contains((value == "") ? "" : value.toUpperCase()) ||
                element.empresa
                    .toUpperCase()
                    .contains((value == "") ? "" : value.toUpperCase()) ||
                element.code
                    .toUpperCase()
                    .contains((value == "") ? "" : value.toUpperCase())) &&
            (notcobro || element.facturadropdownItems.length > 0))
        .toList();

    bool customerSelect =
        customers.any((element) => element.isAgregate == true);
    // final Customers =
    //     Customers1.where((element) => element.title.contains(value)).toList();
    return ListView.builder(
      //padding: const EdgeInsets.all(20),
      padding: EdgeInsets.only(top: 0),
      itemCount: customers.length,
      itemBuilder: (_, index) {
        return ChangeNotifierProvider.value(
          value: customers[index],
          child: CustomerItem('', customerSelect),
        );
      },
    );
  }
}
