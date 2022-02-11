import 'package:razorpay_flutter_31/razorpay_flutter_31.dart';

//
// https://razorpay.com/docs/payment-gateway/flutter-integration/
//
class RazorpayMobile{

  final _razorpay = Razorpay();

  Function(String)? _onSuccess;
  Function(String)? _onError;

  init(){
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.paymentId);
    print(response.orderId);
    print(response.signature);
    if (_onSuccess != null)
      _onSuccess!("Payment $summa Razorpay:${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    var msg = "ERROR: " + response.code.toString();
    print(msg);
    if (_onError != null)
      _onError!(msg);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: ${response.walletName}");
  }

  String summa = "";

  void openCheckout(String amount, String desc, String clientPhone, String companyName, String currency, String razorpayId,
      Function(String) onSuccess, Function(String) onError) async {
    summa = "$currency${int.parse(amount)/100}";
    _onError = onError;
    _onSuccess = onSuccess;
    var options = {
      'key': razorpayId,
      'amount': amount,
      'currency' : currency,
      'name': companyName,
      'description': desc,
      'prefill': {'contact': clientPhone, 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }
}

