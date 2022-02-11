import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

numberElement2Percentage(String text, String hint, TextEditingController _controller, Function(String) onChange){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(text, style: aTheme.style14W400, overflow: TextOverflow.ellipsis,),
      SizedBox(width: 10,),
      Container(
          width: 100,
          child: Edit41web(controller: _controller,
            priceOnly100: true,
            onChange: onChange,
            hint: hint,
          )),
      SizedBox(width: 10,),
      Text("%", style: aTheme.style14W400),
    ],
  );
}

numberElement2Price(String text, String hint, String hint2, TextEditingController _controller, Function(String) onChange, int numberOfDigits){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SelectableText(text, style: aTheme.style14W400),
      SizedBox(width: 5,),
      Container(
          width: 100,
          child: Edit41web(controller: _controller,
            price: true,
            numberOfDigits: numberOfDigits,
            onChange: onChange,
            hint: hint,
          )),
      SizedBox(width: 5,),
      Text(hint2, style: aTheme.style14W400),
    ],
  );
}

numberElement2(String text, String hint, String hint2, TextEditingController _controller, Function(String) onChange){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SelectableText(text, style: aTheme.style14W400),
      SizedBox(width: 5,),
      Container(
          width: 100,
          child: Edit41Number(controller: _controller,
            radius: aTheme.radius,
            style: aTheme.style14W400,
            onChange: onChange,
            backgroundColor: (aTheme.darkMode) ? aTheme.blackColorTitleBkg : Colors.white,
            hint: hint,
            color: Colors.grey, )),
      SizedBox(width: 5,),
      Text(hint2, style: aTheme.style14W400),
    ],
  );
}
