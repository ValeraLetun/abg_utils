import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

button1s(String text, IconData icon, String route, Function(String) callback, {Decoration? decor}) {
  return InkWell(
      onTap: (){
        callback(route);
      },
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          decoration: decor,
          child: Row(
            children: [
              Icon(icon, color: aTheme.darkMode ? Colors.white: Colors.black,),
              SizedBox(width: 10,),
              Expanded(child: Text(text, style: aTheme.style14W400,))
            ],
          ))
  );
}

button1s2(String text, IconData icon, bool val, Function(bool) callback, {Decoration? decor}) {
  return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      decoration: decor,
      child: Row(
        children: [
          Icon(icon, color: aTheme.darkMode ? Colors.white: Colors.black,),
          SizedBox(width: 10,),
          Expanded(child: Text(text, style: aTheme.style14W400,)),
          Row(
            children: [
              CheckBox12((){return val;}, (bool val){
                callback(val);
              }, color: aTheme.mainColor),
            ],
          ),
        ],
      )
  );
}

button1s3(String text, String text2, {Decoration? decor, TextStyle? style}) {
  return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      decoration: decor,
      child: Column(
        children: [
          Text(text, style: style),
          SizedBox(height: 10,),
          Text(text2, style: aTheme.style12W400,)
        ],
      )
  );
}