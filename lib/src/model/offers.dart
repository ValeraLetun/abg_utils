import '../../abg_utils.dart';

List<OfferData> offers = [];
OfferData currentOffer = OfferData.createEmpty();

Future<String?> loadOffers() async{
  try{
    offers = await dbGetAllDocumentInTable("offer");
    if (offers.length != appSettings.customersCount)
      dbSetDocumentInTable("settings", "main", {"customersCount": listUsers.length});
  }catch(ex){
    return "loadOffers " + ex.toString();
  }
  return null;
}

getDiscountText(OfferData item){
  if (item.discountType == "percentage")
    return "${item.discount}%";
  return "\$${item.discount}";
}

getCurrentDiscountText(){
  if (currentOffer.discountType == "percentage")
    return "${currentOffer.discount}%";
  return "\$${currentOffer.discount}";
}

String couponInfo(
    List<String> serviceProviders,  // parent.currentService.providers
    List<String> serviceCategory, // parent.currentService.category
    String serviceId, // parent.currentService.id
    String stringCouponNotFound, /// strings.get(162); /// "Coupon not found",
    String stringCouponHasExpired, /// strings.get(169); /// "Coupon has expired",
    String stringCouponNotSupportedProvider, /// strings.get(164); /// "Coupon not supported by this provider",
    String stringCouponNotSupportCategory, /// strings.get(165); /// "Coupon not support this category",
    String stringCouponNotSupportService, /// strings.get(166); /// "Coupon not support this service",
    String stringCouponActivated, /// strings.get(163); /// "Coupon activated",
    ){
  OfferData? _item;
  dprint("<-------------couponInfo------------>");

  for (var item in offers) {
    dprint("offers = ${item.code} - need localSettings.couponCode=$couponCode");
    if (item.code == couponCode) {
      _item = item;
      break;
    }
  }

  if (_item == null){
    dprint("coupon not found");
    couponId = "";
    return stringCouponNotFound; /// "Coupon not found",
  }
  //
  // Time
  //
  var _now = DateTime.now();
  dprint("time coupon ${_item.expired}");
  dprint("time    now $_now");
  dprint("is   before ${_item.expired.isBefore(_now)}");
  if (_item.expired.isBefore(_now)){
    dprint("Coupon has expired");
    couponId = "";
    return stringCouponHasExpired; /// "Coupon has expired",
  }

  //
  // Provider
  //
  // Нам нужно проверить есть ли serviceProviders[0] в списке разрешенных провайдеров
  if (_item.providers.isNotEmpty){
    dprint("providers not empty"); // надо проверять
    if (serviceProviders.isNotEmpty)
      if (!_item.providers.contains(serviceProviders[0])) { // не найден
        couponId = "";
        dprint("Coupon not supported by this provider");
        return stringCouponNotSupportedProvider; /// "Coupon not supported by this provider",
      }
    // var _provider = ProviderData.createEmpty();
    // if (providers.isNotEmpty)
      // serviceProviders - провайдеры этого сервиса. Нам нужен только [0]
      // for (var item in providers)
      //   if (item.id == providers)
      //     _provider = item;
    // if (_provider.id.isEmpty) {
    //   couponId = "";
    //   dprint("Provider not found. _provider.id.isEmpty!!!!");
    //   return "Provider not found. _provider.id.isEmpty";
    // }

    // var _found = false;
    // for (var item in _item.providers){
    //   dprint("current provider id: ${_provider.id} - in list $item");
    //   if (item == _provider.id) {
    //     _found = true;
    //     break;
    //   }
    // }
    // if (!_found){
    //   dprint("Coupon not supported by this provider");
    //   couponId = "";
    //   return stringCouponNotSupportedProvider; /// "Coupon not supported by this provider",
    // }
  }else
    dprint("providers empty");

  //
  // Category
  //
  if (_item.category.isNotEmpty){
    dprint("category not empty");
    var _found = false;
    dprint("current category id: ${serviceCategory.join(" ")} - list offer categories ${_item.category.join(" ")}");
    for (var item in _item.category){
      if (serviceCategory.contains(item)){
        _found = true;
        break;
      }
    }
    if (!_found){
      dprint("Coupon not support this category",);
      couponId = "";
      return stringCouponNotSupportCategory; /// strings.get(165); /// "Coupon not support this category",
    }
  }else
    dprint("category empty");

  //
  // Service
  //
  if (_item.services.isNotEmpty){
    dprint("current service id: $serviceId - coupon service list ${_item.services.join(" ")}");
    if (!_item.services.contains(serviceId)){
      dprint("Coupon not support this service");
      couponId = "";
      return stringCouponNotSupportService; /// strings.get(166); /// "Coupon not support this service",
    }
  }else
    dprint("service empty");

  dprint("Coupon activated");
  dprint("<-------------couponInfo------------>");
  // localSettings.coupon = _item;
  couponId = _item.id;     // 2746fde7643fgd
  couponCode = _item.code;   // CODE25
  discountType = _item.discountType; // "percent" or "fixed"
  discount = _item.discount;      // 12
  return stringCouponActivated; /// "Coupon activated",
}

Future<String?> offerSave() async {
  try{
    var _data = currentOffer.toJson();
    if (currentOffer.id.isEmpty) {
      currentOffer.id = await dbAddDocumentInTable("offer", _data);
      await dbIncrementCounter("settings", "main", "offer_count", 1);
    }else
      await dbSetDocumentInTable("offer", currentOffer.id, _data);
  }catch(ex){
    return "offerSave " + ex.toString();
  }
  return null;
}


Future<String?> offerDelete(OfferData item) async {
  try{
    await dbDeleteDocumentInTable("offer", item.id);
    await dbIncrementCounter("settings", "main", "offer_count", -1);
    if (item.id == currentOffer.id)
      currentOffer = OfferData.createEmpty();
    offers.remove(item);
  }catch(ex){
    return "offerDelete " + ex.toString();
  }
  return null;
}

class OfferData {
  String id;
  String code;
  List<StringData> desc;
  double discount;
  String discountType; // "percent" or "fixed"
  bool visible;
  List<String> services; // Id
  List<String> providers; // Id
  List<String> category; // Id
  List<String> article; // Id
  DateTime expired;

  OfferData(this.id, this.code, {this.visible = true, required this.desc, this.discountType = "fixed",
    required this.services, required this.providers, required this.category, this.discount = 0, required this.expired,
    required this.article});

  factory OfferData.createEmpty(){
    return OfferData("", "", services: [], providers: [], category: [], expired: DateTime.now(), desc: [], article: []);
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'desc': desc.map((i) => i.toJson()).toList(),
    'discount': discount,
    'discountType': discountType,
    'visible': visible,
    'services': services,
    'providers': providers,
    'category': category,
    'expired': expired.millisecondsSinceEpoch,
    'article': article,
  };

  factory OfferData.fromJson(String id, Map<String, dynamic> data){
    List<StringData> _desc = [];
    if (data['desc'] != null)
      for (var element in List.from(data['desc'])) {
        _desc.add(StringData.fromJson(element));
      }
    List<String> _services = [];
    if (data['services'] != null)
      for (var element in List.from(data['services'])) {
        _services.add(element);
      }
    List<String> _providers = [];
    if (data['providers'] != null)
      for (var element in List.from(data['providers'])) {
        _providers.add(element);
      }
    List<String> _category = [];
    if (data['category'] != null)
      for (var element in List.from(data['category'])) {
        _category.add(element);
      }
    List<String> _article = [];
    if (data['article'] != null)
      for (var element in List.from(data['article'])) {
        _article.add(element);
      }
    return OfferData(
      id,
      (data["code"] != null) ? data["code"] : "",
      desc: _desc,
      discount: (data["discount"] != null) ? toDouble(data["discount"].toString()) : 0,
      discountType: (data["discountType"] != null) ? data["discountType"] : "",
      visible: (data["visible"] != null) ? data["visible"] : true,
      services: _services,
      providers: _providers,
      category: _category,
      article: _article,
      expired: (data["expired"] != null) ? DateTime.fromMillisecondsSinceEpoch(data["expired"]) : DateTime.now(),
    );
  }

  setDesc(String val, String locale){
    for (var item in desc)
      if (item.code == locale) {
        item.text = val;
        return;
      }
    desc.add(StringData(code: locale, text: val));
  }
}