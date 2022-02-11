import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

Widget button157(String text, Color color, String icon, Function _callback, double width, double height,
    {TextDirection direction = TextDirection.ltr, double? radius}){
  return Stack(
    children: <Widget>[

      Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(top: 20),
          child: Stack(
              children: <Widget>[

                Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(radius ?? aTheme.radius),
                    ),
                    // padding: EdgeInsets.only(right: 10, left: 10),
              ),

              ])
      ),

        Positioned.fill(
          child: Container(
            width: double.maxFinite,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              // alignment: strings.direction == TextDirection.ltr ? Alignment.centerRight : Alignment.centerLeft,
                child: Stack(
                  children: [
                    Container(
                      alignment: direction == TextDirection.ltr ? Alignment.bottomRight : Alignment.bottomLeft,
                      child: showImage(icon, width: height,
                          alignment: direction == TextDirection.ltr ? Alignment.bottomRight : Alignment.bottomLeft )
                      // icon.isNotEmpty ? CachedNetworkImage(
                      //     imageUrl: icon,
                      //     imageBuilder: (context, imageProvider) => Container(
                      //       width: double.maxFinite,
                      //       alignment: direction == TextDirection.ltr ? Alignment.bottomRight : Alignment.bottomLeft,
                      //       child: Container(
                      //         width: height,
                      //         decoration: BoxDecoration(
                      //             image: DecorationImage(
                      //               image: imageProvider,
                      //               fit: BoxFit.contain,
                      //             )),
                      //       ),
                      //     )
                      // ) : Container(),
                    ),

                    Container(
                      margin: direction == TextDirection.ltr ? EdgeInsets.only(right: width*0.4, top: 20)
                          : EdgeInsets.only(left: width*0.4, top: 20),
                      alignment: direction == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight,
                      child: Text(text, style: aTheme.style12W800W, maxLines: 2, overflow: TextOverflow.ellipsis,
                        textAlign: direction == TextDirection.ltr ? TextAlign.left : TextAlign.right,),
                    )

                  ],
                )
        )),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius ?? aTheme.radius) ),
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
