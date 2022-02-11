import 'package:flutter/material.dart';

button206(int value, TextStyle style, Color borderColor, Color iconsColor, Color bkgColor, Function(int) callback){
  return ToggleButtons(
    children: <Widget>[
      Icon(Icons.exposure_minus_1, color: iconsColor,),
      Center(child: Text(value.toString(), style: style,)),
      Icon(Icons.plus_one, color: iconsColor,),
    ],
    borderWidth: 1,
    // borderColor: Colors.blue,
    selectedBorderColor: borderColor,
    splashColor: Colors.purple.withAlpha(66),
    borderRadius: BorderRadius.circular(10),
    selectedColor: borderColor,
    fillColor: bkgColor,
    isSelected: [true, true, true],
    onPressed: (value2) {
      if (value2 == 0 && value > 1)
        callback(value-1);
      if (value2 == 2)
        callback(value+1);
    },
  );
}
