import 'dart:convert';
import 'package:entregas/src/models/stripe_transanction_response.dart';
import 'package:entregas/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeProvider {


  String secret = "sk_test_51JAuiPBQLeALKsBEOzpbX3JCyykqCXYKaB9aezcQ7F4BhnttdsgnzdlPMfbjjpBqwlIcVWBH6UNuiLP6yNBitMZP00JIxeXn9P";

  Map<String, String> headers = {
    'Authorization': 'Bearer sk_test_51JAuiPBQLeALKsBEOzpbX3JCyykqCXYKaB9aezcQ7F4BhnttdsgnzdlPMfbjjpBqwlIcVWBH6UNuiLP6yNBitMZP00JIxeXn9P',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  BuildContext context;

  void init(BuildContext context) {
    this.context = context;
    StripePayment.setOptions(StripeOptions(
        publishableKey: 'pk_test_51JAuiPBQLeALKsBE7aoZ91wLnsGKOYDC8ooSyLXLnFL0OLkUncYoVIMu8DpI6OK4j12hGqnQma9kGo6G5htLoc3o00f8ZeKAHY',
        merchantId: 'test',
        androidPayMode: 'test'
    ));
  }


  Future<StripeTransanctionResponse> payWithCard(String amount, String currency) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      var paymentIntent = await createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent
        (clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id
      ));

      if (response.status == 'succeeded') {

        return new StripeTransanctionResponse(
            message: 'Transacao feita com exito',
            success: true,
           paymentMethod: paymentMethod
        );
      }
      else {
        return new StripeTransanctionResponse(
            message: 'Transacao falhou',
            success: false
        );
      }
    } catch (e) {
      print('Erro ao realizar a transacao $e');
      MySnackbar.show(context, 'Erro ao realizar a transacao');
      return null;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount,
      String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      Uri uri = Uri.https('api.stripe.com', 'v1/payment_intents');
      var response = await http.post(uri, body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      print('Erro ao criar o intent de pagamento $e');
      return null;
    }
  }

}







