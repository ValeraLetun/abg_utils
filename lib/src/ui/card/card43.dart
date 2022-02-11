import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

class Card43 extends StatelessWidget {
  final String image;
  final String text1;
  final String text2;
  final String text3;
  final String date;
  final String dateCreating;
  final String bookingId;
  final bool shadow;
  final Color bkgColor;
  final double imageRadius;
  final double padding;
  final Widget icon;
  final String bookingAt;

  final String stringTimeCreation; /// strings.get(231) /// Time creation
  final String stringBookingId; /// strings.get(232) /// "Booking ID",
  final String stringBookingAt; /// Booking At

  const Card43({Key? key, required this.image, required this.text1, required this.text2,
    required this.text3, required this.date, required this.icon,
    this.shadow = false, this.bkgColor = Colors.white, this.imageRadius = 50,
    required this.dateCreating, required this.bookingId,
    this.padding = 5, required this.stringTimeCreation, required this.stringBookingId,
    this.stringBookingAt = "", this.bookingAt = "", }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: bkgColor,
          borderRadius: BorderRadius.circular(aTheme.radius),
          boxShadow: (shadow) ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ] : null,
        ),
        child: Container(
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
                      Text(text1, style: aTheme.style14W800,),
                      SizedBox(height: 5,),
                      if (text2.isNotEmpty)
                      Text(text2, style: aTheme.style12W600Grey,),
                      if (text2.isNotEmpty)
                      SizedBox(height: 5,),
                      Row(children: [
                        Text(stringTimeCreation, style: aTheme.style12W800), /// Time creation
                        SizedBox(width: 10,),
                        Expanded(child: Text(dateCreating, style: aTheme.style12W400, overflow: TextOverflow.ellipsis))
                      ],),
                      SizedBox(height: 5,),
                      if (bookingAt.isNotEmpty)
                      Row(children: [
                        Text(stringBookingAt, style: aTheme.style12W800), /// Booking At
                        SizedBox(width: 10,),
                        Expanded(child: Text(bookingAt, style: aTheme.style12W400, overflow: TextOverflow.ellipsis))
                      ],),
                      if (bookingAt.isNotEmpty)
                      SizedBox(height: 5,),
                      Row(children: [
                        Text(stringBookingId, style: aTheme.style12W800), /// "Booking ID",
                        SizedBox(width: 10,),
                        Expanded(child: Text(bookingId, style: aTheme.style12W400, overflow: TextOverflow.ellipsis,)),
                      ],),
                      SizedBox(height: 15,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          icon,
                          SizedBox(width: 5,),
                          Text(text3, style: aTheme.style12W400,),
                          SizedBox(width: 5,),
                          Container(
                            height: 15,
                              alignment: Alignment.center,
                              child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          )),
                          SizedBox(width: 5,),
                          Flexible(child: FittedBox(child: Text(date, style: aTheme.style13W800Blue))),
                        ],
                      )
                    ],)),
              SizedBox(width: 20,),
              Container(
                height: 60,
                width: 60,
                //padding: EdgeInsets.only(left: 10, right: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(imageRadius),
                    child: showImage(image, fit: BoxFit.cover)
                    // image.isNotEmpty ? CachedNetworkImage(
                    //             imageUrl: image,
                    //             imageBuilder: (context, imageProvider) => Container(
                    //               width: double.maxFinite,
                    //               alignment: Alignment.bottomRight,
                    //               child: Container(
                    //                 //width: height,
                    //                 decoration: BoxDecoration(
                    //                     image: DecorationImage(
                    //                       image: imageProvider,
                    //                       fit: BoxFit.cover,
                    //                     )),
                    //               ),
                    //             )
                    //         ) : Container(),
                    ),
              ),
              SizedBox(width: 10,),
            ],
          ),

        ));
  }
}
