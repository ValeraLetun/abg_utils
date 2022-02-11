import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

// provider v1

class BottomBar13 extends StatefulWidget {
  final Function(int) callback;
  final Color colorBackground;
  final Color colorSelect;
  final Color colorUnSelect;
  final List<String> icons;
  final List<String> text;
  final int initialSelect;
  final double radius;
  final Function getItem;
  final int shadow;
  final TextStyle textStyle;
  final TextStyle textStyleSelect;
  final double iconSize;
  final Function(int) getUnreadMessages;
  BottomBar13({this.colorBackground = Colors.white, required this.callback, this.colorSelect = Colors.black,
    this.colorUnSelect = Colors.black, required this.icons, this.initialSelect = 0, required this.getItem, this.radius = 10,
    this.shadow = 10, required this.text, this.textStyle = const TextStyle(), this.iconSize = 30, this.textStyleSelect = const TextStyle(),
    required this.getUnreadMessages
  });

  @override
  _BottomBar13State createState() => _BottomBar13State();
}

class _BottomBar13State extends State<BottomBar13> {

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
        color: widget.colorBackground,
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

  _button(double size, String icon, TextStyle _textStyle, Color color, int index){
    return Expanded(
        child: Stack(
          children: <Widget>[
            Center(child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UnconstrainedBox(
                      child: Container(
                          height: size,
                          width: size,
                          child: Image.asset(icon,
                            fit: BoxFit.contain, color: color,
                          )
                      )),
                  SizedBox(height: 5,),
                  FittedBox(fit: BoxFit.scaleDown, child: Text(widget.text[index], style: _textStyle, textAlign: TextAlign.center,)),
                ],
              ),
            )),
            if (widget.getUnreadMessages(index) != 0)
              Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                        padding: EdgeInsets.all(4),
                        child: Text(widget.getUnreadMessages(index).toString(), style: aTheme.style12W600White,)
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
                        setState(() {
                        });
                      }
                    }, // needed
                  )),
            )
          ],
        ));
  }
}


/* customer v1
class BottomBar13 extends StatefulWidget {
  final Function(int) callback;
  final Color colorBackground;
  final Color colorSelect;
  final Color colorUnSelect;
  final List<String> icons;
  final List<String> text;
  final int initialSelect;
  final double radius;
  final Function getItem;
  final int shadow;
  final TextStyle textStyle;
  final TextStyle textStyleSelect;
  final double iconSize;
  final Function(int) getUnreadMessages;
  BottomBar13({this.colorBackground = Colors.white, required this.callback, this.colorSelect = Colors.black,
    this.colorUnSelect = Colors.black, required this.icons, this.initialSelect = 0, required this.getItem, this.radius = 10,
    this.shadow = 10, required this.text, this.textStyle = const TextStyle(), this.iconSize = 30, this.textStyleSelect = const TextStyle(),
    required this.getUnreadMessages
  });

  @override
  _BottomBar13State createState() => _BottomBar13State();
}

class _BottomBar13State extends State<BottomBar13> {

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
        borderRadius: new BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
        color: widget.colorBackground,
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

  _button(double size, String icon, TextStyle _textStyle, Color color, int index){
    // getUnreadMessages
    return Expanded(
        child: Stack(
      children: <Widget>[
        Center(child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UnconstrainedBox(
                  child: Container(
                      height: size,
                      width: size,
                      child: Image.asset(icon,
                        fit: BoxFit.contain, color: color,
                      )
                  )),
              SizedBox(height: 5,),
              FittedBox(fit: BoxFit.scaleDown, child: Text(widget.text[index], style: _textStyle, textAlign: TextAlign.center,)),
            ],
          ),
        )),
        if (widget.getUnreadMessages(index) != 0)
          Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.topRight,
          child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
            child: Container(
              padding: EdgeInsets.all(4),
              child: Text(widget.getUnreadMessages(index).toString(), style: theme.style12W600White,)
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
                    setState(() {
                    });
                  }
                }, // needed
              )),
        )
      ],
    ));
  }
}

 */