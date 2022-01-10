import 'package:entregas/src/pages/client/address/create/client_address_create_page.dart';
import 'package:entregas/src/pages/client/address/list/client_address_list_page.dart';
import 'package:entregas/src/pages/client/address/map/client_address_map_page.dart';
import 'package:entregas/src/pages/client/orders/%20map/client_orders_map_page.dart';
import 'package:entregas/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:entregas/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:entregas/src/pages/client/payment/status/client_payment_status_page.dart';
import 'package:entregas/src/pages/client/products/list/client_products_list_page.dart';
import 'package:entregas/src/pages/client/update/client_update_page.dart';
import 'package:entregas/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:entregas/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:entregas/src/pages/login/login_page.dart';
import 'package:entregas/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:entregas/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:entregas/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:entregas/src/pages/roles/roles_page.dart';
import 'package:entregas/src/pages/sign_up/register_page.dart';
import 'package:entregas/src/provider/push_notification_provider.dart';
import 'package:entregas/src/utils/my_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';





 PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initPushNotifications();
  runApp( MyApp());
}
class MyApp extends StatefulWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pushNotificationsProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Servico de Entrega",
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {

          'login': (BuildContext context) => LoginPage(),
          'register' : (BuildContext context) => RegisterPage(),
          'roles' : (BuildContext context) => RolesPage(),
          'client/products/list' : (BuildContext context) => ClientProductsListPage(),
          'client/update' : (BuildContext context) => ClientUpdatePage(),
          'client/orders/create' : (BuildContext context) => ClientOrdersCreatePage(),
          'client/address/list' : (BuildContext context) => ClientAddressListPage(),
          'client/orders/create' : (BuildContext context) => ClientOrdersCreatePage(),
          'restaurant/orders/list' : (BuildContext context) => RestaurantOrdersListPage(),
          'restaurant/categories/create' : (BuildContext context) => RestaurantCategoriesCreatePage(),
          'restaurant/products/create' : (BuildContext context) => RestaurantProductsCreatePage(),
          'delivery/orders/list' : (BuildContext context) => DeliveryOrdersListPage(),
          'client/address/create' : (BuildContext context) => ClientAddressCreatePage(),
          'client/address/map' : (BuildContext context) => ClientAddressMapPage(),
          'client/payments/status' : (BuildContext context) => ClientPaymentsStatusPage (),
          'client/orders/list' : (BuildContext context) => ClientOrdersListPage(),
          'client/orders/map' : (BuildContext context) => ClientOrdersMapPage(),
          'delivery/orders/map' : (BuildContext context) => DeliveryOrdersMapPage(),
        },
      theme: ThemeData(
        // fontFamily: 'NimbusSans',
          primaryColor: MyColors.primaryColor,
          appBarTheme: AppBarTheme(elevation: 0)
      ),
        );
  }
}
