import 'package:flutter/material.dart';

button134(String text, Function _callback, {bool enable = true, TextStyle? style}){
  return Stack(
    children: <Widget>[
      Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: style, textAlign: TextAlign.center,),
        ],
      )),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              // shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(100) ),
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
