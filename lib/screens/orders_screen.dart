import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var ranOnce = false;
  var _isLoading = true;
  var _error = false;

  @override
  void didChangeDependencies() {
    if (ranOnce) return;

    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      print("caught error!hhe");
      setState(() {
        _error = true;
        _isLoading = false;
      });
    });

    ranOnce = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<Orders>(context, listen: false)
                    .fetchAndSetOrders()
                    .catchError((err) {
                  setState(() {
                    _error = true;
                  });
                });
              },
              child: _error
                  ? Center(child: Text('Permission denied'))
                  : (orders.orders.length == 0
                      ? Center(child: Text('You have no orders !'))
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            return OrderScreenItem(orders.orders[index]);
                          },
                          itemCount: orders.orders.length,
                        )),
            ),
    );
  }
}
