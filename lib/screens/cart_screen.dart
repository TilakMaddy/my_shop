import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$' + cart.totalAmount.toStringAsFixed(2),
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title!.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('ORDER NOW'),
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final cartItem = cart.items.values.toList()[index];
                final cartItemKey = cart.items.keys.toList()[index];
                return CartScreenItem(
                  productId: cartItemKey,
                  id: cartItem.id,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  title: cartItem.title,
                );
              },
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
