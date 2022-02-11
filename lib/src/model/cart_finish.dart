import 'package:firebase_auth/firebase_auth.dart';
import '../../abg_utils.dart';

Future<String?> finishCartV1(ProductData currentService, bool temporary, String paymentMethodId,
    String stringFromUser, /// strings.get(160) /// "From user:",
    String stringNewBooking, /// strings.get(157) /// "New Booking was arrived",
) async{
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "finishCartV1 user == null";

  List<AddonData> _addon = [];
  if (currentService.addon.isNotEmpty)
    for (var item in currentService.addon) {
      if (!item.selected)
        continue;
      _addon.add(item);
    }

  try{
    var _provider = ProviderData.createEmpty();
    for (var item in providers)
      if (item.id == currentService.providers[0])
        _provider = item;
    if (_provider.id.isEmpty)
      return "Provider not found. _provider.id.isEmpty";

    var _data = OrderData(
      status: temporary ? "temp" : appSettings.statuses[0].id,
      history: [StatusHistory(
          statusId: appSettings.statuses[0].id,
          time: DateTime.now().toUtc(),
          byCustomer: true,
          activateUserId : user.uid
      )],
      customerId: user.uid,
      customer: userAccountData.userName,
      customerAvatar: userAccountData.userAvatar,
      providerId: _provider.id,
      provider: _provider.name,
      providerPhone: _provider.phone,
      providerAvatar: _provider.imageUpperServerPath,
      serviceId: currentService.id,
      service: currentService.name,
      // price
      price: price.price,
      discPrice: price.discPrice,
      priceUnit: price.priceUnit,
      count: countProduct,
      priceName: price.name,
      // coupon
      couponId: couponId,
      couponName: couponId.isEmpty ? "" : couponCode,
      discount: couponId.isEmpty ? 0 : discount,
      discountType: couponId.isEmpty ? "fixed" : discountType,
      //
      tax: currentService.tax,
      taxAdmin: currentService.taxAdmin,
      total: getTotal(),
      paymentMethod: paymentMethodId,
      //
      comment: cartHint,
      address: getCurrentAddress().address,
      anyTime: cartAnyTime,
      selectTime: cartSelectTime,
      //
      time: DateTime.now(),
      timeModify: DateTime.now(),
      //
      viewByAdmin: false,
      viewByProvider: false,
      //
      addon: _addon,
      products: [],
      customerPhone: getCurrentAddress().phone,
      customerEmail: userAccountData.userEmail,
    );
    await cartFinish(_data);
    // var retBooking = await FirebaseFirestore.instance.collection("booking").add(_data);
    if (!temporary){
      // await FirebaseFirestore.instance.collection("settings").doc("main")
      //     .set({"booking_count": FieldValue.increment(1)}, SetOptions(merge:true));
      // await FirebaseFirestore.instance.collection("settings").doc("main")
      //     .set({"booking_count_unread": FieldValue.increment(1)}, SetOptions(merge:true));
      // var ret = await loadUsers(this);
      // if (ret != null)
      //   return ret;
      // var _provider2 = getProviderById(_provider.id);
      // if (_provider2 != null){
        UserData? _user = await getProviderUserByEmail(_provider.login);
        if (_user != null)
          sendMessage("$stringFromUser ${userAccountData.userName}",  /// "From user:",
              stringNewBooking,  /// "New Booking was arrived",
              _user.id, true, appSettings.cloudKey);
        }
      // sendMessage("${strings.get(117)} $userName",  /// "From user:",
      //     strings.get(118),  /// "New Booking was arrived",
      //     getProviderId(_provider.login));
    // }
  }catch(ex){
    return "finish " + ex.toString();
  }
}

Future<String?> finishCartV4(bool temporary, String paymentMethodId,
    bool cachePayment,
    String stringFromUser, /// strings.get(160) /// "From user:",
    String stringNewBooking, /// strings.get(157) /// "New Booking was arrived",
    ) async{
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "finishCartV4 user == null";
  if (cartCurrentProvider == null)
    return "finish cartCurrentProvider = null";

  try{
    var _products = cartGetProductsForBooking();
    for (var item in _products){
      List<AddonData> _addon = [];
      for (var item in item.addon)
        if (item.selected)
          _addon.add(item);
      // if (item.addon.isNotEmpty)
      //   for (var item in currentService.addon) {
      //     if (!item.selected)
      //       continue;
      //     _addon.add(item);
      //   }
      item.addon = _addon;
    }

    var _totalPrice = cartGetTotalForAllServices();
    var _data = OrderData(
      status: temporary ? "temp" : appSettings.statuses[0].id,
      history: [StatusHistory(
          statusId: appSettings.statuses[0].id,
          time: DateTime.now().toUtc(),
          byCustomer: true,
          activateUserId : user.uid
      )],
      customerId: user.uid,
      customer: getCurrentAddress().name,
      customerAvatar: userAccountData.userAvatar,
      providerId: cartCurrentProvider!.id,
      provider: cartCurrentProvider!.name,
      providerPhone: cartCurrentProvider!.phone,
      providerAvatar: cartCurrentProvider!.imageUpperServerPath,
      serviceId: "",
      service: [],
      serviceImage: cartGetImage(),
      // price
      price: 0,
      discPrice: 0,
      priceUnit: "",
      count: 0,
      priceName: [],
      // coupon
      couponId: couponId,
      couponName: couponId.isEmpty ? "" : couponCode,
      discount: couponId.isEmpty ? 0 : discount,
      discountType: couponId.isEmpty ? "fixed" : discountType,
      //
      tax: 0,
      taxAdmin: 0,
      total: _totalPrice.total,
      paymentMethod: paymentMethodId,
      paymentMethodCache: cachePayment,
      //
      comment: cartHint,
      address: getCurrentAddress().address,
      anyTime: cartAnyTime,
      selectTime: cartSelectTime,
      //
      time: DateTime.now(),
      timeModify: DateTime.now(),
      viewByAdmin: false,
      viewByProvider: false,
      //
      addon: [],
      products: _products,
      ver4: true,
      customerPhone: getCurrentAddress().phone,
      customerEmail: userAccountData.userEmail,
    );
    await cartFinish(_data);
    if (!temporary){
      var _provider = getProviderById(cartCurrentProvider!.id);
      if (_provider != null){
        UserData? _user = await getProviderUserByEmail(_provider.login);
        if (_user != null)
          sendMessage("$stringFromUser ${userAccountData.userName}",  /// "From user:",
            stringNewBooking,  /// "New Booking was arrived",
            _user.id, true, appSettings.cloudKey);
        clearCart();
      }
    }
  }catch(ex){
    return "finish:ver4 " + ex.toString();
  }
}

Future<String?> finishDelete() async{
  if (cartLastAddedId.isNotEmpty){
    try{
      await dbDeleteDocumentInTable("booking", cartLastAddedId);
      //FirebaseFirestore.instance.collection("booking").doc(cartLastAddedId).delete();
    }catch(ex) {
      return "finishDelete " + ex.toString();
    }
  }
}

String cartLastAddedIdToUser = "";

Future<String?> finish2(
    bool payPalSuccess, String payPalPaymentId,
    bool flutterwave,
    bool mercadoPagoSuccess, String mercadoPagoTransactionId
    ) async{
  if (cartLastAddedId.isNotEmpty){
    try{
      var _lastBooking = cartLastAddedId;
      cartLastAddedIdToUser = cartLastAddedId;
      cartLastAddedId = "";

      var _count = 0;
      do {
        await Future.delayed(Duration(seconds: 2));
        dprint("finish2 wait 1 seconds");
        _count++;
        if (_count == 10)
          break;
      }while (appSettings.statuses.isEmpty);

      var _status = "";
      if (appSettings.statuses.isNotEmpty)
        _status = appSettings.statuses[0].id;

      saveInCacheStatus(_lastBooking, _status);

      // await FirebaseFirestore.instance.collection("settings").doc("main")
      //     .set({"booking_count": FieldValue.increment(1)}, SetOptions(merge:true));
      // await FirebaseFirestore.instance.collection("settings").doc("main")
      //     .set({"booking_count_unread": FieldValue.increment(1)}, SetOptions(merge:true));

      await dbSetDocumentInTable("booking", _lastBooking, {
        'status': _status,
        'viewByAdmin': false,
        'viewByProvider': false,
        "timeModify": DateTime.now().toUtc(),
      });

      // await FirebaseFirestore.instance.collection("booking").doc(_lastBooking).set({
      //   'status': _status,
      //   'viewByAdmin': false,
      //   'viewByProvider': false,
      //   "timeModify": DateTime.now().toUtc(),
      // }, SetOptions(merge:true));

      if (payPalSuccess)
        await dbSetDocumentInTable("booking", _lastBooking, {
          'paymentMethod': "PayPal $payPalPaymentId",
          "timeModify": DateTime.now().toUtc(),
        });

        // await FirebaseFirestore.instance.collection("booking").doc(_lastBooking).set({
        //   'paymentMethod': "PayPal $payPalPaymentId",
        //   "timeModify": DateTime.now().toUtc(),
        // }, SetOptions(merge:true));

      if (flutterwave) {
        await dbSetDocumentInTable("booking", _lastBooking, {
          'paymentMethod': "Flutterwave $cartLastAddedId",
          "timeModify": DateTime.now().toUtc(),
        });
        // await FirebaseFirestore.instance.collection("booking").doc(_lastBooking).set({
        //   'paymentMethod': "Flutterwave $cartLastAddedId",
        //   "timeModify": DateTime.now().toUtc(),
        // }, SetOptions(merge:true));
      }

      if (mercadoPagoSuccess)
        await dbSetDocumentInTable("booking", _lastBooking, {
          'paymentMethod': "MercadoPago $mercadoPagoTransactionId",
          "timeModify": DateTime.now().toUtc(),
        });
        // await FirebaseFirestore.instance.collection("booking").doc(_lastBooking).set({
        //   'paymentMethod': "MercadoPago $mercadoPagoTransactionId",
        //   "timeModify": DateTime.now().toUtc(),
        // }, SetOptions(merge:true));

    }catch(ex) {
      return "finish2 " + ex.toString();
    }
  }
  return null;
}
