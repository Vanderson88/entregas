import 'package:entregas/src/models/order.dart';
import 'package:entregas/src/models/product.dart';
import 'package:entregas/src/models/response_api.dart';
import 'package:entregas/src/models/user.dart';
import 'package:entregas/src/provider/orders_provider.dart';
import 'package:entregas/src/provider/push_notification_provider.dart';
import 'package:entregas/src/provider/users_provider.dart';
import 'package:entregas/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestaurantOrdersDetailController {

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
 PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
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

  void sendNotification(String tokenDelivery) {

    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };

    pushNotificationsProvider.sendMessage(
        tokenDelivery,
        data,
        'PEDIDO ATRIBUIDO',
        'te atribuiram  um pedido'
    );
  }

  void updateOrder() async {
    if (idDelivery != null) {
      order.idDelivery = idDelivery;
      ResponseApi responseApi = await _ordersProvider.updateToDispatched(order);

      User deliveryUser = await _usersProvider.getById(order.idDelivery);
      print('TOKEN NOTIFICATION DELIVERY: ${deliveryUser.notificationToken}');
      sendNotification(deliveryUser.notificationToken);

      Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, true);
    }
    else {
      Fluttertoast.showToast(msg: 'Selecciona o entregador');
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