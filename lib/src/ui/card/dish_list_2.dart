import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

dishList2(List<Widget> list, List<ProductDataCache> _mostPopular,
    Function(String id) _onClick, Function(String) onAddToCartClick){

  var size = _mostPopular.length;

  List<Widget> _childs = [];
  bool first = true;

  var constHeight = windowWidth*0.7;
  var _height = constHeight;
  var y1Start = 10.0;
  var y2Start = 10.0;

  var index = 0;
  for (var item in _mostPopular) {

    if (first) {
      _height = constHeight;

      if (index == 0 && size > 2)
        _height = constHeight/2-5;

      if (index == size-1 && size > 2)
        _height = constHeight/2-5;

      first = false;
      _childs.add(Container(
        width: windowWidth/2-15,
        height: _height,
        margin: EdgeInsets.only(top: y1Start, left: 10, right: 5),
        child: _card32item(item, windowWidth, _height, _onClick, onAddToCartClick),
      ));
      y1Start += _height+10;
    }else{
      _height = constHeight;

      if (index == size-1 && size > 2)
        _height = constHeight/2-5;

      first = true;
      var margin = EdgeInsets.only(left: windowWidth/2+5, top: y2Start, right: 10);
      if (direction == TextDirection.rtl)
        margin = EdgeInsets.only(right: windowWidth/2+5, top: y2Start, left: 10);

      _childs.add(Container(
        width: windowWidth/2-15,
        height: _height,
        margin: margin,
        child: _card32item(item, windowWidth, _height, _onClick, onAddToCartClick),
      ));

      y2Start += (_height+10);
    }
    index++;
  }
  if (y2Start == 10)
    y2Start = _height;
  if (size == 1 || size == 2)
    y2Start = constHeight;
  if (_childs.isNotEmpty)
    list.add(Container(
      width: windowWidth,
      height: y2Start+20,
      child: Stack(
        children: _childs,
      ),
    ));
  return;
}

_card32item(ProductDataCache item, double windowWidth, double _height, Function(String id)  _onMostPopularClick,
    Function(String) onAddToCartClick){
  return ProductsTileListV2(
    bannerText: "FAVORITE",
    text: getTextByLocale(item.name, locale),
    width: windowWidth * 0.5 - 20,
    height: _height,
    image: item.image,
    id: item.id,
    //
    price: getPriceString(item.discPrice),
    discountPrice: getPriceString(item.discPrice),
    //
    onAddToCartClick: onAddToCartClick,
    callback: _onMostPopularClick,
  );
}