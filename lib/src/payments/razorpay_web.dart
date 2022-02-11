import 'package:universal_html/html.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:abg_utils/abg_utils.dart';

class RazorpayPayment extends StatefulWidget{
  final Function() close;
  final double amount;
  final String desc;
  final Function(String) success;
  RazorpayPayment({required this.close, required this.success, required this.amount,
    required this.desc});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  int _success = 0;

  @override
  Widget build(BuildContext context) {

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("rzp-html",(int viewId) {
      IFrameElement element = IFrameElement();
      window.onMessage.forEach((element) async {
        print('Event Received in callback: ${element.data}');
        if(element.data=='MODAL_CLOSED'){
          widget.close();
          //Navigator.pop(context);
        }
        else {
          if (_success == 1) {
            widget.success(element.data);
            _success = 2;
          }
          if (element.data == 'SUCCESS') {
            print('PAYMENT SUCCESSFULL!!!!!!!');
            _success = 1;
          }
        }
      });

      // element.width = '400';
      // element.height = '400';
      // element.src = 'https://www.youtube.com/embed/IyFZznAk69U';
      // element.src=Uri.dataFromString('<html><body><iframe src="https://www.youtube.com/embed/abc"></iframe></body></html>', mimeType: 'text/html').toString();
      element.src=Uri.dataFromString(_makeText(), mimeType: 'text/html').toString();
      // element.src='assets/razorpay.html?name=name&price=200&image=';
      // element.src='assets/payments.html?name=$name&price=$price&image=$image';
      element.style.border = 'none';

      return element;
    });
    return Container(
        // width: 500,
        // height: 500,
        child: HtmlElementView(viewType: 'rzp-html'),
      );
  }

  String _makeText(){
    var code = appSettings.code;
    // code = "USD";
    var key = appSettings.razorpayKey;
    var amount = (widget.amount * 100).toInt();
    var razorpayName = appSettings.razorpayName;
    //var desc = getTextByLocale(price.name, locale);
    var userName = getCurrentAddress().name;
    var userEmail = userAccountData.userEmail;
    var userPhone = getCurrentAddress().phone;
    var userAddress = getCurrentAddress().name;

    dprint("key=$key code=$code amount=$amount razorpayName=$razorpayName");
    dprint("desc=${widget.desc} userName=$userName userEmail=$userEmail userPhone=$userPhone userAddress=$userAddress");

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
     "key": "$key",
          "amount": '$amount',
          "currency": "$code",         
          "name":"$razorpayName",
          "description": "${widget.desc}",
          "image": "",
          "handler": function (response){
             window.parent.postMessage("SUCCESS","*");      //2 
             window.parent.postMessage(response.razorpay_payment_id,"*");      //2
             // alert(response.razorpay_payment_id);
             // alert(response.razorpay_order_id);
             // alert(response.razorpay_signature)    
          },        
          "prefill": {        
             "name": "$userName",        
             "email":"$userEmail",
             "contact":"$userPhone"  
           },   
           "notes": {        
             "address": "$userAddress"    
          },    
    "theme": {
       "color": "#DF0145"    
    },
    "modal": {
      "ondismiss": function(){
         window.parent.postMessage("MODAL_CLOSED","*");   //3
      }
    }
 };
 var rzp1 = new Razorpay(options);
 window.onload = function(e){  //1  
    rzp1.open();
    e.preventDefault();
 }

</script>
</body>
</html>
        ''';
  }
}

