import 'package:flutter/material.dart';

class Button186 extends StatelessWidget {
  final String text1;
  final TextStyle style1;
  final String text2;
  final TextStyle style2;
  final Color color;
  final String icon;
  final double radius;
  final Function callback;
  final bool enable;
  final double padding;
  final double iconSize;

  const Button186({Key? key, required this.text1, required this.style1, required this.text2, required this.style2,
    this.radius = 10, this.padding = 10, this.color = Colors.white, required this.icon,
    required this.callback, this.enable = true, this.iconSize = 40, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: (enable) ? color : Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: padding,),
                      Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(text1, style: style1,
                                textAlign: TextAlign.center,)),
                              Text(text2, style: style2,
                                textAlign: TextAlign.center,),
                            ],
                          )
                      ),
                      SizedBox(width: padding,),
                      Container(
                          padding: EdgeInsets.all(padding),
                          child: Container(
                              height: iconSize,
                              width: iconSize,
                              child: Image.asset(icon,
                                fit: BoxFit.contain,
                              ))
                      ),
                      SizedBox(width: padding,),
                    ],
                  ),
                  if (enable)
                    Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius)),
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(0.2),
                            onTap: () {
                              callback();
                            }, // needed
                          )),
                    )

                ])
        ),

      ],
    );
  }
}
