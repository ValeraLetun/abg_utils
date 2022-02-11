import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

button98a(Color color, IconData _icon, String text, Function() _callback, {bool enable = true, Color iconColor = Colors.white,
      double size = 50}){
  return Container(
      width: size+10,
      height: size+10,
      child: Stack(
        children: [
          Center(child: button98(color, _icon, _callback, size: size, enable: enable, iconColor: iconColor)),
          if (text.isNotEmpty)
          Container(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Container(
                    padding: EdgeInsets.all(4),
                    child: Text(text, style: aTheme.style12W600White,)
                ),
              )),
        ],
      )
  );
}
