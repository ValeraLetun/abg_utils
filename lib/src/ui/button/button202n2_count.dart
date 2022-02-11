import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

button202n2Count(double width,
    String image,
    String stringSeeMore, /// See more
    String text2,
    Function() _callback
    ){

  bool available = false;

  return Stack(
    children: <Widget>[

      Container(
          margin: EdgeInsets.only(bottom: 5),
          width: width,
          decoration: BoxDecoration(
            color: (aTheme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(aTheme.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            children: [

              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(aTheme.radius)),
                  child: Container(
                      width: width,
                      height: width+60,
                      child: Stack(
                        children: [
                          showImage(image, fit: BoxFit.cover),
                          if (!available)
                            Container(
                                color: Colors.black.withAlpha(100),
                                child: Center(child:
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(stringSeeMore, style: aTheme.style16W800White,
                                      textAlign: TextAlign.center,),
                                    Text(text2, style: aTheme.style16W800White,
                                      textAlign: TextAlign.center,)
                                  ],
                                ))
                            )
                        ],
                      )
                  ),
                ),

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
      ),

    ],
  );
}
