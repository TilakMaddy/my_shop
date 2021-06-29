import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';

import 'package:provider/provider.dart';

import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/product_details_screen.dart';
import './screens/products_pverview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', []),
          update: (ctx, auth, prevProducts) =>
              Products(auth.token!, prevProducts!.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', []),
          update: (ctx, auth, prevOrders) =>
              Orders(auth.token!, prevOrders!.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
            },
          );
        },
      ),
    );
  }
}
