import 'package:flutter/material.dart';

button98(Color color, IconData _icon, Function() _callback, {bool enable = true, Color iconColor = Colors.white,
      double size = 50}){
  return Stack(
    children: <Widget>[
      Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: (enable) ? color : Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(size),
        ),
        child: Container(
            height: size/2,
            width: size/2,
            child: Icon(_icon, color: iconColor,)
        ),
      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(size)),
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
