import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  FavouritesOnly,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  var ranOnce = false;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (ranOnce) return;
    Provider.of<Products>(context).fetchAndSetProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    ranOnce = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.FavouritesOnly,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions choice) {
              setState(() {
                if (choice == FilterOptions.FavouritesOnly) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) {
              return Badge(
                child: ch!,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
