import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../abg_utils.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

// 17.12.2021

List<OrderDataCache> ordersDataCache = [];
OrderData currentOrder = OrderData.createEmpty();

int getActiveBookingCount(){
  var count = 0;
  for (var item in ordersDataCache) {
    if (item.finished)
      continue;
    if (cancelStatus != null && item.status == cancelStatus!.id)
      continue;
    if (firstStatus != null && item.status == firstStatus!.id)
      continue;
    if (finishStatus != null && item.status == finishStatus!.id)
      continue;
    count++;
  }
  return count;
}

List<OrderDataCache> getActiveBookings(){
  List<OrderDataCache> list = [];
  for (var item in ordersDataCache) {
    if (item.finished)
      continue;
    if (cancelStatus != null && item.status == cancelStatus!.id)
      continue;
    if (firstStatus != null && item.status == firstStatus!.id)
      continue;
    if (finishStatus != null && item.status == finishStatus!.id)
      continue;
    list.add(item);
  }
  return list;
}

int getUnreadCountByAdmin(){
  int _count = 0;
  for (var item in ordersDataCache)
    if (!item.viewByAdmin)
      _count++;
  return _count;
}

setBookingViewByAdminToNull() async {
  Map<String, dynamic> _toWrite = {};
  for (var item in ordersDataCache){
    if (!item.viewByAdmin){
      item.viewByAdmin = true;
      await FirebaseFirestore.instance.collection("booking").doc(item.id)
       .set({"viewByAdmin": true}, SetOptions(merge: true));
      _toWrite.addAll({
        item.id: item.toJson(migrate: true),
      });
    }
  }
  if (_toWrite.isNotEmpty)
    await FirebaseFirestore.instance.collection("cache").doc("orders")
        .set(_toWrite, SetOptions(merge:true));
}

int getUnreadCountByProvider(String providerId){
  int _count = 0;
  for (var item in ordersDataCache)
    if (item.providerId == providerId)
      if (!item.viewByProvider)
        _count++;
  return _count;
}

setBookingViewByProviderToNull(String providerId) async {
  Map<String, dynamic> _toWrite = {};
  for (var item in ordersDataCache){
    if (!item.viewByProvider){
      item.viewByProvider = true;
      await FirebaseFirestore.instance.collection("booking").doc(item.id)
          .set({"viewByProvider": true}, SetOptions(merge: true));
      _toWrite.addAll({
        item.id: item.toJson(migrate: true),
      });
    }
  }
  if (_toWrite.isNotEmpty)
    await FirebaseFirestore.instance.collection("cache").doc("orders")
        .set(_toWrite, SetOptions(merge:true));
}


bool isPassed(StatusData item){
  for (var item2 in currentOrder.history){
    if (item2.statusId == item.id)
      return true;
  }
  return false;
}

StatusHistory? cancelItem(StatusData item){
  for (var item2 in currentOrder.history){
    if (item2.statusId == item.id)
      return item2;
  }
  return null;
}

//
//
Future<String?> loadBookingCache(String listen, String providerId) async {
  try{
    User? user = FirebaseAuth.instance.currentUser;

    work(querySnapshot){
      // dprint("loadBookingCache");
      ordersDataCache = [];
      if (querySnapshot.exists){
        if (querySnapshot.data() != null) {
          var _meData = querySnapshot.data()!;
          for (var item in _meData.entries){
            var t = OrderDataCache.fromJson(item.key, item.value);
            if (!t.delete && t.status != "temp") {
              if (listen.isEmpty) { // admin
                ordersDataCache.add(t);
              } else {
                if (user != null) { // customer app and provider app
                  if (listen == "customerId" && t.customerId == user.uid)
                    ordersDataCache.add(t);
                  if (listen == "providerId" && t.providerId == providerId)
                    ordersDataCache.add(t);
                }
              }
            }
          }
        }
        ordersDataCache.sort((a, b) => b.time.compareTo(a.time));
      }
    }

    var querySnapshot = await FirebaseFirestore.instance.collection("cache").doc("orders").get();
    work(querySnapshot);

    FirebaseFirestore.instance.collection("cache")
        .doc("orders").snapshots().listen((querySnapshot) {
      work(querySnapshot);
      redrawMainWindow();
    });
  }catch(ex){
    return "loadBookingCache " + ex.toString();
  }

  return null;
}

Future<String?> bookingGetItem(OrderDataCache item) async {
  try{
    currentOrder = OrderData.createEmpty();
    var querySnapshot = await FirebaseFirestore.instance.collection("booking").doc(item.id).get();
    if (querySnapshot.exists){
      if (querySnapshot.data() != null) {
        var _meData = querySnapshot.data()!;
        currentOrder = OrderData.fromJson(querySnapshot.id, _meData);
      }else
        return "bookingGetItem querySnapshot.data() = null";
    }else
      return "bookingGetItem ${item.id} not exists";
  }catch(ex){
    return "bookingGetItem " + ex.toString();
  }
  return null;
}

Future<String?> bookingDeleteV2(OrderDataCache item) async {
  if (currentOrder.id == item.id)
    currentOrder = OrderData.createEmpty();
  var t = currentOrder;
  var ret = await bookingGetItem(item);
  var _loadedOrder = currentOrder;
  currentOrder = t;
  if (ret != null)
    return ret;
  try{
    await FirebaseFirestore.instance.collection("booking").doc(_loadedOrder.id).set({
      "delete": true,
      "timeModify": DateTime.now().toUtc(),
    });
    await FirebaseFirestore.instance.collection("settings").doc("main")
        .set({"booking_count": FieldValue.increment(-1)}, SetOptions(merge:true));
    _loadedOrder.delete = true;
    await bookingSaveInCache(_loadedOrder);
  }catch(ex){
    return "bookingDelete " + ex.toString();
  }
  return null;
}

Future<String?> saveBookingV2(OrderData current) async {
  try{
    var _data = current.toJson();
    await FirebaseFirestore.instance.collection("booking").doc(current.id).set(_data, SetOptions(merge:true));
    await bookingSaveInCache(current);
  }catch(ex){
    return "saveBookingV2 " + ex.toString();
  }
  return null;
}

Future<String?> bookingSaveInCacheList(List<OrderData> list, {bool migrate = true}) async {
  try{
    Map<String, dynamic> _toWrite = {};
    for (var item in list){
      var _cache = _bookingSaveInCache(item, migrate: migrate);
      _toWrite.addAll({
        _cache.id: _cache.toJson(migrate: true),
      });
    }
    // dprint("bookingSaveInCacheList");
    await FirebaseFirestore.instance.collection("cache").doc("orders")
        .set(_toWrite, SetOptions(merge:true));
  }catch(ex){
    return "bookingSaveInCacheList " + ex.toString();
  }
  return null;
}

Future<String?> bookingSaveInCache(OrderData _data, {bool migrate = false}) async {
  var _cache = _bookingSaveInCache(_data, migrate: migrate);
  await FirebaseFirestore.instance.collection("cache").doc("orders")
      .set({
    _cache.id: _cache.toJson(migrate: migrate),
  }, SetOptions(merge:true));
}

OrderDataCache _bookingSaveInCache(OrderData _data, {bool migrate = false}) {
  setDataToCalculate(_data, null);
  OrderDataCache _cache;
  if (_data.ver4){
    cartCurrentProvider = ProviderData.createEmpty()..id = _data.providerId;
    PriceTotalForCardData _prices = cartGetTotalForAllServices2(_data.products);
    int _count = 0;
    String _name = "";
    for (var item in _data.products) {
      _count += (item.countProduct);
      if (_name.isEmpty)
        _name = getTextByLocale(item.name, locale);
    }
    _name += " + $_count";
    _cache = OrderDataCache(
      id: _data.id,
      time: _data.time,
      timeModify: _data.timeModify,
      status: _data.status,
      delete: _data.delete,
      customerId: _data.customerId,
      customerName: _data.customer,
      providerId: _data.providerId,
      providerName: _data.provider,
      countProducts: _count,
      subtotal: _prices.subtotal,
      toAdmin: _prices.toAdmin,
      toDriver: 0,
      discount: _prices.discount,
      tax: _prices.tax,
      total: _prices.total,
      couponId: _data.couponId,
      paymentMethod: _data.paymentMethod,
      finished: _data.finished,
      viewByAdmin: _data.viewByAdmin,
      viewByProvider: _data.viewByProvider,
      providerImage: _data.providerAvatar,
      customerImage: _data.customerAvatar,
      name: _name,
    );
  }else
    _cache = OrderDataCache(
      id: _data.id,
      time: _data.time,
      timeModify: _data.timeModify,
      status: _data.status,
      delete: _data.delete,
      customerId: _data.customerId,
      customerName: _data.customer,
      providerId: _data.providerId,
      providerName: _data.provider,
      countProducts: 1,
      subtotal: getTotal(),
      toAdmin: getTotal()*_data.taxAdmin/100,
      toDriver: 0,
      discount: getCoupon(),
      tax: getTax(),
      total: getTotal(),
      couponId: _data.couponId,
      paymentMethod: _data.paymentMethod,
      finished: _data.finished,
      viewByAdmin: _data.viewByAdmin,
      viewByProvider: _data.viewByProvider,
      providerImage: _data.providerAvatar,
      customerImage: _data.customerAvatar,
      name: getTextByLocale(_data.service, locale),
    );
  return _cache;
}

Future<void> saveInCacheStatus(String id, String status) async {
  // do {
  //   await Future.delayed(Duration(seconds: 2));
  // }while (ordersDataCache.isEmpty);
  // for (var item in ordersDataCache)
  //   if (item.id == id){
  //     item.status = status;
  //     FirebaseFirestore.instance.collection("cache").doc("orders")
  //         .set({
  //       item.id: item.toJson(),
  //     }, SetOptions(merge: true));
  //     break;
  //   }

  var t = await bookingGetItem(OrderDataCache.createEmpty(id));
    if (t == null){
      if (currentOrder.id.isNotEmpty){
        OrderDataCache _cache = _bookingSaveInCache(currentOrder);
        _cache.status = status;
        FirebaseFirestore.instance.collection("cache").doc("orders")
            .set({
          _cache.id: _cache.toJson(),
        }, SetOptions(merge: true));
      }
    }

}

Future<String?> bookingToCashMigrate(Function(String) callback) async {
  try{
    // double percentage = 0;
    var querySnapshot = await FirebaseFirestore.instance.collection("booking").get();
    // var oneStep = 100/querySnapshot.docs.length;

    Map<String, dynamic> _toWrite = {};

    for (var item in querySnapshot.docs) {
      if (!item.exists)
        continue;
      var _data = OrderData.fromJson(item.id, item.data());

      if (_data.status == "temp" || _data.delete)
        continue;

      setDataToCalculate(_data, null);
      OrderDataCache order;
      if (_data.ver4){
        cartCurrentProvider = ProviderData.createEmpty()..id = _data.providerId;
        PriceTotalForCardData _prices = cartGetTotalForAllServices2(_data.products);
        int _count = 0;
        String _name = "";
        for (var item in _data.products) {
          _count += (item.countProduct);
          if (_name.isEmpty)
            _name = getTextByLocale(item.name, locale);
        }
        _name += " + $_count";
        order = OrderDataCache(
          id: _data.id,
          time: _data.time,
          timeModify: _data.timeModify,
          status: _data.status,
          delete: _data.delete,
          customerId: _data.customerId,
          customerName: _data.customer,
          providerId: _data.providerId,
          providerName: _data.provider,
          countProducts: _count,
          subtotal: _prices.subtotal,
          toAdmin: _prices.toAdmin,
          toDriver: 0,
          discount: _prices.discount,
          tax: _prices.tax,
          total: _prices.total,
          couponId: _data.couponId,
          paymentMethod: _data.paymentMethod,
          finished: _data.finished,
          viewByAdmin: _data.viewByAdmin,
          viewByProvider: _data.viewByProvider,
          providerImage: _data.providerAvatar,
          customerImage: _data.customerAvatar,
          name: _name,
        );
      }else{
        order = OrderDataCache(
          id: item.id,
          time: _data.time,
          timeModify: _data.timeModify,
          status: _data.status,
          delete: _data.delete,
          customerId: _data.customerId,
          customerName: _data.customer,
          providerId: _data.providerId,
          providerName: _data.provider,
          countProducts: _data.count,
          subtotal: getSubTotalWithCoupon(), // getTotal(),
          toAdmin: getSubTotalWithCoupon()*_data.taxAdmin/100, // getTotal
          toDriver: 0,
          discount: getCoupon(),
          tax: getTax(),
          total: getTotal(),
          couponId: _data.couponId,
          paymentMethod: _data.paymentMethod,
          finished: _data.finished,
          viewByAdmin: true,
          viewByProvider: _data.viewByProvider,
          providerImage: _data.providerAvatar,
          customerImage: _data.customerAvatar,
          name: getTextByLocale(_data.service, locale),
        );
      }
      _toWrite.addAll({
        order.id: order.toJson(migrate: true),
      });
      // percentage += oneStep;

    }
    FirebaseFirestore.instance.collection("cache").doc("orders").set(_toWrite, SetOptions(merge:true)).then((value) async {
      await FirebaseFirestore.instance.collection("settings").doc("main").set({
        "bookingToCashMigrate": true
      }, SetOptions(merge:true));
      callback("");
    }).onError((error, stackTrace) {
      callback(error.toString());
    });
  }catch(ex){
    return "bookingToCashMigrate " + ex.toString();
  }
  return null;
}

class OrderDataCache {
  String id;
  DateTime timeModify; // время воследней модификации (для listener)
  DateTime time;
  String status;
  bool delete;
  String customerId;
  String customerName; // name
  String providerId;
  List<StringData> providerName;
  //
  int countProducts;
  double subtotal;
  double discount;
  double toAdmin;
  double toDriver;
  double tax;
  double total;
  String couponId;
  //
  String paymentMethod;
  bool finished;
  bool viewByAdmin;
  bool viewByProvider;
  //
  String providerImage;
  String customerImage;
  String name;

  factory OrderDataCache.createEmpty(String id){
    return OrderDataCache(id : id,
      time : DateTime.now(),
      timeModify : DateTime.now(),
      status : "",
      delete : false,
      customerId : "",
      customerName : "",
      providerId : "",
      providerName : [],
      countProducts : 0,
      subtotal : 0,
      discount : 0,
      toAdmin : 0,
      toDriver : 0,
      tax : 0,
      total : 0,
      couponId : "",
      paymentMethod : "",
      finished : false,
      viewByAdmin : false,
      viewByProvider : false,
      providerImage : "",
      customerImage : "",
      name: "",
    );
  }

  OrderDataCache({
    required this.id,
    required this.time,
    required this.timeModify,
    required this.status,
    required this.delete,
    required this.customerId,
    required this.customerName,
    required this.providerId,
    required this.providerName,
    required this.countProducts,
    required this.subtotal,
    required this.discount,
    required this.toAdmin,
    required this.toDriver,
    required this.tax,
    required this.total,
    required this.couponId,
    required this.paymentMethod,
    required this.finished,
    required this.viewByAdmin,
    required this.viewByProvider,
    required this.providerImage,
    required this.customerImage,
    required this.name,
  });

  Map<String, dynamic> toJson({bool local = false, bool migrate = false}) {
    var _t = local ? time.toIso8601String() : time; // DateTime.now().toUtc();
    // if (migrate)
    //   _t = time;
    var _q = local ? timeModify.toIso8601String() : DateTime.now().toUtc();
    if (migrate)
      _q = timeModify;
    // if (id == "bI9BRZ3ao6CUtPIkjwBN")
    //   dprint("to json id $id $_t}");
    return {
      't': _t,
      'q': _q,
      's': status,
      'd': delete,
      'c': customerId,
      'b': customerName,
      'p': providerName.map((i) => i.toJson()).toList(),
      'r': providerId,
      'a': countProducts,
      'w': subtotal,
      'e': discount,
      'm': toAdmin,
      'z': toDriver,
      'y': tax,
      'f': total,
      'g': couponId,
      'h': paymentMethod,
      'k': finished,
      'o': viewByAdmin,
      'i': viewByProvider,
      'x': providerImage,
      'l': customerImage,
      'v': name,
    };
  }

  factory OrderDataCache.fromJson(String id, Map<String, dynamic> data, {bool local = false}){
    List<StringData> _providerName = [];
    if (data['p'] != null)
      for (var element in List.from(data['p'])) {
        _providerName.add(StringData.fromJson(element));
      }
    // if (id == "bI9BRZ3ao6CUtPIkjwBN") {
    //   dprint("id $id local=$local data[t]=${data["t"]} ${!local ? (data["t"] !=
    //       null) ? data["t"].toDate() : DateTime.now()
    //       : DateTime.parse(data["t"])}");
    // }
    return OrderDataCache(
      id: id,
      time: !local ? (data["t"] != null) ? data["t"].toDate() : DateTime.now()
          : DateTime.parse(data["t"]),
      timeModify: !local ? (data["q"] != null) ? data["q"].toDate() : DateTime.now()
          : DateTime.parse(data["q"]),
      providerName: _providerName,
      status: (data["s"] != null) ? data["s"] : "",
      delete: (data["d"] != null) ? data["d"] : false,
      customerId: (data["c"] != null) ? data["c"] : "",
      customerName: (data["b"] != null) ? data["b"] : "",
      providerId: (data["r"] != null) ? data["r"] : "",
      countProducts: (data["a"] != null) ? toInt(data["a"].toString()) : 0,
      subtotal: (data["w"] != null) ? toDouble(data["w"].toString()) : 0,
      discount: (data["e"] != null) ? toDouble(data["e"].toString()) : 0,
      toAdmin: (data["m"] != null) ? toDouble(data["m"].toString()) : 0,
      toDriver: (data["z"] != null) ? toDouble(data["z"].toString()) : 0,
      tax: (data["y"] != null) ? toDouble(data["y"].toString()) : 0,
      total: (data["f"] != null) ? toDouble(data["f"].toString()) : 0,
      couponId: (data["g"] != null) ? data["g"] : "",
      paymentMethod: (data["h"] != null) ? data["h"] : "",
      finished: (data["k"] != null) ? data["k"] : false,
      viewByAdmin: (data["o"] != null) ? data["o"] : false,
      viewByProvider: (data["i"] != null) ? data["i"] : false,
      providerImage: (data["x"] != null) ? data["x"] : "",
      customerImage: (data["l"] != null) ? data["l"] : "",
      name: (data["v"] != null) ? data["v"] : "",
    );
  }
}


bookingCopy(){
  var text = "";
  for (var item in ordersDataCache){
    var statusName = "";
    for (var status in appSettings.statuses)
      if (item.status == status.id)
        statusName = getTextByLocale(status.name, locale);
    text = "$text${item.id}\t${item.customerName}\t$statusName\t${getTextByLocale(item.providerName, locale)}"
        "\t${item.countProducts}\t${getPriceString(item.total)}\t${appSettings.getDateTimeString(item.time)}\n";
  }
  Clipboard.setData(ClipboardData(text: text));
}

String bookingCsv(List<String> title){
  List<List> t2 = [];
  t2.add(title);
  for (var item in ordersDataCache){
    var statusName = "";
    for (var status in appSettings.statuses)
      if (item.status == status.id)
        statusName = getTextByLocale(status.name, locale);
    t2.add([item.id, item.customerName, statusName, getTextByLocale(item.providerName, locale),
      item.countProducts.toString(), appSettings.getDateTimeString(item.time)
    ]);
  }
  return ListToCsvConverter().convert(t2);
}

Future<String?> setNextStep(StatusData status,
    bool byCustomer, bool byProvider, bool byAdmin,
    String stringNowStatus, /// strings.get(186) /// "Now status:",
    String stringBookingStatus, /// strings.get(187) /// "Booking status was changed",
    ) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "nextStep user == null";
  StatusData _status = StatusData.clone(status);

  try{
    StatusData _last = StatusData.createEmpty();
    for (var item in appSettings.statuses) {
      if (!item.cancel)
        _last = item;
    }
    currentOrder.history.add(StatusHistory(
        statusId: _status.id,
        time: DateTime.now().toUtc(),
        byCustomer: byCustomer,
        byProvider: byProvider,
        byAdmin: byAdmin,
        activateUserId : user.uid
    ));
    var _finished = currentOrder.finished;
    if (!_status.cancel)
      if (_status.id == _last.id)
        _finished = true;
    currentOrder.status = _status.id;
    currentOrder.finished = _finished;
    await bookingSaveInCache(currentOrder);
    await FirebaseFirestore.instance.collection("booking").doc(currentOrder.id).set({
      "status": currentOrder.status,
      "history": currentOrder.history.map((i) => i.toJson()).toList(),
      "finished" : currentOrder.finished,
      "timeModify": FieldValue.serverTimestamp(),
    }, SetOptions(merge:true));

    // notify
    if (byCustomer){  // customer app
      var _provider = getProviderById(currentOrder.providerId);
      if (_provider != null){
        UserData? _user = await getProviderUserByEmail(_provider.login);
        if (_user != null){
          sendMessage("$stringNowStatus ${getTextByLocale(status.name, locale)}",  /// "Now status:",
              stringBookingStatus,  /// "Booking status was changed",
              _user.id, true, appSettings.cloudKey);
        }
      }
    }
    if (byProvider){
      sendMessage("$stringNowStatus ${getTextByLocale(status.name, locale)}",  /// "Now status:",
          stringBookingStatus,  /// "Booking status was changed",
          currentOrder.customerId, true, appSettings.cloudKey);
    }

  }catch(ex){
    return "setNextStep " + ex.toString();
  }
  return null;
}