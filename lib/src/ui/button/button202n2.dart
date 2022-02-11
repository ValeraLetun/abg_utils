import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

button202n2(ProductDataCache item, double width,
    String locale,
    String stringNotAvailable,  /// strings.get(30) /// Not available Now
    Function() _callback
    ){

  String name = getTextByLocale(item.name, locale);
  String textPrice = getPriceString(item.price);
  String textDiscPrice = item.discPrice != 0 ? getPriceString(item.discPrice) : "";

  //
  bool available = true;
  var t = item.providers.isNotEmpty ? getProviderById(item.providers[0]) : null;
  if (t != null)
    available = t.available;

  var sale = "";
  if (item.discPrice != 0) {
    var t = item.price / 100;
    var t1 = (item.price-item.discPrice)/t;
    sale = "-${t1.toStringAsFixed(0)}% OFF";
  }

  return Stack(
    children: <Widget>[

      Container(
          width: width,
          decoration: BoxDecoration(
            color: (aTheme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(aTheme.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(aTheme.radius), topRight: Radius.circular(aTheme.radius)),
                child: Container(
                    width: width,
                    height: width,
                    child: Stack(
                      children: [
                        showImage(item.image, fit: BoxFit.scaleDown),
                        if (!available)
                          Container(
                            color: Colors.black.withAlpha(100),
                            child: Center(child: Text(stringNotAvailable, style: aTheme.style10W800White,
                              textAlign: TextAlign.center,)),
                          )
                      ],
                    )
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(name, style: aTheme.style11W600, textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    SizedBox(height: 3,),
                    SizedBox(height: 3,),
                    Row(children: [
                      Text(textPrice, style: textDiscPrice.isEmpty ? aTheme.style13W800 : aTheme.style12W400D,
                        overflow: TextOverflow.clip, maxLines: 1,),
                      SizedBox(width: 3,),
                      if (textDiscPrice.isNotEmpty)
                        Expanded(child: FittedBox(fit: BoxFit.scaleDown,
                            child :Text(textDiscPrice, style: aTheme.style13W800Red, overflow: TextOverflow.clip, maxLines: 1,))),
                    ]
                    ),
                    SizedBox(height: 3,),
                  ],
                ),
              ),


            ],
          )
      ),

      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(aTheme.radius)),
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.2),
              onTap: (){
                if (available)
                  _callback();
              }, // needed
            )),
      ),

      if (sale.isNotEmpty)
        Positioned.fill(
            child: Container(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.all(3),
                  color: Colors.green,
                  margin: EdgeInsets.only(top: 8),
                  child: Text(sale, style: aTheme.style10W400White)
              ),
            )),


    ],
  );
}
