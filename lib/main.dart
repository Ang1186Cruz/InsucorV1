import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/constants.dart';
import 'package:flutter_shop_app/helpers/custom_route.dart';
import 'package:flutter_shop_app/providers/carrier.dart';
import 'package:flutter_shop_app/providers/customers.dart';
import 'package:flutter_shop_app/providers/event.dart';
import 'package:flutter_shop_app/providers/infoDashboard.dart';
import 'package:flutter_shop_app/providers/note_orders.dart';
import 'package:flutter_shop_app/providers/spend.dart';
import 'package:flutter_shop_app/screens/cobro_screen.dart';
import 'package:flutter_shop_app/screens/delivery_screen.dart';
import 'package:flutter_shop_app/screens/edit_customers_screen.dart';
import 'package:flutter_shop_app/screens/entrega_screen.dart';
import 'package:flutter_shop_app/screens/main_screen.dart';
import 'package:flutter_shop_app/screens/note_orders_screen.dart';
import 'package:flutter_shop_app/screens/productCalendar.dart';
import 'package:flutter_shop_app/screens/routes_screen.dart';
import 'package:flutter_shop_app/screens/spend_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/splash_screen.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/cart_screen.dart';
import './screens/collect_screen.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './providers/deliverys.dart';
import './providers/cobros.dart';
import './screens/product_detail_screen.dart';
import './screens/customers_screen.dart';
import './providers/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update:
              (_, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              ),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          //create: null,
          create: (_) => Orders('', '', []),
          update:
              (_, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, Events>(
          create: (_) => Events('', ''),
          update: (_, auth, previousOrders) => Events(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, NoteOrders>(
          create: (_) => NoteOrders('', '', ''),
          update:
              (_, auth, previousInfoListDashboard) =>
                  NoteOrders(auth.token, auth.userId, auth.rolId),
        ),
        ChangeNotifierProxyProvider<Auth, Deliverys>(
          create: (_) => Deliverys(null, null, []),
          update:
              (_, auth, previousDeliverys) => Deliverys(
                auth.token,
                auth.userId,
                previousDeliverys == null ? [] : previousDeliverys.deliverys,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, Cobros>(
          create: (_) => Cobros('', '', []),
          update:
              (_, auth, previousCobros) => Cobros(
                auth.token,
                auth.userId,
                previousCobros == null ? [] : previousCobros.cobros,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, Carriers>(
          create: (_) => Carriers('', '', []),
          update:
              (_, auth, previousCarriers) => Carriers(
                auth.token,
                auth.userId,
                previousCarriers == null ? [] : previousCarriers.items,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, Spends>(
          create: (_) => Spends('', ''),
          update: (_, auth, previousSpends) => Spends(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, Routes>(
          create: (_) => Routes('', '', []),
          update:
              (_, auth, previousRoutes) => Routes(
                auth.token,
                auth.userId,
                previousRoutes == null ? [] : previousRoutes.routes,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, InfoListDashboard>(
          create: (_) => InfoListDashboard('', '', ''),
          update:
              (_, auth, previousInfoListDashboard) =>
                  InfoListDashboard(auth.token, auth.userId, auth.rolId),
        ),
        ChangeNotifierProxyProvider<Auth, Customers>(
          create: (_) => Customers('', '', []),
          update:
              (_, auth, previousCustomers) => Customers(
                auth.token,
                auth.userId,
                previousCustomers == null ? [] : previousCustomers.items,
              ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate, // Esto es lo que quieres
              // GlobalWidgetsLocalizations
              //     .delegate, // Agrega este también si es necesario
              // GlobalCupertinoLocalizations
              //     .delegate, // Agrega este si usas Cupertino
            ],
            supportedLocales: [
              const Locale('es', 'ES'),
              const Locale('en', 'US'),
            ],
            title: 'Mi Tienda',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.blue, // Color azul para toda la app
              // colorScheme: ColorScheme.fromSwatch().copyWith(
              //   primary: Colors.blue, // Color principal
              //   secondary: Colors.blueAccent, // Color secundario
              // ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue, // Fondo del AppBar
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ), // Color del texto del título
                iconTheme: IconThemeData(
                  color: Colors.white,
                ), // Color de los iconos en la AppBar
              ),
              // drawerTheme: DrawerThemeData(
              //   backgroundColor: Colors.blue, // Color del Drawer (menú)
              // ),
              //  primarySwatch: Colors.amber,
              textTheme: TextTheme(
                titleLarge: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  //color: Colors.white
                ),
                titleMedium: TextStyle(
                  fontSize: 16.0,
                  //fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white
                ),
                bodyMedium: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Hind',
                  //color: Colors.white
                ),
              ),
              scaffoldBackgroundColor: bgColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
            ),
            home:
                auth.isAuth
                    ? MainScreen()
                    //CustomersScreen() //ProductsOverviewScreen()
                    : //AuthScreen(),//SplashScreen(auth),
                    FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder:
                          (ctx, authResultSnapshot) =>
                              auth.splash ? SplashScreen(auth) : AuthScreen(),
                    ),
            routes: {
              CustomersScreen.routeName: (_) => CustomersScreen(),
              ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrdersScreen.routeName: (_) => OrdersScreen(),
              NoteOrdersScreen.routeName: (_) => NoteOrdersScreen(),
              ProductCalendarScreen.routeName: (_) => ProductCalendarScreen(),
              UserProductsScreen.routeName: (_) => UserProductsScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
              EditcustomerScreen.routeName: (_) => EditcustomerScreen(),
              DeliverysScreen.routeName: (_) => DeliverysScreen(),
              CobrosScreen.routeName: (_) => CobrosScreen(),
              SpendScreen.routeName: (_) => SpendScreen(),
              CollectScreen.routeName: (_) => CollectScreen(),
              EntregaScreen.routeName: (_) => EntregaScreen(),
              RoutesScreen.routeName: (_) => RoutesScreen(),
            },
          );
        },
      ),
    );
  }

  InputDecoration inputDecorationCustom() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      labelStyle: TextStyle(color: Colors.white),
      labelText: "Search",
      hintText: "Search",
      prefixIcon: Icon(Icons.search, color: Colors.white),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
