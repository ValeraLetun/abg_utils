import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

button144(String text,
    String image, double height, Function _callback,
    {String text2 = "", String text3 = "",
      TextStyle? style, TextStyle? style2, TextStyle? style3, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
      bool shadow = true, Color? color,
    }){
  return Stack(
    children: <Widget>[

      Container(
        margin: EdgeInsets.all(5),
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(aTheme.radius),
            border: (!shadow) ? Border.all(color: Colors.grey.withAlpha(40)) : null,
            boxShadow: !shadow ? null : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(aTheme.radius),
                      bottomLeft: Radius.circular(aTheme.radius)),
                  child: Container(
                      // width: width*0.3,
                      height: height,
                      child: Image.asset(image,
                        fit: BoxFit.cover,
                      )),
                ),
              ),

              Expanded(
                  flex: 2,
                  child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      SizedBox(height: 5,),
                      if (text.isNotEmpty)
                        Text(text, style: style, ),
                      if (text2.isNotEmpty || text3.isNotEmpty)
                      Row(children: [
                        if (text2.isNotEmpty)
                          Expanded(child: Text(text2, style: style2, textAlign: TextAlign.start,)),
                        if (text3.isNotEmpty)
                          Text(text3, style: style3,),
                      ],),
                      SizedBox(height: 5,),
                    ],
                  ))),
              SizedBox(height: 2,),
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
                  _callback();
                }, // needed
              )),
        )

    ],
  );
}
