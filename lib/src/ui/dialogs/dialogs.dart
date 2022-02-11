import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

//
// классически квадратик посередине
//
openDialogYesNo(Function(String) callback,
    String stringText, String text1, String text2){
  EasyDialog(
      colorBackground: aTheme.darkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Text(stringText),
          SizedBox(height: 40,),
          Row(
            children: [
              Flexible(child: button2(text1,
                  aTheme.mainColor,
                      (){
                    Navigator.pop(buildContext); // close dialog
                    callback("text1");
                  })),
              SizedBox(width: 10,),
              Flexible(child: button2(text2,
                  aTheme.mainColor, (){
                    Navigator.pop(buildContext); // close dialog
                    callback("text2");
                  })),
            ],
          )
        ],
      )
  ).show(buildContext);
}

dialogYesNoBody(Function(String) callback,
    String stringText, String text1, String text2){
  return Column(
        children: [
          Text(stringText),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              button2b(text1,
                      (){
                    closeDialog();
                    callback("text1");
                  }),
              SizedBox(width: 10,),
              button2b(text2,
                  (){
                    closeDialog();
                    callback("text2");
                  }),
            ],
          )
        ],
      );
}

