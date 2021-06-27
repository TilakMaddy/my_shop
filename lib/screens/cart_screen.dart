import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
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
                  OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0)
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Orders>(context, listen: false)
                  .addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              )
                  .then(
                (_) {
                  setState(() {
                    _isLoading = false;
                    widget.cart.clearCart();
                  });
                },
              );
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      style: TextButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
    );
  }
}
