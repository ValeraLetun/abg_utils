import 'package:flutter/material.dart';

import '../../abg_utils.dart';

bool init = false;
bool rightSymbol = false;
int digitsAfterComma = 2;
String symbol = "\$";
String distanceUnit = "km";

setPriceStringData(bool _rightSymbol, int _digitsAfterComma, String _symbol, String _distanceUnit){
  init = true;
  rightSymbol = _rightSymbol;
  digitsAfterComma = _digitsAfterComma;
  symbol = _symbol;
  distanceUnit = _distanceUnit;
}

String getPriceString(double price){
  if (!init)
    return "not init";
  if (!rightSymbol)
    return "$symbol${price.toStringAsFixed(digitsAfterComma)}";
  return "${price.toStringAsFixed(digitsAfterComma)}$symbol";
}

ProductData productData = ProductData.createEmpty();
PriceData price = PriceData.createEmpty();
int countProduct = 1;
// coupon
String couponId = "";     // 2746fde7643fgd
String couponCode = "";   // CODE25
String discountType = ""; // "percent" or "fixed"
double discount = 0;      // 12

double getCost(){
  return price.getPrice();
}

double getCostWidthCount(){
  return productData.countProduct*price.getPrice();
}

double getSubTotalWithoutCoupon(){
  return getCostWidthCount()+getAddonsTotal();
}

double getSubTotalWithCoupon(){
  var _price = getCostWidthCount();
  var _coupon = getCoupon();
  var _addon = getAddonsTotal();
  return _price-_coupon+_addon;
}

double getAddonsTotal(){
  double total = 0;
  for (var item in productData.addon)
    if (item.selected)
      total += (item.needCount*item.price);
  return total;
}

double getCoupon(){
  if (couponId.isEmpty)
    return 0;
  double total = getCostWidthCount();
  total += getAddonsTotal();
  if (discountType == "percent" || discountType == "percentage")
    return total*discount/100;
  return discount;
}

String getCouponStringData(){
  if (couponId.isEmpty)
    return "";
  if (discountType == "percent" || discountType == "percentage")
    return "$discount%";
  return getPriceString(discount);
}

double getTax(){
  return getSubTotalWithCoupon()*productData.tax/100;
}

double getTotal(){
  double _total = getSubTotalWithCoupon();
  var t = _total + getTax();
  return t < 0 ? 0 : t;
}

int getSelectedAddonsCount(){
  var ret = 0;
  for (var item in productData.addon)
    if (item.selected)
      ret++;
  return ret;
}

//
// service and filter
//

bool isDiscountedProduct(List<PriceData> price){
  for (var item in price)
    if (item.discPrice != 0)
      return true;
  return false;
}

double getMinAmountInProduct(List<PriceData> price){
  var _price = getMinPriceInProduct(price);
  if (_price.discPrice != 0)
    return _price.discPrice;
  return _price.price;
}

double getMaxAmountInProduct(List<PriceData> price){
  var _price = getMaxPriceInProduct(price);
  if (_price.discPrice != 0)
    return _price.discPrice;
  return _price.price;
}

PriceData getMinPriceInProduct(List<PriceData> price){
  PriceData currentPrice = PriceData.createEmpty();
  double _price = double.maxFinite;
  for (var item in price) {
    if (item.discPrice != 0){
      if (item.discPrice < _price) {
        _price = item.discPrice;
        currentPrice = item;
      }
    }else
      if (item.price < _price) {
        _price = item.price;
        currentPrice = item;
      }
  }
  if (_price == double.maxFinite)
    _price = 0;
  return currentPrice;
}

PriceData getMaxPriceInProduct(List<PriceData> price){
  PriceData currentPrice = PriceData.createEmpty();
  double _price = 0;
  for (var item in price) {
    if (item.discPrice != 0){
      if (item.discPrice > _price) {
        _price = item.discPrice;
        currentPrice = item;
      }
    }else
      if (item.price > _price) {
        _price = item.price;
        currentPrice = item;
      }
  }
  return currentPrice;
}

PriceData getSelectedPrice(List<PriceData> price){
  var _found = false;
  for (var item in price)
    if (item.selected)
      _found = true;
  if (!_found){
    var _currentPrice = getMinPriceInProduct(price);
    for (var item in price)
      if (_currentPrice == item)
        item.selected = true;
  }
  //
  for (var item in price)
    if (item.selected)
      return item;

  if (price.isNotEmpty)
    return price[0];

  return PriceData.createEmpty();
}


setDataToCalculate(OrderData? orderData, ProductData? _productData){
  productData = ProductData.createEmpty();

  if (_productData != null)
    productData = _productData;

  if (orderData != null) {
    couponId = orderData.couponId;
    discountType = orderData.discountType;
    couponCode = orderData.couponName;
    discount = orderData.discount;
    countProduct = orderData.count;
    productData = ProductData("", [], gallery: [],
      desc: [],
      descTitle: [],
      duration: Duration(),
      category: [],
      timeModify: DateTime.now(),
      providers: [],
      countProduct: orderData.count,
      tax: orderData.tax,
      price: [
        PriceData(orderData.priceName, orderData.price, orderData.discPrice,
            orderData.priceUnit, ImageData(serverPath: "", localFile: ""))
      ],
      addon: orderData.addon, group: [],
    );
  }

  price = PriceData.createEmpty();
  if (productData.price.isNotEmpty) {
    if (productData.price.length == 1)
      price = productData.price[0];
    else {
      for (var item in productData.price)
        if (item.selected)
          price = item;
    }
  }
  productData.countProduct = countProduct;
}

String getAddonText(String locale){
  String _ret = "";
  for (var item in productData.addon) {
    if (!item.selected)
      continue;
    _ret = "$_ret${getTextByLocale(item.name, locale)} ${item.needCount}x${getPriceString(item.price)}\n";
  }
  return _ret;
}

pricingTable(Function(String) _get){
  List<Widget> list = [];
  list.add(SizedBox(height: 5,));
  list.add(Divider(color: (aTheme.darkMode) ? Colors.white : Colors.black));
  list.add(SizedBox(height: 5,));
  list.add(Row(
    children: [
      Expanded(child: Text(_get("subtotal"), style: aTheme.style12W400)),
      Text(getPriceString(price.getPrice()*productData.countProduct), style: aTheme.style14W800,)
    ],
  ));
  list.add(SizedBox(height: 5,));
  list.add(Text(_get("addons") , style: aTheme.style12W600Grey,),);
  list.add(SizedBox(height: 10,));
  bool _found = false;
  for (var item in productData.addon) {
    if (!item.selected)
      continue;
    list.add(Container(
        margin: _get("direction") == TextDirection.ltr ? EdgeInsets.only(left: 20) : EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Expanded(child: Text("${getTextByLocale(item.name, _get("locale"))} ${item.needCount}x${getPriceString(item.price)}",
              style: aTheme.style12W400,)),
            SizedBox(width: 5,),
            Text(getPriceString(item.needCount*item.price),
              style: aTheme.style14W800,)
          ],
        )
    ));
    _found = true;
  }

  Widget _addons = Column(children: list,);

  return Container(
      padding: EdgeInsets.all(20),
      color: (aTheme.darkMode) ? Colors.black : Colors.white,
      child: Column(
        children: [
          Text(_get("pricing"), style: aTheme.style14W800),
          Divider(color: (aTheme.darkMode) ? Colors.white : Colors.black),
          SizedBox(height: 5,),
          Row(
            children: [
              Expanded(child: Text(getTextByLocale(price.name, _get("locale")), style: aTheme.style12W400)),
              Text(getPriceString(price.getPrice()), style: aTheme.style14W800,)
            ],
          ),
          SizedBox(height: 5,),
          // Divider(color: (aTheme.darkMode) ? Colors.white : Colors.black),
          SizedBox(height: 5,),
          Row(
            children: [
              Expanded(child: Text(_get("quantity"), style: aTheme.style12W400,)),
              Text(productData.countProduct.toString(), style: aTheme.style14W800,)
            ],
          ),

          if (_found)
            _addons,

          SizedBox(height: 5,),
          Divider(color: (aTheme.darkMode) ? Colors.white : Colors.black),
          SizedBox(height: 5,),

          Row(
            children: [
              Expanded(child: Text(_get("subtotal"), style: aTheme.style12W400)),
              Text(getPriceString(getSubTotalWithoutCoupon()), style: aTheme.style14W800,)
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Text(_get("discount"), style: aTheme.style12W400)),
              Text("(-${getCouponStringData()}) ${getPriceString(getCoupon())}", style: aTheme.style14W800,)
            ],
          ),

          if (getCoupon() != 0)
            SizedBox(height: 5,),
          if (getCoupon() != 0)
            Divider(color: (aTheme.darkMode) ? Colors.white : Colors.black),
          if (getCoupon() != 0)
            SizedBox(height: 5,),
          if (getCoupon() != 0)
            Row(
              children: [
                Expanded(child: Text(_get("subtotal"), style: aTheme.style12W400)),
                Text(getPriceString(getSubTotalWithCoupon()), style: aTheme.style14W800,)
              ],
            ),
          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(child: Text(_get("taxAmount"), style: aTheme.style12W400)),
              Text("(+${productData.tax}%) ${getPriceString(getTax())}", style: aTheme.style14W800,)
            ],
          ),
          SizedBox(height: 5,),
          Divider(color: (aTheme.darkMode) ? Colors.white : Colors.black),
          SizedBox(height: 5,),
          Row(
            children: [
              Expanded(child: Text(_get("total"), style: aTheme.style12W400)),
              Text(getPriceString(getTotal()), style: aTheme.style16W800Orange,)
            ],
          ),
        ],
      )
  );
}