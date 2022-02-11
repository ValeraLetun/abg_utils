import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webviewx/webviewx.dart';

/*

08.11.2021 не удалось запустить - как ни пытался


Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RazorpayPayment(
              code: "USD", //_mainModel.localAppSettings.code,
              razorpayKey: _mainModel.localAppSettings.razorpayKey,
              razorpayName: _mainModel.localAppSettings.razorpayName,
              desc: "",
              userName: _mainModel.account.getCurrentAddress().name,
              userEmail: _mainModel.userEmail,
              userPhone: _mainModel.account.getCurrentAddress().phone,
              userAddress: _mainModel.account.getCurrentAddress().name,
              amount: _total,
              onFinish: (w){
                _appointment("RP: $w");
              }
          ),
        ),
      );

 */



class RazorpayPayment extends StatefulWidget{
  final Function(String) onFinish;
  final String code;
  final String razorpayKey;
  final String razorpayName;
  final String desc;
  final int amount;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userAddress;

  RazorpayPayment({required this.razorpayKey, required this.onFinish,
    required this.code, required this.razorpayName, required this.desc,
    required this.userName, required this.userEmail, required this.userPhone, required this.userAddress,
    required this.amount});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  late String checkoutUrl;

  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //     crossPlatform: InAppWebViewOptions(
  //       useShouldOverrideUrlLoading: true,
  //       mediaPlaybackRequiresUserGesture: false,
  //     ),
  //     android: AndroidInAppWebViewOptions(
  //       useHybridComposition: true,
  //     ),
  //     ios: IOSInAppWebViewOptions(
  //       allowsInlineMediaPlayback: true,
  //     ));

  @override
  void initState() {
    checkoutUrl = _makeText();

    if (Platform.isAndroid)
      WebView.platform = SurfaceAndroidWebView();
    // CupertinoWebView

    super.initState();
  }

  // WebViewController? _controller;
  // bool _start = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Center(child: Text("PayPal Payment")),
      ),
      body: WebView(
        initialUrl: "",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller){
          // _controller = controller;
          controller.loadUrl(Uri.dataFromString(checkoutUrl,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8')
          ).toString());
        },
        javascriptChannels: {
          JavascriptChannel(
              name: 'messageHandler',
              onMessageReceived: (JavascriptMessage message) {
                //This is where you receive message from
                //javascript code and handle in Flutter/Dart
                //like here, the message is just being printed
                //in Run/LogCat window of android studio
                print(message.message);
              })
        },
        navigationDelegate: (NavigationRequest request) {
          print(request.url);
          if (request.url.contains("https://www.example.com/")){
            final uri = Uri.parse(request.url);
            final postMessage = uri.queryParameters['postMessage'];
            if (postMessage != null) {
              if (postMessage == "SUCCESS"){
                final id = uri.queryParameters['id'];
                if (id != null) {
                  widget.onFinish(id);
                  Navigator.of(context).pop();
                }
              }
              if (postMessage == "MODAL_CLOSED")
                Navigator.of(context).pop();
            }
          }
          // if (request.url.contains(returnURL)) {
          //   final uri = Uri.parse(request.url);
          //   final payerID = uri.queryParameters['PayerID'];
          //   if (payerID != null) {
          //     services.executePayment(executeUrl, payerID, accessToken)
          //         .then((List<String>? ls) {
          //       print("paymentMethod: $payerID $accessToken ${ls![0]}");
          //       setState(() {
          //         payResponse = ls;
          //       });
          //       widget.onFinish(ls[0]);
          //       Navigator.of(context).pop();
          //     });
          //   } else
          //     Navigator.of(context).pop();
          // }
          // if (request.url.contains(cancelURL)) {
          //   Navigator.of(context).pop();
          // }
          return NavigationDecision.navigate;
        },
      ),
    );

    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: PreferredSize(
    //     preferredSize: const Size.fromHeight(50),
    //     child: Center(child: Text("RazorPay Payment")),
    //   ),
    //   body: InAppWebView(
    //     initialOptions: options,
    //     initialUrlRequest: URLRequest(url: Uri.parse("")),
    //     onWebViewCreated: (webViewController) {
    //       var _con = webViewController;
    //       _con.loadData(data: checkoutUrl);
    //     },
    //     onJsAlert: (InAppWebViewController controller, JsAlertRequest jsAlertRequest) async{
    //       return JsAlertResponse(message: jsAlertRequest.message != null ? jsAlertRequest.message! : "error");
    //     },
    //     onLoadResource: (controller, LoadedResource resource){
    //       print("onLoadResource=${resource.url}");
    //     },
    //     onLoadStart: (controller, url){
    //       print("onLoadStart=$url");
    //     },
    //     onLoadStop: (controller, url){
    //       print("onLoadStop=$url");
    //     },
    //     onReceivedClientCertRequest: (controller,
    //         URLAuthenticationChallenge challenge) async{
    //       return null;
    //     },
    //     shouldOverrideUrlLoading: (controller, NavigationAction navigationAction) async{
    //       return null;
    //     },
    //     shouldInterceptAjaxRequest: (controller, AjaxRequest ajaxRequest) async{
    //       return null;
    //     },
    //     shouldInterceptFetchRequest:(controller, FetchRequest fetchRequest) async{
    //       return null;
    //     },
    //     onWindowBlur: (controller){
    //       print("onWindowBlur");
    //     },
    //     onReceivedServerTrustAuthRequest: (InAppWebViewController controller,
    //         URLAuthenticationChallenge challenge) async{
    //       return null;
    //     },
    //     onUpdateVisitedHistory: (controller, Uri? url, bool? androidIsReload){
    //       print("onUpdateVisitedHistory");
    //     },
    //     onReceivedHttpAuthRequest: (InAppWebViewController controller,
    //       URLAuthenticationChallenge challenge) async{
    //        return null;
    //       },
    //     onConsoleMessage: (controller, consoleMessage) {
    //       print(consoleMessage);
    //     },
    //     onLoadError: (controller, url, code, message) {
    //       print("onLoadError $message");
    //     },
    //     onLoadHttpError: (controller, url, code, message) {
    //       print("onLoadHttpError $message");
    //     },
    //     onProgressChanged: (controller, progress){
    //       print("onProgressChanged $progress");
    //     },
    //     // navigationDelegate: (NavigationRequest request) {
    //     //   print("request.url=${request.content.source}");
    //     //   // if (request.url.contains(returnURL)) {
    //     //   //   final uri = Uri.parse(request.url);
    //     //   //   final payerID = uri.queryParameters['PayerID'];
    //     //   //   if (payerID != null) {
    //     //   //     services.executePayment(executeUrl, payerID, accessToken)
    //     //   //         .then((List<String>? ls) {
    //     //   //       print("paymentMethod: $payerID $accessToken ${ls![0]}");
    //     //   //       setState(() {
    //     //   //         payResponse = ls;
    //     //   //       });
    //     //   //       widget.onFinish(ls[0]);
    //     //   //       Navigator.of(context).pop();
    //     //   //     });
    //     //   //   } else
    //     //   //     Navigator.of(context).pop();
    //     //   // }
    //     //   // if (request.url.contains(cancelURL)) {
    //     //   //   Navigator.of(context).pop();
    //     //   // }
    //     //   return NavigationDecision.navigate;
    //     // },
    //   ),
    //   );
    // }

    // // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory("rzp-html",(int viewId) {
    //   IFrameElement element = IFrameElement();
    //   window.onMessage.forEach((element) async {
    //     print('Event Received in callback: ${element.data}');
    //     if(element.data=='MODAL_CLOSED'){
    //       widget.close();
    //       //Navigator.pop(context);
    //     }
    //     else {
    //       if (_success == 1) {
    //         widget.mainModel.paymentMethodId = "Razorpay ${element.data}";
    //         widget.mainModel.razorpaySuccess = true;
    //         print("mainModel.paymentMethodId=${widget.mainModel.paymentMethodId}");
    //         var ret = await widget.mainModel.finish(false);
    //         if (ret != null)
    //           return messageError(context, ret);
    //         widget.mainModel.clearBookData();
    //         widget.mainModel.route("payment_success");
    //         _success = 2;
    //       }
    //       if (element.data == 'SUCCESS') {
    //         print('PAYMENT SUCCESSFULL!!!!!!!');
    //         _success = 1;
    //       }
    //     }
    //   });
    //
    //   // element.width = '400';
    //   // element.height = '400';
    //   // element.src = 'https://www.youtube.com/embed/IyFZznAk69U';
    //   // element.src=Uri.dataFromString('<html><body><iframe src="https://www.youtube.com/embed/abc"></iframe></body></html>', mimeType: 'text/html').toString();
    //   element.src=Uri.dataFromString(_makeText(), mimeType: 'text/html').toString();
    //   // element.src='assets/razorpay.html?name=name&price=200&image=';
    //   // element.src='assets/payments.html?name=$name&price=$price&image=$image';
    //   element.style.border = 'none';
    //
    //   return element;
    // });
    // return Container(
    //     // width: 500,
    //     // height: 500,
    //     child: HtmlElementView(viewType: 'rzp-html'),
    //   );
  }

  String _makeText(){
    // print("key=$key code=$code amount=$amount razorpayName=$razorpayName");
    // print("desc=$desc userName=$userName userEmail=$userEmail userPhone=$userPhone userAddress=$userAddress");

    return '''<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width">
<head><title>RazorPay Web Payment</title></head>
<body>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
const queryString = window.location.search;
console.log(queryString);
//const urlParams = new URLSearchParams(queryString);
//const name = urlParams.get('name')
//const price = urlParams.get('price')
//const image = urlParams.get('image')
//const email = urlParams.get('email')
options = {
     "key": "${widget.razorpayKey}",
          "amount": '${widget.amount}',
          "currency": "${widget.code}",         
          "name":"${widget.razorpayName}",
          "description": "${widget.desc}",
          "image": "",
          "handler": function (response){
            // console.log("SUCCESS");
            Print.postMessage('postMessage=SUCCESS');
            //window.location.href = 'https://www.example.com/?postMessage=SUCCESS&id=' + response.razorpay_payment_id;
          },        
          "prefill": {        
             "name": "${widget.userName}",        
             "email":"${widget.userEmail}",
             "contact":"${widget.userPhone}"  
           },   
           "notes": {        
             "address": "${widget.userAddress}"    
          },    
    "theme": {
       "color": "#DF0145"    
    },
    "modal": {
      "ondismiss": function(){
          // window.location.href = 'https://www.example.com/?postMessage=MODAL_CLOSED';
          //  console.log("MODAL_CLOSED");
      }
    }
 };
 var rzp1 = new Razorpay(options);
 rzp1.on('payment.failed', function (response){
        console.log(response.error.code);
        console.log(response.error.description);
        console.log(response.error.source);
        console.log(response.error.step);
        console.log(response.error.reason);
        console.log(response.error.metadata.order_id);
        console.log(response.error.metadata.payment_id);
});
 
 window.onload = function(e){  //1
    rzp1.open();
    e.preventDefault();
 }
 
 console.log("init");

</script>
</body>
</html>
        ''';
  }
}

