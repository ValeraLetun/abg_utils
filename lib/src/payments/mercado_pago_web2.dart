@JS()
library stripe;

import 'package:js/js.dart';

void redirectToMPCheckout(String _publicKey, String _preferenceId) async {
  final mp = MercadoPago(_publicKey,
      Locale(
        locale: 'en-US'
        ));

  // print("redirectToStripeCheckout ${_mainModel.currentBase}stripe_success");
  try{
    mp.checkout(CheckoutOptions(
      autoOpen: true,
      preference: CheckoutPreference(
        id: _preferenceId
      ),
      render: CheckoutRender(
        container: 'tokenizer', // Indicates where the payment button is going to be rendered
        // label: 'Pay' // Changes the button label (optional)
      )
    ));

    // stripe.redirectToCheckout(CheckoutOptions(
    //   lineItems: [
    //     LineItem(price: _priceId, quantity: 1),
    //   ],
    //   mode: 'payment',
    //   successUrl: _mainModel.currentBase + "stripe_success?booking=${_mainModel.lastBooking}",
    //   cancelUrl: _mainModel.currentBase + "stripe_cancel?booking=${_mainModel.lastBooking}",
    // ));
  }catch(ex){
    print(ex.toString());
  }
}

@JS()
class MercadoPago {
  external MercadoPago(String key, Locale locale);

  external checkout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external bool get autoOpen;
  external CheckoutPreference get preference;
  external CheckoutRender get render;

  external factory CheckoutOptions({
    bool autoOpen,
    CheckoutPreference preference,
    CheckoutRender render
  });
}

@JS()
@anonymous
class CheckoutPreference {
  external String get id;
  external factory CheckoutPreference({
    String id
  });
}

@JS()
@anonymous
class CheckoutRender {
  external String get container;
  external factory CheckoutRender({
    String container
  });
}

@JS()
@anonymous
class Locale {
  external String get locale;
  external factory Locale({
    String locale
  });
}
