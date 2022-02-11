import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

class Card49 extends StatefulWidget {
  final String text;
  final String text2;
  final String text3;

  final int initValue;
  final String image;
  final double imageRadius;
  final bool shadow;
  final Color starsColor;
  final Function(int stars) callback;

  Card49({
    required this.callback,
    this.imageRadius = 0,
    this.initValue = 5,
    this.starsColor = Colors.orange,
    this.image = "",
    this.text = "",
    this.text2 = "",
    this.text3 = "",
    this.shadow = false,

  });

  @override
  _Card49State createState() => _Card49State();
}

class _Card49State extends State<Card49>{

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: (aTheme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(aTheme.radius),
            border: Border.all(color: Colors.transparent),
            boxShadow: (widget.shadow) ? [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 2), // changes position of shadow
              ),
            ] : null
        ),

        child: Column(
          children: [

            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.text, style: aTheme.style16W800,),
                          SizedBox(height: 5,),
                          Text(widget.text3, style: aTheme.style14W400,),
                          SizedBox(height: 15,),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     widget.image,
                          //     SizedBox(width: 5,),
                          //     Text(widget.text3, style: widget.style3,),
                          //     SizedBox(width: 5,),
                          //     Container(
                          //         height: 15,
                          //         alignment: Alignment.center,
                          //         child: Container(
                          //           width: 5,
                          //           height: 5,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey,
                          //             shape: BoxShape.circle,
                          //           ),
                          //         )),
                          //     SizedBox(width: 5,),
                          //     Flexible(child: FittedBox(child: Text(text4, style: style4,))),
                          //   ],
                          // )
                        ],)),
                  SizedBox(width: 20,),
                  Container(
                    height: 60,
                    width: 60,
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.imageRadius),
                      child: showImage(widget.image, fit: BoxFit.contain, alignment: Alignment.bottomRight)
                      // widget.image.isNotEmpty ? CachedNetworkImage(
                      //     imageUrl: widget.image,
                      //     imageBuilder: (context, imageProvider) => Container(
                      //       width: double.maxFinite,
                      //       alignment: Alignment.bottomRight,
                      //       child: Container(
                      //         //width: height,
                      //         decoration: BoxDecoration(
                      //             image: DecorationImage(
                      //               image: imageProvider,
                      //               fit: BoxFit.cover,
                      //             )),
                      //       ),
                      //     )
                      // ) : Container(),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),

            ),
            // Expanded(
            //     child: ClipRRect(
            //       borderRadius: new BorderRadius.only(
            //           topLeft: Radius.circular(widget.radius),
            //           topRight: Radius.circular(widget.radius)),
            //       child: Container(
            //         width: double.maxFinite,
            //         child: Image.asset(widget.image,
            //             fit: BoxFit.cover,
            //           ),
            //     ))),

            SizedBox(height: 10,),
            //Text(widget.text, style: widget.style, textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Text(widget.text2, style: aTheme.style14W400, textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Slider3(callback: widget.callback,
                initStars: widget.initValue,
                iconStarsColor: widget.starsColor,
                iconSize: 40),
            SizedBox(height: 20,),
          ],
        )
    );
  }
}

