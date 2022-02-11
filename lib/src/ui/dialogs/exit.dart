
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../abg_utils.dart';

Widget getBodyDialogExit(String textAreYouSure, String textNo, String textExit, Function() close){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(textAreYouSure, /// Are you sure you want to exit?
          textAlign: TextAlign.center, style: aTheme.style14W800),
      SizedBox(height: 40,),
      Row(children: [
        Expanded(child: button2(textNo, aTheme.mainColor, close)), /// "No",
        SizedBox(width: 10,),
        Expanded(child: button2(textExit, aTheme.mainColor, /// "Exit",
              (){
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },))
      ],),
    ],
  );
}