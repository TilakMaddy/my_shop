import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  FavouritesOnly,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
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
        ],
      ),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}
