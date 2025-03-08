import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'package:flutter_shop_app/providers/customers.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = './user-products';

  Future<void> _refreshProducts(BuildContext context, String search,
      String idLista, String idCliente) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(idLista, {}, idCliente);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    final customer = Provider.of<Customers>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Listado de Productos'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(
              context,
              "",
              (customer.customerActive == null)
                  ? '0'
                  : customer.customerActive!.idLista,
              (customer.customerActive == null)
                  ? '0'
                  : customer.customerActive!.id),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(
                          context,
                          "",
                          (customer.customerActive == null)
                              ? '0'
                              : customer.customerActive!.idLista,
                          (customer.customerActive == null)
                              ? '0'
                              : customer.customerActive!.id),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (_, index) => Column(
                              children: <Widget>[
                                UserProductItem(
                                  id: productsData.items[index].id,
                                  title: productsData.items[index].title,
                                  imageUrl: productsData.items[index].imageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                            itemCount: productsData.items.length,
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
