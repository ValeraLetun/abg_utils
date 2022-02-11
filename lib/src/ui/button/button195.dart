import 'package:flutter/material.dart';

button195(String text, Color color, Function _callback, {bool enable = true, TextStyle? style}){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
          ),
          child: Text(text, style: style ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
            textAlign: TextAlign.center,)
      ),
      if (enable)
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30))),
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
