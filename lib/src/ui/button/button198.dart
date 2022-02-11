import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

class Button198 extends StatelessWidget {
  final Color color;
  final String text;
  final String text2;
  final TextStyle textStyle;
  final TextStyle? textStyle2;
  final bool onlyBorder;
  final Widget icon;
  final Function() getCheckValue;
  final Function(bool) callback;
  final Color rColor;

  Button198({required this.icon, this.text = "", this.color = Colors.grey, required this.textStyle,
    this.onlyBorder = false, this.text2 = "", this.textStyle2, required this.getCheckValue, required this.callback, this.rColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
        ),
        child: Stack(children: [

            Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    icon,
                    SizedBox(width: 15,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(text, style: textStyle, textAlign: TextAlign.left,),
                        SizedBox(height: 5,),
                        Text(text2, style: textStyle2, textAlign: TextAlign.left,),
                      ],
                    )),
                    CheckBox12(getCheckValue, callback, color: rColor),
                    SizedBox(width: 10,)
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ],)
    );
  }
}