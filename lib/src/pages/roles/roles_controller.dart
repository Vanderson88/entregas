
import 'package:entregas/src/models/user.dart';
import 'package:entregas/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class RolesController {

  BuildContext context;
  Function refresh;

  User user;
  SharedPref sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    // OBTER A  SESSAO DO USUARIO
    user = User.fromJson(
        await sharedPref.read('user')); // PODE DEMORAR  UM TEMPO A OBTER
    refresh();
  }

  void goToPage(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}
