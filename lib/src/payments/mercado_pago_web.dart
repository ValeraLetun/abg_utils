import 'dart:core';
import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

//
// class MercadoPagoPayment extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return MercadoPagoPaymentState();
//   }
// }
//
// class MercadoPagoPaymentState extends State<MercadoPagoPayment> {
//
//   late MainModel _mainModel;
//   // late WebViewController _con;
//
//   String returnURL = "";
//   String cancelURL = '';
//   String _content = "";
//
//   String _publicKey = "TEST-6e047891-69e8-4963-a7e4-9a368812b2a3";
//   String _accessToken = "TEST-6838333386915542-031815-40efe1228836302e5aad1897e586b9a3-140010600";
//
//   @override
//   void initState() {
//     _mainModel = Provider.of<MainModel>(context,listen:false);
//     returnURL = _mainModel.currentBase + "mercadopago_success?booking=${_mainModel.lastBooking}";
//     cancelURL = _mainModel.currentBase + "mercadopago_cancel?booking=${_mainModel.lastBooking}";
//     init();
//     super.initState();
//   }
//
//   init() async {
//     await _loadHTML();
//     setState(() {
//     });
//    // startTimer();
//   }
//
//   @override
//   void dispose() {
//     print("_iframeWidget is disposed?");
//     super.dispose();
//   }
//
//   late Timer _timer;
//   void startTimer() {
//     _timer = new Timer.periodic(Duration(seconds: 1),
//           (Timer timer) {
//             print("timer");
//             print("element");
//             for (var item in element.nodes)
//               print ("nodes ${item.nodeName}");
//             for (var item in element.children)
//               print ("children ${item.nodeName}");
//             print(element.src);
//             var t = element.sandbox;
//             print(t.toString());
//             var c = element.firstChild;
//             var s = element.innerHtml;
//             // var shadow = element.shadowRoot;
//             // var g = shadow!.firstChild;
//             var n = document.querySelector('flt-platform-view');
//             var n5 = n!.querySelector('iframe');
//             var n1 = n5!.shadowRoot;
//             var n2  = n1!.querySelector('iframe');
//
//             // var v = html.document.getElementsByTagName('flt-platform-view')[0].sha;
//             // for (var item in v ) {
//             //   var j = item.firstChild!;
//             //   print(j.nodeName);
//             //   var l = j.firstChild;
//             //   print(j.nodeName);
//             // }
//               // item.shadowRoot.getElementById('plotly_div_id_')
//             var f = element.contentWindow;//!.addEventListener(type, (event) => null)
//             print(f.toString());
//
//
//       },);
//   }
//
//
//   late IFrameElement element;
//
//   @override
//   Widget build(BuildContext context) {
//     // html.window.on.location.reload();
//     if (_content.isNotEmpty){
//       // ignore: undefined_prefixed_name
//       ui.platformViewRegistry.registerViewFactory("pp-html", (int viewId) {
//         element = IFrameElement();
//         element.id = 'iframe';
//         // print("element.id=${element.id}");
//
//         // <flt-platform-view slot="flt-pv-slot-0"><iframe id="iframe" src="data:text/html,%20%20%20%20%0A%20%20%20%20%20%20%0A%20%20%20%20%20%20%3Cdiv%20id=%22mercadopago_item%22%3E%0A%20%20%20%20%20%20%20%20%20%20%3Cform%20id=%22tokenizer%22%20method=%22GET%22%20/%3E%0A%20%20%20%20%20%20%3C/div%3E%0A%0A%20%20%20%20%20%20%20%3C!--%20Mercado%20Pago%20Client-Side%20SDK%20--%3E%0A%20%20%20%20%20%20%3Cscript%20src=%22https://sdk.mercadopago.com/js/v2%22%3E%3C/script%3E%0A%20%20%20%20%20%20%0A%20%20%20%20%20%20%3Cscript%3E%0A%20%20%20%20%20%20%0A%20%20%20%20%20%20//%20Add%20the%20SDK%20credentials%20-%20Public%20Key%0A%20%20%20%20%20%20const%20mp%20=%20new%20MercadoPago('TEST-6e047891-69e8-4963-a7e4-9a368812b2a3',%20%7Blocale:%20'en-US'%7D);%0A%20%20%20%20%20%20//%20The%20most%20common%20are:%20'pt-BR',%20'es-AR'%20and%20'en-US'%0A%20%20%20%20%20%20//%20es-AR%20es-CL%20es-CO%20es-MX%20es-VE%20es-UY%20es-PE%20pt-BR%20en-US%0A%20%20%20%20%20%20//%20TEST-59e115b4-a4b3-4860-883f-0da6e30d4cad%20%0A%20%20%20%20%20%20%0A%20%20%20%20%20%20console.log(%22MercadoPago%20start%22);%0A%20%20%20%20%20%20//%20Initialize%20the%20Web%20Tokenize%20Checkout%0A%20%20%20%20%20%20//%20mp.checkout(%7B%0A%20%20%20%20%20%20//%20%20%20autoOpen:%20true,%0A%20%20%20%20%20%20//%20%20preference:%20%7B%0A%20%20%20%20%20%20//%20%20%20%20%20id:%20'140010600-dde81442-53f9-4796-ab5a-096ccda73520'%0A%20%20%20%20%20%20//%20%20%20%7D,%0A%20%20%20%20%20%20//%20%20render:%20%7B%0A%20%20%20%20%20%20//%20%20%20%20%20container:%20'%23tokenizer',%20//%20Indicates%20where%20the%20payment%20button%20is%20going%20to%20be%20rendered%0A%20%20%20%20%20%20//%20%20%20%20%20//%20label:%20'Pay'%20//%20Changes%20the%20button%20label%20(optional)%0A%20%20%20%20%20%20//%20%20%7D%0A%20%20%20%20%20%20//%20%7D);%0A%20%20%20%20%20%20%0A%20%20%20%20%20%20window.addEventListener('unload',%20function%20(e)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20console.log(%22MercadoPago%20unload%22);%0A%20%20%20%20%20%20%20%20%7D);%0A%20%20%20%20%20%20%20%20window.addEventListener('onCloseWindow',%20function%20(e)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20console.log(%22MercadoPago%20onCloseWindow%22);%0A%20%20%20%20%20%20%20%20%7D);%0A%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20window.addEventListener('onCloseWindow',%20function%20(e)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20console.log(%22MercadoPago%20onCloseWindow%22);%0A%20%20%20%20%20%20%20%20%7D);%0A%20%20%20%20%20%20%20%20window.addEventListener('modalclose',%20function%20(e)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20console.log(%22MercadoPago%20modalclose%22);%0A%20%20%20%20%20%20%20%20%7D);%0A%20%20%20%20%20%20%20%0A%20%20%20%20%20%20window.addEventListener('load',%20function%20(e)%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20//%20e.preventDefault();%0A%20%20%20%20%20%20%20%20%20%20%20%20//%20e.returnValue%20=%20'';%0A%20%20%20%20%20%20%20%20%20%20%20%20console.log(%22MercadoPago%20load%22);%0A%20%20%20%20%20%20%20%20%20%20%20%20//window.parent.postMessage(%22MODAL_CLOSED%22,%22*%22);%20%20%20//3%0A%20%20%20%20%20%20%20%20%7D);%0A%20%20%20%20%20%20%20%20%0A%20%20%20%20%20%20%20%20window.addEventListener(%22DOMNodeRemovedFromDocument%22,%20function%20(event)%20%7B%0A%20%20%20%20%20%20%20%20%20%20console.log(%22DOMNodeRemovedFromDocument%22);%0A%20%20%20%20%20%20%20%20%20%20console.log(event);%0A%20%20%20%20%20%20%20%20%20%20console.log(event.target);%0A%20%20%20%20%20%20%20%20%7D,%20false);%0A%20%20%20%20%20%20%20%20window.addEventListener(%22DOMNodeRemoved%22,%20function%20(e)%20%7B%0A%20%20%20%20%20%20%20%20%20%20console.log(%22DOMNodeRemoved%22);%0A%20%20%20%20%20%20%20%20%20%20console.log(e);%0A%20%20%20%20%20%20%20%20%20%20console.log(e.target);%0A%20%20%20%20%20%20%20%20%20%20//%20window.parent.postMessage(%22MODAL_CLOSED%22,%22*%22);%20%20%20//3%0A%20%20%20%20%20%20%20%20%7D,%20false);%0A%20%20%20%0A%20%20%0A%20%20%20console.log(%22document.getElementById%22);%0A%20%20%20var%20frame%20=%20document.getElementsByTagName('flt-platform-view-slot');%0A%20%20%20console.log(frame);%0A%20%20%20console.log(frame%5B0%5D);%0A%20%20%20//%20frame%5B0%5D.shadowRoot.getElementById('iframe');%0A%20%20%20%0A%20%20%20console.log(document.getElementById(%22mercadopago_item%22));%0A%20%20%20%0A%20%20%20console.log(document.getElementById(%22iframe%22));%0A%20%20%20console.log(document.getElementById(%22__privateStripeMetricsController6860%22));%0A%20%0A%3C/script%3E%0A%0A%20%20%20%20%20%20%20%20" style="border: none; height: 100%; width: 100%;"></iframe></flt-platform-view>
//         // var elem = html.window.document.getElementsByTagName('flt-pv-slot-0');
//         // elem = html.window.document.getElementsByTagName('flt-platform-view');
//         // for (var item in elem) {
//         //   print(item.toString());
//         //   item.addEventListener("DOMNodeRemoved", (event) {
//         //     print("$event");
//         //   });
//         // }
//
//         //IFrameElement ifrelem = elem.shadowRoot.getElementById('iframe');
//
//         // element.onBlur.forEach((element) {
//         //   print('element onBlur in callback: ${element.type}');
//         // }) ;
//         // element.onClick.forEach((element) {
//         //   print('element onClick in callback: ${element.type}');
//         // }) ;
//
//         // html.window.addEventListener("DOMNodeRemoved", (event) {
//         //   var removedNode = event.target;
//         //   print("removedNode=$removedNode");
//         //   // if (removedNode == html.window.) { // mercadopago-checkout
//         //   //   alert("iframe removed");
//         //   // }
//         // });
//         // element.onAbort.forEach((element) {
//         //   print('element onAbort in callback: ${element.type}');
//         // }) ;
//         // window.onAbort.forEach((element) {
//         //   print('onAbort in callback: ${element.type}');
//         // }) ;
//         // window.onMessage.forEach((element) {
//         //   print('Event Received in callback: ${element.data}');
//         //   if (element.data == 'MODAL_CLOSED') {
//         //     // _mainModel.mercadoPagoShow = false;
//         //     // _mainModel.redraw();
//         //     //Navigator.pop(context);
//         //   }
//         //   else if (element.data == 'SUCCESS') {
//         //     print('PAYMENT SUCCESSFULL!!!!!!!');
//         //   }
//         // });
//
//         element.width = '200px';
//         element.height = '200px';
//
//         // element.src = 'https://www.youtube.com/embed/IyFZznAk69U';
//         // element.src=Uri.dataFromString('<html><body><iframe src="https://www.youtube.com/embed/abc"></iframe></body></html>', mimeType: 'text/html').toString();
//         element.src=Uri.dataFromString(_content, mimeType: 'text/html').toString();
//         // element.src = checkoutUrl;
//         // element.src='assets/payments.html?name=$name&price=$price&image=$image';
//         element.style.border = 'none';
//         return element;
//       });
//       return Container(
//           width: windowWidth,
//           height: windowHeight,
//           child: Stack(
//         children: [
//             Center(child: SizedBox(
//               width: windowWidth/2,
//               height: windowHeight/2,
//             child: HtmlElementView(viewType: 'pp-html', onPlatformViewCreated: (int id){
//             print("HtmlElementView id=$id");
//           }))),
//           InkWell(
//               onTap: (){
//                 print("GestureDetector onTap");
//                 var toDoInput = querySelector('#iframe');
//                 print("$toDoInput");
//               },
//               child: Container(color: Colors.red.withAlpha(10),
//                 width: windowWidth,
//                 height: windowHeight
//               ))
//         ],
//       ));
//     }
//     else
//       return Container();
//
//     //
//       // return Scaffold(
//       //   backgroundColor: Colors.white,
//       //   appBar: PreferredSize(
//       //     preferredSize: const Size.fromHeight(50),
//       //     child: Center(child: Text("MercadoPago Payment")),
//       //   ),
//       //   body: _context.isNotEmpty ? WebViewX(
//       //     initialContent: _context,
//       //     //initialUrl: "",
//       //     onWebViewCreated: (WebViewXController webViewController) {
//       //       _con = webViewController;
//       //       _loadHTML();
//       //     },
//       //     onPageStarted: (String url) {
//       //       print('Page started loading: $url');
//       //     },
//       //     javascriptMode: JavascriptMode.unrestricted,
//       //     navigationDelegate: (NavigationRequest request) {
//       //       var url = request.content.source;
//       //       print("navigationDelegate $url");
//       //       // https://www.success.com/?collection_id=1243000947&collection_status=approved&payment_id=1243000947&
//       //       // status=approved&external_reference=null&payment_type=credit_card&merchant_order_id=3532370682
//       //       // &preference_id=140010600-d81a346a-ea5a-40a0-a537-7263154eb685&site_id=MLU&processing_mode=aggregator&merchant_account_id=null
//       //
//       //       // http://www.failure.com/?collection_id=1243007068&collection_status=rejected&payment_id=1243007068&status=rejected&external_reference=null&payment_type=credit_card&merchant_order_id=3532481131&preference_id=140010600-44aedc3a-f102-4f1b-b518-f0dd7ed247aa&site_id=MLU&processing_mode=aggregator&merchant_account_id=null
//       //       if (url.contains("https://www.success.com") ||
//       //           url.contains("https://www.pending.com")
//       //       ) {
//       //         final uri = Uri.parse(url);
//       //         var status = uri.queryParameters['collection_status'];
//       //         var orderId = uri.queryParameters['merchant_order_id'];
//       //         var paymentId = uri.queryParameters['payment_id'];
//       //         widget.onFinish("$status order id:$orderId payment id:$paymentId");
//       //         // if (uri.queryParameters['status'] == "successful"){
//       //           // widget.onFinish(_ref);
//       //           Navigator.of(context).pop();
//       //         // } else
//       //         //   Navigator.of(context).pop();
//       //       }
//       //       if (url.contains("http://www.failure.com"))
//       //         Navigator.of(context).pop();
//       //       return NavigationDecision.navigate;
//       //     },
//       //     width: windowWidth,
//       //     height: windowHeight,
//       //   ) : Container(),
//       // );
//   }
//
//   Future<String?> _getPreferenceId() async {
//     var code = appSettings.code;
//     var desc = ""; // widget.desc;
//
//     var response = await http.post(Uri.parse("https://api.mercadopago.com/checkout/preferences"),
//         body: convert.jsonEncode({
//           "items": [
//             {
//               "title": desc,
//               "description": "",
//               "picture_url": "http://www.myapp.com/myimage.jpg",
//               "category_id": "cat123",
//               "quantity": 1,
//               // "currency_id": code, // "BRL",
//               "currency_id": "BRL",
//               "unit_price": getTotal() //widget.amount
//             }
//           ],
//           "payer": {
//               "phone": {},
//               "identification": {},
//               "address": {}
//           },
//           "payment_methods": {
//             "excluded_payment_methods": [
//               {}
//             ],
//             "excluded_payment_types": [
//               {}
//             ]
//           },
//           "shipments": {
//             "free_methods": [
//                {}
//             ],
//             "receiver_address": {}
//           },
//           "back_urls": {
//           "success": returnURL,
//             "failure": cancelURL,
//             "pending": returnURL
//           },
//           "differential_pricing": {},
//           // "tracks": [
//           //   {
//           //   "type": "google_ad"
//           //   }
//           // ]
//         }),
//         headers: {
//           "content-type": "application/json",
//           'Authorization': 'Bearer ' + _accessToken // Access Token
//         });
//
//     final body = convert.jsonDecode(response.body);
//     if (response.statusCode == 201){
//       return body["id"];
//     }else
//       messageError(context, body["message"]);
//
//     return null;
//
//     /*
//     curl -X POST \
//     'https://api.mercadopago.com/checkout/preferences' \
//     -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
//     -H 'Content-Type: application/json' \
//     -d '{
//   "items": [
//     {
//       "title": "Dummy Title",
//       "description": "Dummy description",
//       "picture_url": "http://www.myapp.com/myimage.jpg",
//       "category_id": "cat123",
//       "quantity": 1,
//       "currency_id": "U$",
//       "unit_price": 10
//     }
//   ],
//   "payer": {
//     "phone": {},
//     "identification": {},
//     "address": {}
//   },
//   "payment_methods": {
//     "excluded_payment_methods": [
//       {}
//     ],
//     "excluded_payment_types": [
//       {}
//     ]
//   },
//   "shipments": {
//     "free_methods": [
//       {}
//     ],
//     "receiver_address": {}
//   },
//   "back_urls": {
//
//   },
//   "differential_pricing": {},
//   "tracks": [
//     {
//       "type": "google_ad"
//     }
//   ]
// }'
//      */
//   }
//
//   String? _preferenceId;
//
//   _loadHTML() async {
//     _preferenceId = await _getPreferenceId();
//     if (_preferenceId != null)
//       _content = _makeText();
//       //_con.loadContent(_makeText(), SourceType.urlBypass);
//     else
//       messageError(context, "can't create preference id. Check your Access Token");
//   }
//
//   String _makeText(){
//
//     // // var returnURL = _mainModel.currentBase + "flutterwave_success?booking=${mainModel.lastBooking}";
//     // code = "NGN";
//     // String amount = (widget.amount).toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
//     // // var razorpayName = mainModel.localAppSettings.razorpayName;
//     // var desc = widget.desc; //getTextByLocale(localSettings.price.name);
//     // var userName = _mainModel.account.getCurrentAddress().name;
//     // var userEmail = _mainModel.userEmail;
//     // var userPhone = _mainModel.account.getCurrentAddress().phone;
//     // var userAddress = mainModel.userAccount.getCurrentAddress().name;
//
//     // print("key=$key code=$code amount=$amount razorpayName=$razorpayName");
//     // print("desc=$desc userName=$userName userEmail=$userEmail userPhone=$userPhone userAddress=$userAddress");
//
//     /*
//     <!DOCTYPE html>
//       <html>
//       <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
//       <head><title>MercadoPago Web Payment</title>
//       </head>
//       <body>
//      */
//
//     return '''
//
//
//       <div id="mercadopago_item">
//           <form id="tokenizer" method="GET" />
//       </div>
//
//        <!-- Mercado Pago Client-Side SDK -->
//       <script src="https://sdk.mercadopago.com/js/v2"></script>
//
//       <script>
//
//       // Add the SDK credentials - Public Key
//       const mp = new MercadoPago('$_publicKey', {locale: 'en-US'});
//       // The most common are: 'pt-BR', 'es-AR' and 'en-US'
//       // es-AR es-CL es-CO es-MX es-VE es-UY es-PE pt-BR en-US
//       // TEST-59e115b4-a4b3-4860-883f-0da6e30d4cad
//
//       console.log("MercadoPago start");
//       // Initialize the Web Tokenize Checkout
//       mp.checkout({
//         autoOpen: true,
//        preference: {
//           id: '$_preferenceId'
//         },
//        render: {
//           container: '#tokenizer', // Indicates where the payment button is going to be rendered
//           // label: 'Pay' // Changes the button label (optional)
//        }
//       });
//
//       // window.addEventListener('unload', function (e) {
//       //       console.log("MercadoPago unload");
//       //   });
//       //   window.addEventListener('onCloseWindow', function (e) {
//       //       console.log("MercadoPago onCloseWindow");
//       //   });
//       //
//       //  window.addEventListener('onCloseWindow', function (e) {
//       //       console.log("MercadoPago onCloseWindow");
//       //   });
//       //   window.addEventListener('modalclose', function (e) {
//       //       console.log("MercadoPago modalclose");
//       //   });
//
//       // window.addEventListener('load', function (e) {
//       //       // e.preventDefault();
//       //       // e.returnValue = '';
//       //       console.log("MercadoPago load");
//       //       //window.parent.postMessage("MODAL_CLOSED","*");   //3
//       //   });
//
//         // window.addEventListener("DOMNodeRemovedFromDocument", function (event) {
//         //   console.log("DOMNodeRemovedFromDocument");
//         //   console.log(event);
//         //   console.log(event.target);
//         // }, false);
//         // window.addEventListener("DOMNodeRemoved", function (e) {
//         //   console.log("DOMNodeRemoved");
//         //   console.log(e);
//         //   console.log(e.target);
//         //   // window.parent.postMessage("MODAL_CLOSED","*");   //3
//         // }, false);
//
//
//    console.log("document.getElementById");
//    // var frame = document.getElementsByTagName('flt-platform-view-slot');
//    var frame = document.getElementById("iframe");
//
//    // var frame = document.querySelector('flt-platform-view');
//    console.log(frame);
//    // var frame2 = frame.shadowRoot;
//    // console.log(frame2);
//    // var frame3 = frame2.querySelector('iframe');
//    // console.log(frame3);
//
//    // console.log(frame[0]);
//    // frame[0].shadowRoot.getElementById('iframe');
//
//    // console.log(document.getElementById("mercadopago_item"));
//    //
//    // console.log(document.getElementById("iframe"));
//    // console.log(document.getElementById("__privateStripeMetricsController6860"));
//
// </script>
//
//         ''';
//
//     /*
//     </body>
// </html>
//      */
//   }
//
// }
//

Future<String?> getPreferenceId(double amount, String desc, BuildContext context, String _accessToken) async {
  var code = appSettings.code;
  String returnURL = "";
  String cancelURL = '';
  returnURL = currentBase + "mercadopago_success?booking=$cartLastAddedId";
  cancelURL = currentBase + "mercadopago_cancel?booking=$cartLastAddedId";

  var response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      body: convert.jsonEncode({
        "items": [
          {
            "title": desc,
            "description": "",
            "picture_url": "http://www.myapp.com/myimage.jpg",
            "category_id": "cat123",
            "quantity": 1,
            "currency_id": code, // "BRL",
            // "currency_id": "BRL",
            "unit_price": amount
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
          "success": returnURL,
          "failure": cancelURL,
          "pending": returnURL
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
        'Authorization': 'Bearer ' + _accessToken // Access Token
      });

  final body = convert.jsonDecode(response.body);
  if (response.statusCode == 201) {
    return body["id"];
  } else
    messageError(context, body["message"]);

  return null;
}