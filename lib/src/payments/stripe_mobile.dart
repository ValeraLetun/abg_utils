import 'dart:convert';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeMobile{

  init(String stripeId){
    Stripe.publishableKey = stripeId;
    Stripe.merchantIdentifier = 'test';
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency, String stripeSecret) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization' : "Bearer $stripeSecret",
      };
      Map<String, dynamic> body= {"amount": amount, "currency" : currency, "payment_method_types[]": "card"};
      var url = "https://api.stripe.com/v1/payment_intents";
      var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));
      dprint(url);
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');
      return json.decode(response.body);
    } catch (ex) {
      dprint("stripe createPaymentIntent " + ex.toString());
    }
    return null;
  }

  Future<bool> openCheckoutCard(int amount, String desc, String clientPhone, String companyName, String currency, String stripeSecret,
      Function(String) onSuccess) async {


    Map<String, dynamic>? paymentIntent = await createPaymentIntent(amount.toString(), currency, stripeSecret);
    if (paymentIntent == null)
      return false;
    dprint(paymentIntent.toString());

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
        testEnv: true,
        // merchantCountryCode: 'UK',
        merchantDisplayName: companyName,
        customerId: paymentIntent['customer'],
        paymentIntentClientSecret: paymentIntent['client_secret'],
        // customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
      ),
    );

    await Stripe.instance.presentPaymentSheet(
        // parameters: PresentPaymentSheetParameters(
        //   clientSecret: paymentIntent['client_secret'],
        //   confirmPayment: true,
        // )
    );
    dprint("Payment $currency${amount/100} stripe:${paymentIntent["id"]}");
    onSuccess("Payment $currency${amount/100} stripe:${paymentIntent["id"]}");
    return true;
  }
}