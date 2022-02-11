import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

button202Blog(BlogData item,
    Color color, double width, double height,
    Function() _callback){
  return Stack(
    children: <Widget>[

      Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(aTheme.radius),
          ),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(aTheme.radius),
                      bottomLeft: Radius.circular(aTheme.radius)),
                child: Container(
                  width: height,
                    height: height,
                    child: showImage(item.serverPath, width: height, fit: BoxFit.cover),
              )),

              Expanded(
                child: Container(
                height: height,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getTextByLocale(item.name, locale), style: aTheme.style14W800, textAlign: TextAlign.start,),
                    SizedBox(height: height*0.05,),
                    Text(timeago.format(item.time, locale: appSettings.currentServiceAppLanguage),
                        overflow: TextOverflow.ellipsis, style: aTheme.style12W600Grey),
                    SizedBox(height: height*0.1,),
                    Expanded(child: Text(getTextByLocale(item.desc, locale), style: aTheme.style12W400,
                      textAlign: TextAlign.start, )),
                  ],
                ),
              )),


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
