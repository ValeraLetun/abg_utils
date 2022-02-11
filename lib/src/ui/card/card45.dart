import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

// 01.11.2021
// from provider v2

card45(double windowWidth,
    double line5, double line4, double line3, double line2, double line1,
    double stars, String reviews, String buttonText,
    Function() onButtonClick){

  if (line5 < 0) line5 = 0;
  if (line5 > 1) line5 = 1;
  if (line4 < 0) line4 = 0;
  if (line4 > 1) line4 = 1;
  if (line3 < 0) line3 = 0;
  if (line3 > 1) line3 = 1;
  if (line2 < 0) line2 = 0;
  if (line2 > 1) line2 = 1;
  if (line1 < 0) line1 = 0;
  if (line1 > 1) line1 = 1;

  var onePercent = (line1+line2+line3+line4+line5)/100;
  var shadow = false;

  return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: (aTheme.darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: (shadow) ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ] : null,
      ),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              _item(windowWidth, line5, "5", Colors.green, (onePercent.isNaN || line5.isNaN || onePercent == 0) ? 0 : line5~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line4, "4", Colors.greenAccent, (onePercent.isNaN || line4.isNaN || onePercent == 0) ? 0 : line4~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line3, "3", Colors.yellow, (onePercent.isNaN || line3.isNaN || onePercent == 0) ? 0 : line3~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line2, "2", Colors.orange, (onePercent.isNaN || line2.isNaN || onePercent == 0) ? 0 : line2~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line1, "1", Colors.red, (onePercent.isNaN || line1.isNaN || onePercent == 0) ? 0 : line1~/onePercent),
              SizedBox(height: 10,),
            ],
          )),

          SizedBox(width: 10,),
          Container(
            width: windowWidth*0.3-10,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(stars.isNaN ? "0" : stars.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: Colors.grey),),
                    Icon(Icons.star, color: Colors.orange, size: 35,)
                  ],),
                SizedBox(height: 5,),
                Text(reviews, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),),
                SizedBox(height: 15,),
                button2(buttonText, Colors.green, onButtonClick)
              ],
            ),
          )
        ],
      ));
}

_item(double windowWidth, double width, String text, Color color, int percentage){
  // dprint("card45 _item all=${windowWidth*0.5-25} active=${windowWidth*0.5*width-25} width=$width");

  return Row(children: [
    Text(text, style: TextStyle(color: Colors.grey),),
    SizedBox(width: 10,),
    Expanded(child: Stack(
      children: [
        Container(
            width: windowWidth*0.5-25,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(40),
              borderRadius: BorderRadius.circular(10),
            )
        ),
        if (windowWidth*0.5*width-25 > 0)
          Container(
              width: windowWidth*0.5*width-25,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              )
          )
      ],
    )),
    SizedBox(width: 5,),
    Text("$percentage%", style: TextStyle(color: Colors.grey),),
  ], );
}


/* provider v1

// 01.11.2021

card45(double windowWidth,
    double line5, double line4, double line3, double line2, double line1,
    double stars, String reviews, String buttonText,
    Color bkgColor,
    Color color, bool shadow, Function() onButtonClick){

  if (line5 < 0) line5 = 0;
  if (line5 > 1) line5 = 1;
  if (line4 < 0) line4 = 0;
  if (line4 > 1) line4 = 1;
  if (line3 < 0) line3 = 0;
  if (line3 > 1) line3 = 1;
  if (line2 < 0) line2 = 0;
  if (line2 > 1) line2 = 1;
  if (line1 < 0) line1 = 0;
  if (line1 > 1) line1 = 1;

  var onePercent = (line1+line2+line3+line4+line5)/100;

  return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: bkgColor,
        borderRadius: new BorderRadius.circular(10),
        boxShadow: (shadow) ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ] : null,
      ),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              _item(windowWidth, line5, "5", Colors.green, (onePercent.isNaN || line5.isNaN || onePercent == 0) ? 0 : line5~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line4, "4", Colors.greenAccent, (onePercent.isNaN || line4.isNaN || onePercent == 0) ? 0 : line4~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line3, "3", Colors.yellow, (onePercent.isNaN || line3.isNaN || onePercent == 0) ? 0 : line3~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line2, "2", Colors.orange, (onePercent.isNaN || line2.isNaN || onePercent == 0) ? 0 : line2~/onePercent),
              SizedBox(height: 10,),
              _item(windowWidth, line1, "1", Colors.red, (onePercent.isNaN || line1.isNaN || onePercent == 0) ? 0 : line1~/onePercent),
              SizedBox(height: 10,),
            ],
          )),

          SizedBox(width: 10,),
          Container(
            width: windowWidth*0.3-10,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(stars.isNaN ? "0" : stars.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: Colors.grey),),
                    Icon(Icons.star, color: Colors.orange, size: 35,)
                  ],),
                SizedBox(height: 5,),
                Text(reviews, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),),
                SizedBox(height: 15,),
                button2(buttonText, Colors.green, onButtonClick)
              ],
            ),
          )
        ],
      ));
}

_item(double windowWidth, double width, String text, Color color, int percentage){
  dprint("card45 _item all=${windowWidth*0.5-25} active=${windowWidth*0.5*width-25} width=$width");

  return Row(children: [
    Text(text, style: TextStyle(color: Colors.grey),),
    SizedBox(width: 10,),
    Expanded(child: Stack(
      children: [
        Container(
            width: windowWidth*0.5-25,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(40),
              borderRadius: new BorderRadius.circular(10),
            )
        ),
        if (windowWidth*0.5*width-25 > 0)
          Container(
              width: windowWidth*0.5*width-25,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: new BorderRadius.circular(10),
              )
          )
      ],
    )),
    SizedBox(width: 5,),
    Text("$percentage%", style: TextStyle(color: Colors.grey),),
  ], );
}
 */