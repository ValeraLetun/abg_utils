import 'package:abg_utils/abg_utils.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FlutterwavePayment extends StatelessWidget{
  final double amount;
  final String desc;
  final Function() close;
  FlutterwavePayment({required this.amount, required this.desc, required this.close});

  @override
  Widget build(BuildContext context) {

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("fw-html", (int viewId) {
      IFrameElement element = IFrameElement();

      window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');
        if (element.data == 'MODAL_CLOSED') {
          print('MODAL_CLOSED');
          close();
        }
        else if (element.data == 'SUCCESS') {
          print('PAYMENT SUCCESSFULL!!!!!!!');
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
        child: HtmlElementView(viewType: 'fw-html'),
      );
  }

  String _makeText(){
    var code = appSettings.code;
    var returnURL = currentBase + "flutterwave_success?booking=$cartLastAddedId";
    // code = "USD";
    var _amount = amount.toStringAsFixed(appSettings.digitsAfterComma);
    // var razorpayName = mainModel.localAppSettings.razorpayName;
    // var desc = getTextByLocale(price.name, locale);
    var userName = getCurrentAddress().name;
    var userEmail = userAccountData.userEmail;
    var userPhone = getCurrentAddress().phone;
    // var userAddress = mainModel.userAccount.getCurrentAddress().name;

    // print("key=$key code=$code amount=$amount razorpayName=$razorpayName");
    // print("desc=$desc userName=$userName userEmail=$userEmail userPhone=$userPhone userAddress=$userAddress");

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
      public_key: "${appSettings.flutterWavePublicKey}",
      tx_ref: "$cartLastAddedId",
      amount: $_amount, 
      currency: "$code",
      country: "US",
      payment_options: " ",
      redirect_url: // specified redirect URL
        "$returnURL",
      meta: {
        consumer_id: 23,
        consumer_mac: "92a3-912ba-1192a",
      },
      customer: {
        email: "$userEmail",
        phone_number: "$userPhone",
        name: "$userName",
      },
      callback: function (data) {
        console.log("Flutterwave callback");
        console.log(data);
      },
      onclose: function() {
        console.log("Flutterwave MODAL_CLOSED");
        window.parent.postMessage("MODAL_CLOSED","*");   //3
      },
      customizations: {
        title: "My store",
        description: "$desc",
        logo: "",
      },
    });
 
</script>
</body>
</html>
        ''';
  }

}
//
// Future<String?> flutterwaveGetId(MainModel _mainModel) async {
//
//   _mainModel.flutterwaveTransactionId = "2567994";
//   _mainModel.flutterwaveCheckId = false;
//
//   if (_mainModel.flutterwaveCheckId)
//     return null;
//   if (_mainModel.flutterwaveTransactionId.isEmpty)
//     return "flutterwaveTransactionId.isEmpty";
//
//   _mainModel.flutterwaveCheckId = true;
//
//   // curl --location --request GET 'https://api.flutterwave.com/v3/transactions/2567994/verify' \
//   // --header 'Content-Type: application/json' \
//   // --header 'Authorization: Bearer {{SEC_KEY}}'
//   try{
//     var response = await http.get(Uri.parse(
//         'https://api.flutterwave.com/v3/transactions/${_mainModel
//             .flutterwaveTransactionId}/verify'),
//       headers: {
//         'Content-Type': "application/json",
//         "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
//         "Access-Control-Allow-Origin": "*",
//         'Authorization': "Bearer FLWSECK_TEST-f288dc21284fbf1bc7dff1d91a92cbd2-X"
//       },);
//     print("flutterwaveGetId " + response.body);
//     print("flutterwaveGetId response.statusCode=${response.statusCode}");
//     if (response.statusCode != 200)
//       return 'http.get error: statusCode= ${response.statusCode}';
//     var jsonResult = json.decode(response.body);
//     print("flutterwaveGetId status=${jsonResult["status"]}");
//     if (jsonResult["status"] != "success")
//       return jsonResult["message"];
//
//     var t = jsonResult["data"]["flw_ref"];
//     print("Flutterwave $t");
//     _mainModel.flutterwaveId = t;
//   }catch(ex){
//     print(ex.toString());
//   }
//
//   return null;
// }