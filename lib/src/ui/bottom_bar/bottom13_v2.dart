import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

class BottomBar13V2 extends StatefulWidget {
  final Function(int) callback;
  final Color mainColorGray;
  final Color colorSelect;
  final Color colorUnSelect;
  final List<IconData> icons;
  final List<String> text;
  final double radius;
  final Function getItem;
  final int shadow;
  final TextStyle textStyle;
  final TextStyle textStyleSelect;
  final double iconSize;
  final String Function(int) getUnreadMessages;
  BottomBar13V2({this.mainColorGray = Colors.white, required this.callback, this.colorSelect = Colors.black,
    this.colorUnSelect = Colors.black, required this.icons, required this.getItem, this.radius = 10,
    this.shadow = 10, required this.text, this.textStyle = const TextStyle(), this.iconSize = 30, this.textStyleSelect = const TextStyle(),
    required this.getUnreadMessages
  });

  @override
  _BottomBar13V2State createState() => _BottomBar13V2State();
}

class _BottomBar13V2State extends State<BottomBar13V2> {

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;

    List<Widget> list = [];
    var index = 0;
    for (var icon in widget.icons) {
      var size = widget.iconSize;
      Color color = widget.colorSelect;
      TextStyle _textStyle = widget.textStyleSelect;
      if (index != widget.getItem()) {
        color = widget.colorUnSelect;
        size = size * 0.8;
        _textStyle = widget.textStyle;
      }
      list.add(_button(size, icon, _textStyle, color, index, ));
     index++;
    }
    return Container(
      height: 60,
      width: windowWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
        color: widget.mainColorGray,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(widget.shadow),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: list,
      ),
    );
  }

  _button(double size, IconData icon, TextStyle _textStyle, Color color, int index){
    return Expanded(
        child: Stack(
      children: <Widget>[
        Center(child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: size, color: color,),
              SizedBox(height: 5,),
              FittedBox(fit: BoxFit.scaleDown, child: Text(widget.text[index], style: _textStyle, textAlign: TextAlign.center,)),
            ],
          ),
        )),
        if (widget.getUnreadMessages(index).isNotEmpty)
          Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.topRight,
          child: Container(
          decoration: BoxDecoration(
            color: widget.getUnreadMessages(index) == "on" ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
            child: Container(
              padding: EdgeInsets.all(4),
              child: Text(widget.getUnreadMessages(index), style: aTheme.style12W600White,)
            ),
        )),
        Container(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (widget.getItem() != index) {
                    widget.callback(index);
                    setState(() {});
                  }
                }, // needed
              )),
        )
      ],
    ));
  }
}
