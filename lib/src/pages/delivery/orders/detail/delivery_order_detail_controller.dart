import 'package:entregas/src/models/order.dart';
import 'package:entregas/src/models/product.dart';
import 'package:entregas/src/models/response_api.dart';
import 'package:entregas/src/models/user.dart';
import 'package:entregas/src/provider/orders_provider.dart';
import 'package:entregas/src/provider/users_provider.dart';
import 'package:entregas/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryOrdersDetailController {

  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();

  double total = 0;
  Order order;

  User user;
  List<User> users = [];
  UsersProvider _usersProvider = new UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  String idDelivery;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }

  void updateOrder() async {
    if (order.status == 'ENVIADO') {
      ResponseApi responseApi = await _ordersProvider.updateToOnTheWay(order);
      Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
      if (responseApi.success) {
        Navigator.pushNamed(context, 'delivery/orders/map', arguments: order.toJson());
      }
    }
    else {
      Navigator.pushNamed(context, 'delivery/orders/map', arguments: order.toJson());
    }
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryMen();
    refresh();
  }

  void getTotal() {
    total = 0;
    order.products.forEach((product) {
      total = total + (product.price * product.quantity);
    });
    refresh();
  }

}