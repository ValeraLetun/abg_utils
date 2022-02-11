import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

class CardEarning extends StatefulWidget {
  final Color borderColor;
  final Color backgroundColor;
  final String name;
  final String price;
  final String customerName;
  final String time;
  final String id;

  final bool shadow;
  final EdgeInsetsGeometry? padding;

  final String stringBookingId; // strings.get(44) "Booking ID",
  final String stringCustomerName; // strings.get(218) /// "Customer name",

  CardEarning({this.borderColor = Colors.white,
    required this.backgroundColor,
    this.name = "", this.price = "", this.customerName = "", this.time = "",
    this.shadow = false, this.padding, this.id = "",
    required this.stringBookingId, required this.stringCustomerName
  });

  @override
  _CardEarningState createState() => _CardEarningState();
}

class _CardEarningState extends State<CardEarning>{

  @override
  Widget build(BuildContext context) {

    return InkWell(
      child: Container(
        padding: (widget.padding == null) ? EdgeInsets.all(10) : widget.padding,
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(aTheme.radius),
            border: Border.all(color: widget.borderColor),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: <Widget>[
                Expanded(child: Text(widget.name, style: aTheme.style14W800, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),
                SizedBox(width: 10,),
                Text(widget.time, style: aTheme.style12W600Grey, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,)
              ],
            ),

            SizedBox(height: 5,),
            Row(
              children: [
                Text(widget.stringBookingId + ":", style: aTheme.style14W400), /// "Booking ID",
                SizedBox(width: 10,),
                Expanded(child: Text(widget.id, style: aTheme.style14W400Grey, overflow: TextOverflow.ellipsis,)),
              ],
            ),

            SizedBox(height: 5,),
            Row(
              children: <Widget>[
                Text(widget.stringCustomerName + ":", style: aTheme.style14W400), /// "Customer name",
                SizedBox(width: 10,),
                Expanded(child: Text(widget.customerName, style: aTheme.style12W600Grey, overflow: TextOverflow.ellipsis)),
                Text(widget.price, style: aTheme.style16W800Green, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,)
              ],
            ),

          ],),

      ),
    );
  }

}


class CardEarningTotal extends StatefulWidget {
  final Color borderColor;
  final Color backgroundColor;
  final bool shadow;
  final EarningData data;
  final EdgeInsetsGeometry? padding;
  final String stringToAdmin; /// strings.get(219) /// "To Admin",
  final String stringToProvider; /// strings.get(220) /// "To Provider",
  final String stringTax; /// strings.get(221) /// "TAX/VAT",
  final String stringTotal; /// strings.get(56) /// "Total",

  CardEarningTotal({this.borderColor = Colors.white,
    required this.backgroundColor, required this.data, this.shadow = false, this.padding,
    required this.stringToAdmin, required this.stringToProvider, required this.stringTax,
    required this.stringTotal
  });

  @override
  _CardEarningTotalState createState() => _CardEarningTotalState();
}

class _CardEarningTotalState extends State<CardEarningTotal>{

  @override
  Widget build(BuildContext context) {

    return InkWell(
      child: Container(
        padding: (widget.padding == null) ? EdgeInsets.all(10) : widget.padding,
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(aTheme.radius),
            border: Border.all(color: widget.borderColor),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: <Widget>[
                Text(widget.stringToAdmin + ":", style: aTheme.style14W400), /// "To Admin",
                SizedBox(width: 10,),
                Expanded(child: Text(getPriceString(widget.data.admin),
                  style: aTheme.style14W400, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,)),
              ],
            ),

            SizedBox(height: 10,),

            Row(
              children: <Widget>[
                Text(widget.stringToProvider + ":", style: aTheme.style14W400), /// "To Provider",
                SizedBox(width: 10,),
                Expanded(child: Text(getPriceString(widget.data.provider),
                  style: aTheme.style14W400, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,)),
              ],
            ),

            SizedBox(height: 10,),

            Row(
              children: <Widget>[
                Text(widget.stringTax + ":", style: aTheme.style14W400), /// "TAX/VAT",
                SizedBox(width: 10,),
                Expanded(child: Text(getPriceString(widget.data.tax),
                  style: aTheme.style14W400, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,)),
              ],
            ),

            SizedBox(height: 10,),

            Row(
              children: <Widget>[
                Text(widget.stringTotal + ":", style: aTheme.style13W800), /// "Total",
                SizedBox(width: 10,),
                Expanded(child: Text(getPriceString(widget.data.total),
                  style: aTheme.style14W400, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,)),
              ],
            ),

          ],),

      ),
    );
  }
}

payoutCard(Color backgroundColor, DateTime _time, double payout){
  return InkWell(
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(aTheme.radius),
      ),

      child:
      Row(
        children: <Widget>[
          Expanded(child: Text("${appSettings.getDateTimeString(_time)}:", style: aTheme.style14W400)),
          SizedBox(width: 10,),
          Text("-" + getPriceString(payout),
            style: aTheme.style14W400, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
        ],
      ),

    ),
  );
}
