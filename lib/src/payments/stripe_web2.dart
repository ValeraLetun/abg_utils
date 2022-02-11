@JS()
library stripe;

import 'package:abg_utils/abg_utils.dart';
import 'package:js/js.dart';

void redirectToStripeCheckout(String apiKey, String _priceId) async {
  final stripe = Stripe(apiKey);

  dprint("redirectToStripeCheckout ${currentBase}stripe_success");
  try{
    stripe.redirectToCheckout(CheckoutOptions(
      lineItems: [
        LineItem(price: _priceId, quantity: 1),
      ],
      mode: 'payment',
      successUrl: currentBase + "stripe_success?booking=$cartLastAddedId",
      cancelUrl: currentBase + "stripe_cancel?booking=$cartLastAddedId",
    ));
  }catch(ex){
    dprint("redirectToStripeCheckout " + ex.toString());
  }
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}