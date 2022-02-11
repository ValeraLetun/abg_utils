import 'dart:core';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'instamojos.dart';

class InstaMojoMobile extends StatefulWidget {
  final Function onFinish;
  final String userName;
  final String email;
  final String phone;
  final String payAmount;
  final String apiKey;
  final String token;
  final String sandBoxMode;

  InstaMojoMobile({required this.onFinish, required this.userName, required this.email,
    required this.phone, required this.payAmount,
    required this.apiKey, required this.token, required this.sandBoxMode});

  @override
  State<StatefulWidget> createState() {
    return InstaMojoMobileState();
  }
}

class InstaMojoMobileState extends State<InstaMojoMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  InstaMojoServices services = InstaMojoServices();
  // var paymentResponse;
  List<String> payResponse = [];

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String cancelURL = 'www.example.com';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken(widget.userName, widget.payAmount, widget.apiKey,
            widget.token, widget.sandBoxMode, widget.email, widget.phone, context);
        
        if (accessToken != null) {
          setState(() {
            checkoutUrl = accessToken;
            executeUrl = accessToken;
          });
        }
      } catch (e) {
        messageError(context, e.toString());
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
        "Instamojo",
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
                widget.onFinish(uri.queryParameters['payment_id']);
                // dprint(uri.queryParameters!['payment_id']);
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
        key: _scaffoldKey,
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
