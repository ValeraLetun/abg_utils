import 'dart:convert';
import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/src/payments/stripe_web2.dart';
import 'package:http/http.dart' as http;

stripeWeb(double _total, String desc) async {
  try {
    // double _total = getTotal() * 100;
    // var t = 0;
    // _total = 100000;
    var uname = appSettings.stripeSecretKey;
    // var pword = '';
    //var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
    var authn = 'Bearer $uname';
    Map<String, dynamic> map = {};
    var _name = desc; //getTextByLocale(price.name, strings.locale);
    map['name'] = _name;
    var response = await http.post(Uri.parse('https://api.stripe.com/v1/products'), headers: {'Authorization': authn}, body: map);
    dprint(response.body);
    var jsonResult = json.decode(response.body);
    if (response.statusCode != 200) return 'http.post error: statusCode= ${response.statusCode} ${jsonResult["error"]["message"]}';
    var productId = jsonResult["id"];
    //
    Map<String, dynamic> map2 = {};
    map2['product'] = productId;
    map2['unit_amount'] = (_total*100).toStringAsFixed(0);
    map2['currency'] = appSettings.code;
    response = await http.post(Uri.parse('https://api.stripe.com/v1/prices'), headers: {'Authorization': authn}, body: map2);
    if (response.statusCode != 200) return 'http.post error: statusCode= ${response.statusCode}';
    print(response.body);
    jsonResult = json.decode(response.body);
    var priceId = jsonResult["id"];
    redirectToStripeCheckout(appSettings.stripeKey, priceId);
  }catch(ex){
    return "stripeStart " + ex.toString();
  }
}

