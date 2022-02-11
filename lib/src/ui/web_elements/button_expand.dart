import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

buttonExpand(String text, bool _expandDescription, Function() onTap, {Color? color}){
  return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color ?? Colors.green.withAlpha(100),
          borderRadius: BorderRadius.circular(aTheme.radius),
        ),
        child: Row(
          children: [
            Expanded(child: Text(text, style: aTheme.style12W600White,)),
            RotatedBox(
              quarterTurns: _expandDescription ? 1 : 3,
              child:Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
            )
          ],
        ),
      ));
}

