import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

button126(String text, String icon, double width, double height, Function _callback, {bool enable = true}){
  List<Color> gradient = [aTheme.mainColor.withAlpha(20), aTheme.mainColor];
  return Stack(
    children: <Widget>[

      Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(10),
            borderRadius: BorderRadius.circular(aTheme.radius),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(aTheme.radius), topRight: Radius.circular(aTheme.radius)),
                      gradient: (enable) ?  LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: gradient,
                      ) : LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.5)],
                      )
                  ),
                ),
                Container(
                  width: width,
                    height: height,
                    padding: EdgeInsets.all(10),
                    child: Image.asset(icon,
                      fit: BoxFit.contain,
                    )),
            ],
          )
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(text, style: aTheme.style10W400, textAlign: TextAlign.center, )
              )

            ],
          )
      ),
      if (enable)
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
