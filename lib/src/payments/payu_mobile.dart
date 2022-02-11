import 'dart:convert';
import 'dart:core';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PayUMobile extends StatefulWidget {
  final Function(String) onFinish;
  final String userName;
  final String email;
  final String phone;
  final String payAmount;
  final String apiKey;
  final String merchantId;
  final String sandBoxMode;

  PayUMobile({required this.onFinish, required this.userName, required this.email,
    required this.phone, required this.payAmount, required this.apiKey, required this.merchantId,
    required this.sandBoxMode});

  @override
  State<StatefulWidget> createState() {
    return PayUMobileState();
  }
}

class PayUMobileState extends State<PayUMobile> {
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;

  String cancelURL = 'www.example.com';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await getAccessToken(widget.userName, widget.payAmount, widget.apiKey,
            widget.merchantId, widget.sandBoxMode, widget.email, widget.phone);
        
        if (accessToken != null) {
          setState(() {
            checkoutUrl = accessToken;
            executeUrl = accessToken;
          });
        }
      } catch (e) {
        messageError(context, 'exception: ' + e.toString());
      }
    });
  }

  appBar(title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Navigator.pop(context)),
      backgroundColor: Colors.white,
      title: Text(
        title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar("Instamojo"),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            dprint (request.url);
            if (request.url.contains(cancelURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['payment_id'];
              if (payerID != null) {
                widget.onFinish(payerID);
                //dprint(uri.queryParameters['payment_id']);
                Future.delayed(const Duration(milliseconds: 5000), () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                });
                return NavigationDecision.prevent;
              }
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }

  Future<String?> getAccessToken(String userName, String amount, String apiKey, String merchantId, String sandboxMode,
      String email, String phone) async {
    // https://secure.payu.com/
    // https://secure.snd.payu.com/
    // var url = "https://secure.payu.ru/api/v4/payments/authorize";
    var url = "https://secure.payu.ru/api/v4/payments/authorize";
    try {
      Map<String, String> requestHeaders = {
        // 'Content-type': 'application/json',
        "Content-Type": "application/x-www-form-urlencoded",
        "X-Header-Signature": apiKey,
        "X-Header-Merchant": merchantId,  // MERCHANT	8 латинских букв. Можно посмотреть в Личном кабинете PayU
        "X-Header-Date": DateTime.now().toIso8601String(),
      };
      Map<String, dynamic> map = <String, dynamic>{};
      map['amount'] = amount;
      map['purpose'] = "Advertising";
      map['buyer_name'] = userName;
      map['email'] = email;
      map['phone'] = phone;
      map['allow_repeated_payments'] = "true";
      map['send_email'] = "false";
      map['send_sms'] = "false";
      map['redirect_url'] = "https://www.example.com/redirect/";
      map['webhook'] = "http://www.example.com/webhook/";

      // Map<String, String> body = {
      //   "amount": amount, //amount to be paid
      //   "purpose": "Advertising",
      //   "buyer_name": userName,
      //   "email": email,
      //   "phone": phone,
      //   "allow_repeated_payments": "true",
      //   "send_email": "false",
      //   "send_sms": "false",
      //   "redirect_url": "https://www.example.com/redirect/",
      //   // Where to redirect after a successful payment.
      //   "webhook": "http://www.example.com/webhook/",
      // };
      // dprint('Response body: $body');

      var response = await http.post(Uri.parse(url), headers: requestHeaders, body: map).timeout(const Duration(seconds: 10));
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');
      var jsonResult = json.decode(response.body);
      if (response.statusCode == 201) {
        if (jsonResult['success'] == true)
          return jsonResult["payment_request"]['longurl'];
      }
      messageError(context, jsonResult['message'].toString());
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
