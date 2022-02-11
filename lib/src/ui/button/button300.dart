import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

class Button300 extends StatelessWidget {
  final Function()? pressButtonDelete;
  final Function()? pressButton;
  final String text;
  final String text2;
  final bool onlyBorder;
  final Widget icon;
  final bool deleteIcon;
  final bool upIcon;
  final Function()? pressSetCurrent;

  Button300({required this.icon, this.pressButtonDelete, this.text = "", this.pressSetCurrent,
    this.onlyBorder = false, this.text2 = "", this.pressButton, this.deleteIcon = true, this.upIcon = false});

  @override
  Widget build(BuildContext context) {
    var color = aTheme.darkMode ? Colors.black : Colors.white;
    return Container(
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
          borderRadius: BorderRadius.circular(aTheme.radius),
        ),
        child: Stack(children: [

            InkWell(
              onTap: (){
                if (pressButton != null)
                  pressButton!();
              },
              child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    if (!upIcon)
                      icon,
                    if (upIcon)
                      InkWell(
                        onTap: (){
                          if (pressSetCurrent != null)
                            pressSetCurrent!();
                        },
                        child: Column(
                          children: [
                            Icon(Icons.arrow_upward, color: Colors.green,),
                            icon,
                        ],
                        )
                      ),
                    SizedBox(width: 15,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(text, style: aTheme.style14W800, textAlign: TextAlign.left,),
                        SizedBox(height: 5,),
                        Text(text2, style: aTheme.style12W600Grey, textAlign: TextAlign.left,),
                      ],
                    )),
                    if (deleteIcon)
                    InkWell(
                      onTap: (){
                        if (pressButtonDelete != null)
                          pressButtonDelete!();
                      },
                      child: Icon(Icons.delete, color: Colors.red,),
                    ),
                    SizedBox(width: 10,)
                ],
              ),
              SizedBox(height: 10,),
            ],
          )),

          // Positioned.fill(
          //   child: Material(
          //       color: Colors.transparent,
          //       clipBehavior: Clip.hardEdge,
          //       shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0) ),
          //       child: InkWell(
          //         splashCol  or: Colors.grey[400],
          //         onTap: (){
          //
          //         }, // needed
          //       )),
          // )
        ],)
    );
  }
}