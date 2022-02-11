import 'dart:core';
import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/src/payments/paymob/pay_mob_services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayMobMobile2 extends StatefulWidget {
  final String id;
  final String code;
  final Function onFinish;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final String payAmount;
  final String userPhone;
  final String apiKey;
  final String frame;
  final String integrationId;
  //
  final String country;
  final String postalCode;
  final String state;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final String lastName;

  PayMobMobile2({required this.onFinish, required this.userFirstName, this.userLastName = "",
    required this.userEmail, required this.payAmount,
    required this.apiKey, required this.frame, required this.integrationId, required this.userPhone, this.id = "", required this.country,
    required this.postalCode, required this.state, required this.city, required this.street, required this.building, required this.floor,
    required this.apartment, required this.lastName, required this.code});

  @override
  State<StatefulWidget> createState() {
    return PayMobMobile2State();
  }
}

class PayMobMobile2State extends State<PayMobMobile2> {
  String? checkoutUrl;
  String? accessToken;
  var services = PayMobServices();
  List<String> payResponse = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.authentication(widget.apiKey);
        if (accessToken == null)
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Check apiKey")));
        await services.createOrder(widget.payAmount, "215", widget.code);//widget.id);
        checkoutUrl = await services.executePayment(
            widget.integrationId, widget.frame,
            widget.country, widget.postalCode, widget.state, widget.city, widget.street,
            widget.building, widget.floor, widget.apartment, widget.userFirstName,
            widget.lastName, widget.userEmail, widget.userPhone);
        if (checkoutUrl == null)
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("executePayment fails")));

        setState(() {
        });

      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        // _scaffoldKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  int quantity = 1;

  // Map<String, dynamic> getOrderParams(userFirstName, userLastName, itemName, itemPrice, String currency) {
  //   Map<String, dynamic> params = ;
  //   return params;
  // }

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
        appBar: appBar("PayMob"),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            print(request.url);
            if (request.url.contains("txn_response_code=APPROVED")) {
              final uri = Uri.parse(request.url);
              // I/flutter (29194): https://www.abg-studio.com/restaurants_site/public/PayMob?source_data.pan=2346&is_refund=false&success=false&
              // currency=EGP&has_parent_transaction=false&
              // is_auth=false&captured_amount=0&merchant_commission=0&order=21673174&amount_cents=33600&
              // is_refunded=false&is_standalone_payment=true&
              // error_occured=true&acq_response_code=-&
              // id=16978381&is_3d_secure=false&refunded_amount_cents=0&profile_id=79078&pending=false&hmac=72ba5f87cae6d1b06f14eb2ff83003ad21f75da07947ba8fa40fd1cf523a9ff98b6b3f33131bf0bb14c6f6775e8a6afe9f014d6c511eeada4eefe42b0e9de3de&
              // source_data.sub_type=MasterCard&txn_response_code=ERROR&source_data.type=card&integration_id=202620&is_capture=false&
              // data.message=Value+%27522345xxxxxx2346%27+is+invalid.+Unable+to+determine+card+payment.&
              // created_at=2021-11-08T14%3A32%3A37.467090&is_voided=false&owner=130228&is_void=false

              // txn_response_code=BLOCKED
              // https://www.abg-studio.com/restaurants_site/public/PayMob?integration_id=202620&is_capture=false&source_data.pan=2346&
              // currency=EGP&is_3d_secure=true&profile_id=79078&owner=130228&created_at=2021-11-05T11%3A29%3A13.392335&refunded_amount_cents=0&
              // error_occured=false&is_standalone_payment=true&data.message=BLOCKED&
              // source_data.sub_type=MasterCard&has_parent_transaction=false&is_refunded=false&merchant_commission=0&
              // success=false&txn_response_code=BLOCKED&id=16721709&is_void=false&source_data.type=card&
              // pending=false&order=21396413&captured_amount=0&is_auth=false&amount_cents=16800&
              // hmac=f0a530a789b968f425ce7e0f438d69579f56f11763a23db339ff132e87325aac9546a703b432900b5d7ccc24c8f4d4d02b5c823c8eb69694bdd0cad39152f82b&is_voided=false&is_refund=false

              // final payerID = uri.queryParameters['id'];
              // if (payerID != null) {
                // services.executePayment(payerID, widget.userFirstName, widget.userPhone, widget.userEmail)
                //     .then((List<String> ls) {
                //    print("paymentMethod: " + payerID+"  "+ accessToken + " " +ls[0]);
                //    setState(() {
                //      payResponse = ls;
                //    });
                widget.onFinish(uri.queryParameters['id']);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // });
              // } else
              //   Navigator.of(context).pop();
            }
            if (request.url.contains("txn_response_code=BLOCKED")){
              messageError(context, "BLOCKED");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
            if (request.url.contains("txn_response_code=ERROR")){
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['data.message'];
              messageError(context, payerID ?? "txn_response_code=ERROR");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
            // if (request.url.contains(cancelURL)) {
            //   Navigator.of(context).pop();
            // }
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
}
