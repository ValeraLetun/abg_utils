import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

class Card48 extends StatefulWidget {
  final String text;
  final String text2;
  final String text3;
  final bool shadow;
  final EdgeInsetsGeometry? padding;

  final Color iconColor;
  final Function() callback;

  Card48({
    this.text = "", this.text2 = "", this.text3 = "",
    this.shadow = false,
    this.padding, this.iconColor = Colors.black, required this.callback,
  });

  @override
  _Card48State createState() => _Card48State();
}

class _Card48State extends State<Card48>{

  @override
  Widget build(BuildContext context) {

    return InkWell(
        child: Container(
          padding: (widget.padding == null) ? EdgeInsets.only(left: 10, right: 10, bottom: 5) : widget.padding,
          decoration: BoxDecoration(
              color: aTheme.darkMode ? aTheme.blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(aTheme.radius),
              border: Border.all(color: aTheme.darkMode ? aTheme.blackColorTitleBkg : Colors.white),
              boxShadow: (widget.shadow) ? [
               BoxShadow(
                 color: Colors.grey.withAlpha(50),
                 spreadRadius: 2,
                 blurRadius: 2,
                 offset: Offset(2, 2), // changes position of shadow
               ),
             ] : null
          ),

          child: Row(
              children: <Widget>[

                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.text, style: aTheme.style14W800,),
                          SizedBox(height: 8,),
                          Text(widget.text3, style: aTheme.style14W400,)
                        ]
                  )),

                  Column(
                    children: [
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: widget.callback, icon: Icon(Icons.delete, color: aTheme.style14W800.color)
                      ),
                      Text(widget.text2, style: aTheme.style12W600Grey, overflow: TextOverflow.ellipsis,)
                    ],
                  )

            ],
          )),
      );
  }

}