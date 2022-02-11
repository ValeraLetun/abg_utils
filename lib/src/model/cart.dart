
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../abg_utils.dart';

List<ProductData> cart = [];
ProviderData? cartCurrentProvider;
bool cartAnyTime = true;
var cartSelectTime = DateTime.now();
String cartHint = "";
String cartCouponCode = "";
/*
вся информация в price.dart:
String couponId = "";     // 2746fde7643fgd
String couponCode = "";   // CODE25
String discountType = ""; // "percent" or "fixed"
double discount = 0;      // 12
 */

clearCart(){
  cartCouponCode = "";
  cartHint = "";
  cartAnyTime = true;
  cartSelectTime = DateTime.now();
  couponId = "";     // 2746fde7643fgd
  couponCode = "";   // CODE25
  discountType = ""; // "percent" or "fixed"
  discount = 0;      // 12
}

// List<String> checkout = []; // provider id

String? addToCart(ProductData service,
    String stringAlreadyInCart  /// strings.get(210) /// This service already in the cart
    ){
  for (var item in cart)
    if (item.id == service.id)
      return stringAlreadyInCart;
  cart.add(ProductData.clone(service));
  cartSave();
  return null;
}

removeFromCart(ProductData service){
  for (var item in cart)
    if (item.id == service.id){
      cart.remove(item);
      cartSave();
      return;
    }
}

cartSave(){
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "user == null";

  // сохраняем сервисы и артикли (товар) отдельно - в профиле пользоателя.
  // сохраняем
  //      для сервисов - (киличество, какая цена выбрана и какие addon'ы)
  //      для сервисов - сохраняем полность group
  List<CartData> _list = [];
  for (var item in cart){
    CartData data;
    if (item.thisIsArticle)
      data = CartData(
        id: item.id, // service or article id
        thisIsArticle: item.thisIsArticle, // service by default. If true article
        // service
        selectedPrice: PriceData.createEmpty(), // only for service
        count: item.countProduct,
        addons: [], // only for service
        // article
        group: item.group
      );
    else{
      List<AddonData> _addon = [];
      for (var item in item.addon)
        if (item.selected)
          _addon.add(item);
      PriceData _price = PriceData.createEmpty();
      for (var item in item.price)
        if (item.selected)
          _price = item;
      data = CartData(
          id: item.id, // service or article id
          thisIsArticle: item.thisIsArticle, // service by default. If true article
          // service
          selectedPrice: _price, // only for service
          count: item.countProduct,
          addons: _addon, // only for service
          // article
          group: []
      );
    }
    _list.add(data);
  }

  FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
    "cartData": _list.map((i) => i.toJson()).toList(),
  }, SetOptions(merge:true));
}

var _init = false;

bool _notEqual = false;

isPricesEqual(List<PriceData> _serverGroup, List<PriceData> _cartGroup){
  for (var pair in zip([_serverGroup, _cartGroup])){
    var s = pair[0]; // _serverGroup
    var c = pair[1]; // _cartGroup
    s.selected = false;
    if (c.price == s.price && c.discPrice == s.discPrice)
      s.selected = c.selected;
    else
      _notEqual = true;
  }
}

isGroupEqual(List<GroupData> serverGroup, List<GroupData> cartGroup){
  for (var pair in zip([serverGroup, cartGroup])){
    var s = pair[0]; // serverGroup
    var c = pair[1]; // cartGroup
    if (s.id == c.id)
      isPricesEqual(s.price, c.price);
    else
      _notEqual = true;
  }
}


initCart() async {
  var user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return;
  if (_init)
    return;
  _init = true;
  for (var item in userAccountData.cartData) {
    if (item.thisIsArticle){
      var ret = await articleGetItemToEdit(ProductDataCache.createEmpty(item.id));
      if (ret == null){
        var newItem = ProductData.clone(currentArticle);
        if (currentArticle.group.isNotEmpty) {
          List<GroupData> _group = [];
          for (var g in currentArticle.group)
            _group.add(GroupData.clone(g));
          // потом смотрим в item (то что ложили в cart)
          _notEqual = false;
          isGroupEqual(_group, item.group);
          newItem.group = _group;
        }
        newItem.countProduct = item.count;
        if (!_notEqual) {
          // проверяем есть ли еще такой провайдер
          if (newItem.providers.isNotEmpty)
            if (getProviderById(newItem.providers[0]) == null)
              continue;
          cart.add(newItem);
        }
      }
    }else{
      ProductData product = getProduct(item.id);
      if (product.id.isNotEmpty){
        var newItem = ProductData.clone(product);
        // service
        newItem.countProduct = item.count;
        for (var p in newItem.price)
          p.selected = false;
        for (var p in newItem.price)
          if (p.price == item.selectedPrice.price && p.discPrice == item.selectedPrice.discPrice) {
            p.selected = true;
            break;
          }
        for (var a in newItem.addon)
          a.selected = false;

        for (var h in item.addons)
          for (var a in newItem.addon)
            if (getTextByLocale(a.name, locale) == getTextByLocale(h.name, locale)) {
              a.selected = true;
              a.needCount = h.needCount;
            }
        // проверяем есть ли еще такой провайдер
        if (newItem.providers.isNotEmpty)
          if (getProviderById(newItem.providers[0]) != null)
            cart.add(newItem);
      }
    }
  }
}

// _removeCheckoutFromCart(){
//   for (var item in userAccountData.cartList)
//     for (var service in cart)
//       if (service.id == item){
//         cart.remove(service);
//         break;
//       }
//   _cartSave();
// }

// _allCheckout(){
//   checkout = [];
//   for (var item in cart)
//     if (item.providers.isNotEmpty)
//       checkout.add(item.providers[0]);
// }

checkoutProvider(ProviderData provider){
  cartCurrentProvider = provider;
  // checkout = [];
  // for (var item in cart)
  //   if (item.providers.isNotEmpty)
  //     if (item.providers[0] == provider.id)
  //       checkout.add(item.providers[0]);
}

String cartLastAddedId = "";

cartFinish(OrderData _data) async{
  Map<String, dynamic> d = _data.toJson();
  var t = await FirebaseFirestore.instance.collection("booking").add(d);
  cartLastAddedId = t.id;
  cartLastAddedIdToUser = t.id;
  _data.id = t.id;
  await bookingSaveInCache(_data);
  _clearCart();
  // await FirebaseFirestore.instance.collection("settings").doc("main")
  //     .set({"booking_count": FieldValue.increment(1)}, SetOptions(merge:true));
  // await FirebaseFirestore.instance.collection("settings").doc("main")
  //     .set({"booking_count_unread": FieldValue.increment(1)}, SetOptions(merge:true));
}

_clearCart(){
  if (cartCurrentProvider != null)
    cart.removeWhere((service) {
      if (service.providers.isNotEmpty && cartCurrentProvider!.id == service.providers[0])
        return true;
      if (cartCurrentProvider!.id == "root" && service.providers.isEmpty)
        return true;
      return false;
    });
  // List<ProductData> list = [];
  // for (var service in cart){
  //   if (cartCurrentProvider != null && service.providers.isNotEmpty && service.providers[0] == cartCurrentProvider!.id)
  //     list.add(service);

    // if (cartCurrentProvider != null && service.providers.isNotEmpty && service.providers[0] != cartCurrentProvider!.id)
    //   list.add(service);
   // if (service.providers.isNotEmpty && cartCurrentProvider != null && cartCurrentProvider!.id == "root")
     // list.add(service);
  // }
  //
  // cart.re = list;
  cartSave();
}

List<ProductData> cartGetProductsForBooking(){
  List<ProductData> list = [];
  for (var service in cart){
    if ((cartCurrentProvider != null && service.providers.isNotEmpty && service.providers[0] == cartCurrentProvider!.id)
        || (service.providers.isEmpty && cartCurrentProvider != null && cartCurrentProvider!.id == "root"))
    // if (cartCurrentProvider != null && service.providers.isNotEmpty)
    //   if (service.providers[0] == cartCurrentProvider!.id){
        list.add(service);
      // }
  }
  return list;
}

String cartGetImage(){
  for (var service in cart){
    if (service.providers.isEmpty && cartCurrentProvider != null && cartCurrentProvider!.id == "root")
      return appSettings.customerLogoServer;
    if (cartCurrentProvider != null && service.providers.isNotEmpty)
      if (service.providers[0] == cartCurrentProvider!.id){
        if (service.gallery.isNotEmpty)
          return service.gallery[0].serverPath;
      }
  }
  return "";
}

List<String> _cartGetProviders(){
  List<String> ret = [];
  for (var item in cart) {
    if (item.providers.isNotEmpty) {
      if (!ret.contains(item.providers[0]))
        ret.addAll(item.providers);
    }else{
      if (!ret.contains("root"))
        ret.add("root");
    }
  }
  return ret;
}

List<ProviderData> cartGetProvidersData(){
  List<ProviderData> ret = [];
  List<String> list = _cartGetProviders();
  List<String> added = [];
  for (var item in list){
    if (added.contains(item))
      continue;
    if (item == "root") {
      var t = ProviderData.createEmpty()..id = "root";
      ret.add(t);
      added.add(item);
    }
    var t = getProviderById(item);
    if (t != null) {
      ret.add(t);
      added.add(item);
    }
  }
  return ret;
}

_work(List<PriceForCardData> list, ProductData service){
  if (service.thisIsArticle){
    currentArticle = service;
    double _price = 0;
    var t = articleGetTotalPrice();
    double _withoutCount = 0;
    if (t != null) {
      _price = t * service.countProduct;
      _withoutCount = t;
    }
    var name = articleGetFullName();
    list.add(PriceForCardData(
      priceWithCount: _price,
      priceWithoutCount: _withoutCount,
      priceAddons: 0,
      subTotal: _price,
      name: name,
      priceString: getPriceString(_price),
      priceAddonsString: getPriceString(0),
      subTotalString: getPriceString(_price),
      isArticle: true,
      count: service.countProduct,
      priceWithoutCountString: getPriceString(_withoutCount),
      tax: _price*service.tax/100,
      taxPercentage: service.tax,
      addonText: "",
      image: service.gallery.isNotEmpty ? service.gallery[0].serverPath : "",
    ));
  }else{
    countProduct = service.countProduct;
    setDataToCalculate(null, service);

    var _price = getCostWidthCount();
    var addons = getAddonsTotal();
    var name = getTextByLocale(service.name, locale) + " " + getTextByLocale(price.name, locale);

    var _tax = (_price+addons)*service.tax/100;
    String _addonText = "";
    for (var item in service.addon)
      _addonText += "${getTextByLocale(item.name, locale)} ${item.needCount} x ${getPriceString(item.price)}\n";

    list.add(PriceForCardData(
      priceWithCount: _price,
      priceWithoutCount: getCost(),
      priceAddons: addons,
      subTotal: _price+addons,
      name: name,
      priceString: getPriceString(_price),
      priceAddonsString: getPriceString(addons),
      subTotalString: getPriceString(_price+addons),
      isArticle: false,
      count: service.countProduct,
      priceWithoutCountString: getPriceString(getCost()),
      tax: _tax,
      taxPercentage: service.tax,
      addonText: _addonText,
      image: service.gallery.isNotEmpty ? service.gallery[0].serverPath : "",
    ));
  }
}

List<PriceForCardData> cartGetPriceForAllServices(){
  return cartGetPriceForAllServices2(cart);
}

List<PriceForCardData> cartGetPriceForAllServices2(List<ProductData> _cart){
  List<PriceForCardData> list = [];

  for (var service in _cart){
    if (service.providers.isEmpty && cartCurrentProvider != null && cartCurrentProvider!.id == "root") { // root
      _work(list, service);
    }
    if (cartCurrentProvider != null && service.providers.isNotEmpty)
      if (service.providers[0] == cartCurrentProvider!.id){
        _work(list, service);
      }
  }

  return list;
}

PriceTotalForCardData cartGetTotalForAllServices() {
  return cartGetTotalForAllServices2(cart);
}

PriceTotalForCardData cartGetTotalForAllServices2(List<ProductData> _cart) {
  double subtotal = 0;
  double coupon = 0;
  double tax = 0;
  double total = 0;
  double toAdmin = 0;
  for (var service in _cart){
    if ((cartCurrentProvider != null && service.providers.isNotEmpty && service.providers[0] == cartCurrentProvider!.id)
        || (service.providers.isEmpty && cartCurrentProvider != null && cartCurrentProvider!.id == "root")){
      if (service.thisIsArticle) {
        currentArticle = service;
        var t = articleGetTotalPrice();
        if (t != null) {
          t *= service.countProduct;
          var _tax = service.tax / 100 * t;
          subtotal += t;
          tax += _tax;
          total += (t + _tax);
          toAdmin += (getSubTotalWithCoupon() * service.taxAdmin / 100);
        }
      } else {
        countProduct = service.countProduct;
        setDataToCalculate(null, service);
        subtotal += getSubTotalWithCoupon();
        coupon += getCoupon();
        tax += getTax();
        total += getTotal();
        toAdmin += (getSubTotalWithCoupon() * service.taxAdmin / 100);
      }
    }
  }
  return PriceTotalForCardData(subtotal, coupon, toAdmin, tax, total,
    getPriceString(coupon),
    getPriceString(tax),
    getPriceString(total),
  );
}

class PriceForCardData{
  final String name;
  final int count;
  final double priceWithoutCount;
  final double priceWithCount;
  final double priceAddons;
  final double subTotal;
  final double tax;
  final String priceString;
  final String priceAddonsString;
  final String subTotalString;
  final String priceWithoutCountString;
  final bool isArticle;
  final double taxPercentage;
  final String addonText;
  final String image;
  PriceForCardData({required this.priceWithCount, required this.priceWithoutCount, required this.priceAddons,
    required this.subTotal, required this.name, required this.priceString, required this.priceAddonsString,
    required this.subTotalString, required this.isArticle, required this.count, required this.priceWithoutCountString,
    required this.tax, required this.taxPercentage, required this.addonText, required this.image});
}

class PriceTotalForCardData{
  final double subtotal;
  final double discount;
  final double toAdmin;
  final double tax;
  final double total;
  final String discountString;
  final String taxString;
  final String totalString;
  PriceTotalForCardData(this.subtotal, this.discount, this.toAdmin, this.tax, this.total,
      this.discountString, this.taxString, this.totalString);
}

class CartData {
  String id; // service or article id
  bool thisIsArticle; // service by default. If true article
  // service
  PriceData selectedPrice; // only for service
  int count; // service and article
  List<AddonData> addons; // only for service. Only selected
  // article
  List<GroupData> group;

  CartData({required this.id, required this.thisIsArticle,
    required this.selectedPrice, required this.count, required this.addons,
    required this.group
  });

  Map<String, dynamic> toJson({bool local = false}) => {
    'id': id,
    'thisIsArticle': thisIsArticle,
    'selectedPrice': selectedPrice.toJson(),
    'count': count,
    'addons': addons.map((i) => i.toJson()).toList(),
    'group': group.map((i) => i.toJson()).toList(),
  };

  factory CartData.fromJson(Map<String, dynamic> data){
    List<AddonData> _addon = [];
    if (data['addons'] != null)
      for (var element in List.from(data['addons'])) {
        _addon.add(AddonData.fromJson(element));
      }
    List<GroupData> _group = [];
    if (data['group'] != null)
      for (var element in List.from(data['group'])) {
        _group.add(GroupData.fromJson(element));
      }
    PriceData _price =  PriceData.createEmpty();
    if (data['selectedPrice'] != null)
      _price = PriceData.fromJson(data['selectedPrice']);
    return CartData(
      id: data["id"] ?? "",
      thisIsArticle: data["thisIsArticle"] ?? true,
      selectedPrice: _price,
      count: (data["count"] != null) ? toInt(data["count"].toString()) : 0,
      addons: _addon,
      group: _group,
    );
  }

}



tablePricesV4(List<Widget> list, List<ProductData> _cart,
    String stringAddons, /// strings.get(221) /// "Addons"
    String stringSubtotal,    /// strings.get(235) /// "Subtotal"
    String stringDiscount,  /// strings.get(236) /// "Discount"
    String stringVaT, /// strings.get(276) /// "VAT/TAX"
    String stringTotal /// strings.get(263) /// "Total amount"
    ){
  List<Widget> listPrices = [];
  for (var item in cartGetPriceForAllServices2(_cart)){
    listPrices.add(Column(
      children: [

        SizedBox(height: 10,),
        Row(
          children: [
            Expanded(child: Text(item.name, style: aTheme.style13W400,)),
            Text(item.priceString, style: aTheme.style13W400,)
          ],
        ),

        if (item.priceAddons != 0)
          SizedBox(height: 10,),
        if (item.priceAddons != 0)
          Row(
            children: [
              Expanded(child: Text(stringAddons, style: aTheme.style13W400,)), /// "Addons"
              Text("(+) ${item.priceAddons}", style: aTheme.style13W400,)
            ],
          ),

        if (!item.isArticle && item.subTotal != item.priceWithCount)
          SizedBox(height: 10,),
        if (!item.isArticle && item.subTotal != item.priceWithCount)
          Row(
            children: [
              Expanded(child: Text(stringSubtotal, style: aTheme.style13W400,)), /// "Subtotal"
              Text(item.subTotalString, style: aTheme.style13W400,)
            ],
          ),
        SizedBox(height: 10,),
        Divider(height: 0.5, color: Colors.grey,),
        // SizedBox(height: 10,),
      ],
    ));
  }

  var _totalPrice = cartGetTotalForAllServices2(_cart);

  list.add(Container(
      color: (aTheme.darkMode) ? Colors.black : Colors.white,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),

              //
              // price
              //
              ...listPrices,
              SizedBox(height: 10,),

              Row(
                children: [
                  Expanded(child: Text(stringDiscount, style: aTheme.style13W400,)), /// "Discount"
                  Text("(-) ${_totalPrice.discountString}", style: aTheme.style13W400,)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: Text(stringVaT, style: aTheme.style13W400,)), /// "VAT/TAX"
                  Text("(+) ${_totalPrice.taxString}", style: aTheme.style13W400,)
                ],
              ),
              SizedBox(height: 10,),
              Divider(height: 0.5, color: Colors.grey,),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: Text(stringTotal, style: aTheme.style14W800MainColor,)), /// "Total amount"
                  Text(_totalPrice.totalString, style: aTheme.style14W800MainColor,)
                ],
              ),
              SizedBox(height: 10,),
            ],
          )
      )));
}