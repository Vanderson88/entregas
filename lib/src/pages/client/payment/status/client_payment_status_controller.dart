import 'package:entregas/src/provider/push_notification_provider.dart';
import 'package:entregas/src/provider/users_provider.dart';
import 'package:flutter/material.dart';

class ClientPaymentsStatusController {

  BuildContext context;
  Function refresh;

  String brandCard = '';
  String last4 = '';

  PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
  UsersProvider _usersProvider =  new  UsersProvider();
  List<String> tokens = [];

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    //_usersProvider.init(context, sessionUser: user);

    //tokens = await _usersProvider.getAdminsNotificationTokens();
    //sendNotification();


    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    brandCard =  arguments['brand'];
    last4=  arguments['last4'];

    refresh();
  }


  void sendNotification() {

    List<String> registration_ids = [];
    tokens.forEach((token) {
      if(token != null){
        registration_ids.add(token);
      }
    });

    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };

    pushNotificationsProvider.sendMessageMultiple(
        registration_ids,
        data,
        'Compra com exito',
        'Um cliente realizou um pedido'
    );
  }

  void finishShopping(){
    Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
  }
  }

