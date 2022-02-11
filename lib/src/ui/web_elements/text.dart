import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../abg_utils.dart';

textElement(String text, String hint, TextEditingController _controller){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 20,),
      SelectableText(text, style: aTheme.style14W400),
      SizedBox(height: 5,),
      Edit41web(controller: _controller,
        hint: hint,
      )
    ],
  );
}

textElement2(String text, String hint, TextEditingController? _controller, Function(String) onChange){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SelectableText(text, style: aTheme.style14W400),
      SizedBox(width: 10,),
      Expanded(child: Edit41web(controller: _controller,
        onChange: onChange,
        hint: hint,
      ))
    ],
  );
}

documentBlock(String text1, TextEditingController _controller, String hint, Function() _redraw,
    String stringPreview, /// strings.get(25) /// "Preview",
    ){
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blue.withAlpha(10),
      borderRadius: BorderRadius.circular(aTheme.radius),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(text1, style: aTheme.style14W400,),
        SizedBox(height: 5,),
        Edit41web(controller: _controller,
          multiline: true,
          hint: hint,
          onChange: (String _){_redraw();},
        ),
        SizedBox(height: 5,),
        SelectableText(stringPreview, style: aTheme.style14W400,), /// "Preview",
        Html(
            data: _controller.text,
            style: {
              "body": Style(
                  backgroundColor: (aTheme.darkMode) ? Colors.black : Colors.transparent,
                  color: (aTheme.darkMode) ? Colors.white : Colors.black
              ),
            }
        )
      ],
    ),
  );
}
