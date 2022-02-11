import '../../abg_utils.dart';

class OrderData {
  String id;
  String status;    // status id
  bool delete;
  List<StatusHistory> history;
  //
  String customerId;
  String customer; // name
  String customerAvatar;
  String providerId;
  String providerPhone;
  List<StringData> provider;
  String providerAvatar;
  String serviceId;
  String serviceImage;
  List<StringData> service;
  //
  List<StringData> priceName;
  double price;
  double discPrice;
  String priceUnit; // "hourly" or "fixed"
  int count;
  String couponId;
  String couponName;
  double discount;
  String discountType; // "percent" or "fixed"
  double tax;
  double taxAdmin;
  double total;
  //
  String paymentMethod;
  String comment;
  String address;
  bool anyTime;
  DateTime selectTime;
  DateTime time;   // timestamp
  DateTime timeUtc = DateTime.now();
  DateTime timeModify; // время воследней модификации (для listener)  --- "timeModify": FieldValue.serverTimestamp(),
  bool viewByAdmin;
  bool viewByProvider;
  bool rated;
  bool finished;
  List<AddonData> addon;
  bool ver2; // version history changed
  bool ver3;
  bool ver4; // добавлены товары (articles)
  bool paymentMethodCache; // v3
  List<ProductData> products; // v4
  String customerEmail;
  String customerPhone;

  double getPrice(){
    return discPrice != 0 ? discPrice : price;
  }

  double _getTotal(){
    var _price = count*getPrice();
    var _coupon = getCoupon();
    var _addon = getAddonsTotal();
    return _price-_coupon+_addon;
  }

  double getTaxFromPrice(){
    return _getTotal()*tax/100;
  }

  double getAddonsTotal(){
    double total = 0;
    for (var item in addon)
      if (item.selected)
        total += (item.needCount*item.price);
    return total;
  }

  double getTotal(){
    return _getTotal() + getTaxFromPrice();
  }

  double getCoupon(){
    if (couponName.isEmpty)
      return 0;
    double total = getPrice()*count;
    if (discountType == "percentage")
      return total*discount/100;
    return discount;
  }

  OrderData({this.id = "", this.status = "", this.delete = false,
    this.customerId = "", this.customer = "", this.customerAvatar = "",
    this.providerId = "", required this.provider, this.serviceId = "", required this.service,
    this.price = 0, this.discPrice = 0, this.priceUnit = "fixed", this.count = 1, this.couponId = "",
    this.couponName = "", this.discount = 0, this.discountType = "fixed",
    this.tax = 0, this.total = 0,
    this.paymentMethod = "", this.comment = "", this.address = "", required this.time, required this.timeModify,
    this.anyTime = true, required this.selectTime, this.providerAvatar = "",
    this.providerPhone = "", required this.history, required this.priceName,
    this.viewByAdmin = false, this.viewByProvider = false,
    this.taxAdmin = 0, this.finished = false, required this.addon,
    this.rated = false, this.serviceImage = "",
    this.ver2 = true,
    this.ver3 = true,
    this.ver4 = false, required this.products,
    this.paymentMethodCache = true,
    required this.customerEmail,
    required this.customerPhone,
  }){
    timeUtc = time;
    time = time.toLocal();
  }

  factory OrderData.createEmpty(){
    return OrderData(service: [], provider: [], time: DateTime.now(), timeModify: DateTime.now(),
        selectTime: DateTime.now(), history: [], priceName: [], addon: [], products: [],
        customerPhone: '', customerEmail: '');
  }

  Map<String, dynamic> toJson({bool local = false}) => {
    'id': id,
    'status': status,
    'delete': delete,
    'customerId': customerId,
    'customer' :  customer,
    'customerAvatar' :  customerAvatar,
    'providerId' : providerId,
    'provider' : provider.map((i) => i.toJson()).toList(),
    'providerAvatar' : providerAvatar,
    'serviceId': serviceId,
    'service': service.map((i) => i.toJson()).toList(),
    'price' : price,
    'discPrice': discPrice,
    'priceName': priceName.map((i) => i.toJson()).toList(),
    'priceUnit': priceUnit,
    'count': count,
    'couponId': couponId,
    'couponName': couponName,
    'discount': discount,
    'discountType': discountType,
    'tax' : tax,
    'taxAdmin': taxAdmin,
    'total': total,
    'paymentMethod': paymentMethod,
    'comment': comment,
    'address' : address,
    'anyTime': anyTime,
    'selectTime': selectTime.millisecondsSinceEpoch,
    'time': local ? time.toIso8601String() : DateTime.now().toUtc(),
    'timeModify': local ? timeModify.toIso8601String() : DateTime.now().toUtc(),
    'providerPhone': providerPhone,
    'history': history.map((i) => i.toJson(local: local)).toList(),
    'viewByAdmin' : viewByAdmin,
    'viewByProvider' : viewByProvider,
    'rated' : rated,
    'finished': finished,
    'addon': addon.map((i) => i.toJson()).toList(),
    'serviceImage' : serviceImage,
    'ver2' : ver2,
    'ver3' : ver3,
    'ver4' : ver4,
    'paymentMethodCache': paymentMethodCache,
    'products': products.map((i) => i.toJson(local: local)).toList(),
    'customerEmail': customerEmail,
    'customerPhone': customerPhone,
  };

  factory OrderData.fromJson(String id, Map<String, dynamic> data, {bool local = false}){
    List<StringData> _provider = [];
    if (data['provider'] != null)
      for (var element in List.from(data['provider'])) {
        _provider.add(StringData.fromJson(element));
      }
    List<StringData> _service = [];
    if (data['service'] != null)
      for (var element in List.from(data['service'])) {
        _service.add(StringData.fromJson(element));
      }
    List<StatusHistory> _history = [];
    if (data['history'] != null)
      for (var element in List.from(data['history'])) {
        _history.add(StatusHistory.fromJson(element, local: local));
      }
    List<StringData> _priceName = [];
    if (data['priceName'] != null)
      for (var element in List.from(data['priceName'])) {
        _priceName.add(StringData.fromJson(element));
      }
    List<AddonData> _addon = [];
    if (data['addon'] != null)
      for (var element in List.from(data['addon'])) {
        _addon.add(AddonData.fromJson(element));
      }

    var _time = !local ? (data["time"] != null) ? data["time"].toDate() : DateTime.now() : DateTime.parse(data["time"]);

    List<ProductData> _products = [];
    if (data['products'] != null)
      for (var element in List.from(data['products'])) {
        _products.add(ProductData.fromJson(element["id"], element, local: local));
      }
    //if (id == "bI9BRZ3ao6CUtPIkjwBN")
     // dprint("order data id $id $_time");
    return OrderData(
      id: id,
      status: (data["status"] != null) ? data["status"] : "",
      delete: (data["delete"] != null) ? data["delete"] : false,
      customerId: (data["customerId"] != null) ? data["customerId"] : "",
      customer: (data["customer"] != null) ? data["customer"] : "",
      customerAvatar: (data["customerAvatar"] != null) ? data["customerAvatar"] : "",
      providerId: (data["providerId"] != null) ? data["providerId"] : "",
      providerPhone: (data["providerPhone"] != null) ? data["providerPhone"] : "",
      provider: _provider,
      providerAvatar: (data["providerAvatar"] != null) ? data["providerAvatar"] : "",
      serviceId: (data["serviceId"] != null) ? data["serviceId"] : "",
      service: _service,
      price: (data["price"] != null) ? toDouble(data["price"].toString()) : 0.0,
      discPrice: (data["discPrice"] != null) ? toDouble(data["discPrice"].toString()) : 0.0,
      priceUnit: (data["priceUnit"] != null) ? data["priceUnit"] : "",
      priceName: _priceName,
      count: (data["count"] != null) ? data["count"] : 1,
      couponId: (data["couponId"] != null) ? data["couponId"] : "",
      couponName: (data["couponName"] != null) ? data["couponName"] : "",
      discount: (data["discount"] != null) ? toDouble(data["discount"].toString()) : 0.0,
      discountType: (data["discountType"] != null) ? data["discountType"] : "",
      tax: (data["tax"] != null) ? toDouble(data["tax"].toString()) : 0.0,
      total: (data["total"] != null) ? toDouble(data["total"].toString()) : 0.0,
      paymentMethod: (data["paymentMethod"] != null) ? data["paymentMethod"] : "",
      comment: (data["comment"] != null) ? data["comment"] : "",
      address: (data["address"] != null) ? data["address"] : "",
      anyTime: (data["anyTime"] != null) ? data["anyTime"] : true,
      selectTime: (data["selectTime"] != null) ? DateTime.fromMillisecondsSinceEpoch(data["selectTime"]) : DateTime.now(),
      //
      time: _time,
      timeModify: !local ? (data["timeModify"] != null) ? data["timeModify"].toDate() : _time : DateTime.parse(data["time"]),
      //
      history: _history,
      viewByAdmin: (data["viewByAdmin"] != null) ? data["viewByAdmin"] : false,
      viewByProvider: (data["viewByProvider"] != null) ? data["viewByProvider"] : false,
      taxAdmin: (data["taxAdmin"] != null) ? toDouble(data["taxAdmin"].toString()) : 0.0,
      finished: (data["finished"] != null) ? data["finished"] : false,
      rated: (data["rated"] != null) ? data["rated"] : false,
      addon: _addon,
      serviceImage: (data["serviceImage"] != null) ? data["serviceImage"] : "",
      paymentMethodCache: (data["paymentMethodCache"] != null) ? data["paymentMethodCache"] : false,
      ver2: (data["ver2"] != null) ? data["ver2"] : true,
      ver3 : (data["ver3"] != null) ? data["ver3"] : true, // on demand v2
      ver4: (data["ver4"] != null) ? data["ver4"] : false,
      products: _products,
      customerEmail: (data["customerEmail"] != null) ? data["customerEmail"] : "",
      customerPhone: (data["customerPhone"] != null) ? data["customerPhone"] : "",
    );
  }

  StatusHistory getHistoryDate(String id){
    for (var item in history)
      if (item.statusId == id)
        return item;
    return StatusHistory.createEmpty();
  }

}
class StatusHistory{
  String statusId = "";
  DateTime time;
  bool byCustomer;
  bool byProvider;
  bool byAdmin;
  String activateUserId;

  StatusHistory({this.statusId = "", required this.time, this.byCustomer = false,
    this.byProvider = false, this.byAdmin = false, this.activateUserId = ""
  });

  Map<String, dynamic> toJson({bool local = false}) => {
    'statusId': statusId,
    'time': local ? time.toIso8601String() : time,
    'byCustomer' : byCustomer,
    'byProvider' : byProvider,
    'byAdmin' : byAdmin,
    'activateUserId' : activateUserId,
  };

  factory StatusHistory.fromJson(Map<String, dynamic> data, {bool local = false}){
    // if (local) {
    //   dprint("StatusHistory " + data["time"].toString());
    //   var t = DateTime.parse(data["time"].toString());
    //   dprint(t.toString());
    //   dprint(t.toUtc().toString());
    // }

    // DateTime _time;
    // if (local){
    //   _time = data["time"] != null ? (data["time"]).toDate().toLocal() : DateTime.now();
    // }else{
    //   _time = data["time"] != null ? (data["time"]).toDate().toLocal() : DateTime.now();
    // }

    return StatusHistory(
      statusId: (data["statusId"] != null) ? data["statusId"] : "",
      time: !local ? (data["time"] != null) ? data["time"].toDate() : DateTime.now() : DateTime.parse(data["time"]),
      // !local
          // ? (data["time"] != null) ? (data["time"]).toDate().toLocal() : DateTime.now()
          // : DateTime.parse(data["time"]),
      byCustomer: (data["byCustomer"] != null) ? data["byCustomer"] : false,
      byProvider: (data["byProvider"] != null) ? data["byProvider"] : false,
      byAdmin: (data["byAdmin"] != null) ? data["byAdmin"] : false,
      activateUserId: (data["activateUserId"] != null) ? data["activateUserId"] : "",
    );
  }

  factory StatusHistory.createEmpty(){
    return StatusHistory(time: DateTime.now());
  }
}

