import 'dart:convert';
import 'dart:core';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

//   static const String NGN = "NGN";
//   static const String KES = "KES";
//   static const String RWF = "RWF";
//   static const String UGX = "UGX";
//   static const String ZMW = "ZMW";
//   static const String GHS = "GHS";
//   static const String XAF = "XAF";
//   static const String XOF = "XOF";

class FlutterwaveMobile extends StatefulWidget {
  final Function(String) onFinish;
  final String amount;  // (widget.amount).toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma)
  final String desc;
  final String code; // currency code
  final String flutterWavePublicKey; // _mainModel.localAppSettings.flutterWavePublicKey
  final String userName; // _mainModel.account.getCurrentAddress().name;
  final String userEmail; // _mainModel.userEmail;
  final String userPhone; // _mainModel.account.getCurrentAddress().phone;

  FlutterwaveMobile({required this.onFinish, required this.amount, required this.desc,
    required this.code, required this.flutterWavePublicKey, required this.userName,
    required this.userEmail, required this.userPhone,});

  @override
  State<StatefulWidget> createState() {
    return FlutterwaveMobileState();
  }
}

class FlutterwaveMobileState extends State<FlutterwaveMobile> {

  String returnURL = 'https://cancel.flutterwave-example.com';
  String cancelURL = 'cancel.example.com';
  late WebViewController _con;
  var _ref = "";

  @override
  void initState() {
    _ref = DateTime.now().millisecondsSinceEpoch.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Center(child: Text("Flutterwave Payment")),
        ),
        body: WebView(
          initialUrl: "",
          onWebViewCreated: (WebViewController webViewController) {
            _con = webViewController;
            _loadHTML();
          },
          onPageStarted: (String url) {
          //  print('Page started loading: $url');
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
           // dprint("navigationDelegate ${request.url}");
            if (!request.url.startsWith("data:text/html")) {
              if (request.url.contains(returnURL)) {
                final uri = Uri.parse(request.url);
                if (uri.queryParameters['status'] == "successful") {
                  widget.onFinish(_ref);
                  Navigator.of(context).pop();
                } else
                  Navigator.of(context).pop();
              }
              if (request.url.contains(cancelURL))
                Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    }

  _loadHTML() async {
    _con.loadUrl(Uri.dataFromString(_makeText(),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

  String _makeText(){
    return '''<!DOCTYPE html>
      <html>
      <meta name="viewport" content="width=device-width">
      <head><title>RazorPay Web Payment</title></head>
      <body>
      <script src="https://checkout.flutterwave.com/v3.js"></script>
      <script>
      const queryString = window.location.search;
      console.log(queryString);
      
      FlutterwaveCheckout({
      public_key: "${widget.flutterWavePublicKey}",
      tx_ref: "$_ref",
      amount: ${widget.amount},
      currency: "${widget.code}",
      country: "US",
      payment_options: " ",
      redirect_url: // specified redirect URL
        "$returnURL",
      meta: {
        consumer_id: 23,
        consumer_mac: "92a3-912ba-1192a",
      },
      customer: {
        email: "${widget.userEmail}",
        phone_number: "${widget.userPhone}",
        name: "${widget.userName}",
      },
      callback: function (data) {
        console.log(data);
      },
      onclose: function() {
        window.parent.postMessage("MODAL_CLOSED","*");   //3
      },
      customizations: {
        title: "My store",
        description: "${widget.desc}",
        logo: "",
      },
    });
 
</script>
</body>
</html>
        ''';
  }

}
