import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

// кнопка на всю ширину экрана

button2(String text, Color color, Function() _callback,
    {
      bool enable = true,
      TextStyle? style, double? radius,
      double? width = double.maxFinite,
      EdgeInsetsGeometry? padding,
    }){
  return Stack(
    children: <Widget>[
      Container(
          width: width,
          padding: padding ?? EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(radius ?? aTheme.radius),
          ),
          child: FittedBox(fit: BoxFit.scaleDown,
              child: Text(text, style: style ?? aTheme.style14W600White,
                textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,))
      ),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(aTheme.radius) ),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}

button2b(String text, Function _callback, {TextStyle? style, bool enable = true, Color? color,}){
  var _color = aTheme.mainColor;
  if (color != null)
    _color = color;
  return Stack(
    children: <Widget>[
      Container(
          decoration: BoxDecoration(
            color: (enable) ? _color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(aTheme.radius),
          ),
          child: Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 7, bottom: 7, left: 13, right: 13),
                  child: FittedBox(fit: BoxFit.scaleDown,
                    child: Text(text, style: style ?? aTheme.style14W600White,
                      textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
                  )),

              if (enable)
                Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(aTheme.radius) ),
                      child: InkWell(
                        splashColor: Colors.black.withOpacity(0.2),
                        onTap: (){
                          _callback();
                        }, // needed
                      )),
                )

            ],
          )
      ),
    ],
  );
}


button2c(String text, Color color, Function _callback, {TextStyle? style, bool enable = true}){
  return Container(
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(aTheme.radius),
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: FittedBox(fit: BoxFit.scaleDown,
                  child: Text(text, style: style ?? aTheme.style16W800White,
                  textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
              )),

              if (enable)
                Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(aTheme.radius) ),
                      child: InkWell(
                        splashColor: Colors.black.withOpacity(0.2),
                        onTap: (){
                          _callback();
                        }, // needed
                      )),
                )

            ],
          )
  );
}


button2small(String text, Function _callback, {bool enable = true, Color? color}){
  var _color = aTheme.mainColor;
  if (color != null) _color = color;
  return Stack(
    children: <Widget>[
      Container(
          decoration: BoxDecoration(
            color: (enable) ? _color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(aTheme.radius),
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                child: Text(text, style: aTheme.style12W600White, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
              ),
              if (enable)
                Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(aTheme.radius) ),
                      child: InkWell(
                        splashColor: Colors.black.withOpacity(0.2),
                        onTap: (){
                          _callback();
                        }, // needed
                      )),
                )
            ],
        )
      ),
    ],
  );
}

button2outline(String text, TextStyle style, Color color, double _radius, Function _callback, bool enable, Color colorBkg){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: colorBkg,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
      ),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(_radius) ),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}


button2twoLine(String name, String price, bool selected, Function() callback ){

  bool enable = true;
  Color color = selected ? aTheme.mainColor : Colors.grey.withAlpha(20);

  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: color, //(enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(aTheme.radius),
            border: Border.all(color: Colors.grey.withAlpha(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1),
              ),
            ],
          )
          // BoxDecoration(
          //   color: (enable) ? color : Colors.grey.withOpacity(0.5),
          //   borderRadius: BorderRadius.circular(_radius),
          // )
          ,
          child: Column(
            children: [
              Text(name, style: selected ? aTheme.style11W800W : aTheme.style11W600,
                textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
              SizedBox(height: 6,),
              Text(price, style: selected ? aTheme.style11W800W : aTheme.style11W600,
                textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1,),
            ],
          )
      ),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(aTheme.radius) ),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  callback();
                }, // needed
              )),
        )
    ],
  );
}


