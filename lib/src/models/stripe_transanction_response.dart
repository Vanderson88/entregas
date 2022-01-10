import 'package:stripe_payment/stripe_payment.dart';

class StripeTransanctionResponse{
  String message;
  bool success;
  PaymentMethod paymentMethod;

  StripeTransanctionResponse({this.message, this.success, this.paymentMethod});
}