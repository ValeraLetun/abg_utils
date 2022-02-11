import 'dart:convert';
import 'dart:core';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MercadoPagoMobile extends StatefulWidget {
  final Function(String) onFinish;
  final double amount;
  final String desc;
  final String publicKey; //  = "TEST-6e047891-69e8-4963-a7e4-9a368812b2a3";
  final String accessToken; // = "TEST-6838333386915542-031815-40efe1228836302e5aad1897e586b9a3-140010600";
  final String code; // = _mainModel.localAppSettings.code;  // "BRL",

  MercadoPagoMobile({required this.onFinish, required this.amount, required this.desc,
    required this.publicKey, required this.accessToken, required this.code,});

  @override
  State<StatefulWidget> createState() {
    return MercadoPagoMobileState();
  }
}

class MercadoPagoMobileState extends State<MercadoPagoMobile> {

  late WebViewController _con;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Center(child: Text("MercadoPago Payment")),
        ),
        body: WebView(
          initialUrl: "",
          onWebViewCreated: (WebViewController webViewController) {
            _con = webViewController;
            _loadHTML();
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            dprint("navigationDelegate ${request.url}");
            // https://www.success.com/?collection_id=1243000947&collection_status=approved&payment_id=1243000947&
            // status=approved&external_reference=null&payment_type=credit_card&merchant_order_id=3532370682
            // &preference_id=140010600-d81a346a-ea5a-40a0-a537-7263154eb685&site_id=MLU&processing_mode=aggregator&merchant_account_id=null

            // http://www.failure.com/?collection_id=1243007068&collection_status=rejected&payment_id=1243007068&status=rejected&external_reference=null&payment_type=credit_card&merchant_order_id=3532481131&preference_id=140010600-44aedc3a-f102-4f1b-b518-f0dd7ed247aa&site_id=MLU&processing_mode=aggregator&merchant_account_id=null
            if (request.url.contains("https://www.success.com") ||
                request.url.contains("https://www.pending.com")
            ) {
              final uri = Uri.parse(request.url);
              var status = uri.queryParameters['collection_status'];
              var orderId = uri.queryParameters['merchant_order_id'];
              var paymentId = uri.queryParameters['payment_id'];
              widget.onFinish("$status order id:$orderId payment id:$paymentId");
              // if (uri.queryParameters['status'] == "successful"){
                // widget.onFinish(_ref);
                Navigator.of(context).pop();
              // } else
              //   Navigator.of(context).pop();
            }
            if (request.url.contains("http://www.failure.com"))
              Navigator.of(context).pop();
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  Future<String?> _getPreferenceId() async {
    var response = await http.post(Uri.parse("https://api.mercadopago.com/checkout/preferences"),
        body: convert.jsonEncode({
          "items": [
            {
              "title": widget.desc,
              "description": "",
              "picture_url": "http://www.myapp.com/myimage.jpg",
              "category_id": "cat123",
              "quantity": 1,
              "currency_id": widget.code, // "BRL",
              "unit_price": widget.amount
            }
          ],
          "payer": {
              "phone": {},
              "identification": {},
              "address": {}
          },
          "payment_methods": {
            "excluded_payment_methods": [
              {}
            ],
            "excluded_payment_types": [
              {}
            ]
          },
          "shipments": {
            "free_methods": [
               {}
            ],
            "receiver_address": {}
          },
          "back_urls": {
            "success": "https://www.success.com",
            "failure": "http://www.failure.com",
            "pending": "http://www.pending.com"
          },
          "differential_pricing": {},
          // "tracks": [
          //   {
          //   "type": "google_ad"
          //   }
          // ]
        }),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + widget.accessToken // Access Token
        });

    final body = convert.jsonDecode(response.body);
    if (response.statusCode == 201){
      return body["id"];
    }else
      messageError(context, body["message"]);

    return null;

    /*
    curl -X POST \
    'https://api.mercadopago.com/checkout/preferences' \
    -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
    -H 'Content-Type: application/json' \
    -d '{
  "items": [
    {
      "title": "Dummy Title",
      "description": "Dummy description",
      "picture_url": "http://www.myapp.com/myimage.jpg",
      "category_id": "cat123",
      "quantity": 1,
      "currency_id": "U$",
      "unit_price": 10
    }
  ],
  "payer": {
    "phone": {},
    "identification": {},
    "address": {}
  },
  "payment_methods": {
    "excluded_payment_methods": [
      {}
    ],
    "excluded_payment_types": [
      {}
    ]
  },
  "shipments": {
    "free_methods": [
      {}
    ],
    "receiver_address": {}
  },
  "back_urls": {

  },
  "differential_pricing": {},
  "tracks": [
    {
      "type": "google_ad"
    }
  ]
}'
     */
  }

  String? _preferenceId;

  _loadHTML() async {
    _preferenceId = await _getPreferenceId();
    if (_preferenceId != null)
      _con.loadUrl(Uri.dataFromString(_makeText(),
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8')
      ).toString());
    else
      messageError(context, "can't create preference id. Check your Access Token");
  }

  String _makeText(){

    // // var returnURL = _mainModel.currentBase + "flutterwave_success?booking=${mainModel.lastBooking}";
    // code = "NGN";
    // String amount = (widget.amount).toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
    // // var razorpayName = mainModel.localAppSettings.razorpayName;
    // var desc = widget.desc; //getTextByLocale(localSettings.price.name);
    // var userName = _mainModel.account.getCurrentAddress().name;
    // var userEmail = _mainModel.userEmail;
    // var userPhone = _mainModel.account.getCurrentAddress().phone;
    // var userAddress = mainModel.userAccount.getCurrentAddress().name;

    // print("key=$key code=$code amount=$amount razorpayName=$razorpayName");
    // print("desc=$desc userName=$userName userEmail=$userEmail userPhone=$userPhone userAddress=$userAddress");


    return '''<!DOCTYPE html>
      <html>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
      <head><title>MercadoPago Web Payment</title>
      </head>
      <body>
      
      	<div>
            <form id="tokenizer" method="GET" />
        </div>

       <!-- Mercado Pago Client-Side SDK -->
      <script src="https://sdk.mercadopago.com/js/v2"></script>
      
      <script>
      
      // Add the SDK credentials - Public Key
      const mp = new MercadoPago('${widget.publicKey}', {locale: 'en-US'});
      // The most common are: 'pt-BR', 'es-AR' and 'en-US'
      // es-AR es-CL es-CO es-MX es-VE es-UY es-PE pt-BR en-US
      // TEST-59e115b4-a4b3-4860-883f-0da6e30d4cad 
      
      // Initialize the Web Tokenize Checkout
      mp.checkout({
        autoOpen: true,
       preference: {
          id: '$_preferenceId'
        },
       render: {
          container: '#tokenizer', // Indicates where the payment button is going to be rendered
          // label: 'Pay' // Changes the button label (optional)
       }
      });
      
      // checkout.open();


 
</script>
</body>
</html>
        ''';
  }

}
