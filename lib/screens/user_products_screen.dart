import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts();
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 1000,
            child: ListView.builder(
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    UserProductItem(
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,
                      productsData.items[i].id,
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: productsData.items.length,
            ),
          ),
        ),
      ),
    );
  }
}
