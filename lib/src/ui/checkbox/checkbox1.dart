import 'package:flutter/material.dart';

checkBox1(String text, Color color, TextStyle style, bool init, Function(bool?) callback){
  return Row(
    children: <Widget>[
    SizedBox(
    height: 24.0,
    width: 24.0,
    child: Checkbox(
        value: init,
        activeColor: color,
        onChanged: callback
      ),),
      SizedBox(width: 10,),
      Flexible(
          child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, style: style, overflow: TextOverflow.ellipsis,)))
    ],
  );
}

checkBox1a(BuildContext context, String text, Color color, TextStyle style, bool init, Function(bool?) callback){
  return Theme(
      data: Theme.of(context).copyWith(
      unselectedWidgetColor: Colors.grey,
      disabledColor: Colors.grey
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: Checkbox(
            value: init,
            activeColor: color,
            onChanged: callback
        ),),
      if (text.isNotEmpty)
        SizedBox(width: 10,),
      if (text.isNotEmpty)
        Flexible(
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(text, style: style, overflow: TextOverflow.ellipsis,)))
    ],
  ));
}
