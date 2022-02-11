import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

edit9(TextEditingController _controller, {TextStyle? style, TextStyle? hintStyle, String hint = "",
  TextInputType type = TextInputType.text, Function(String)? onchange, }){
  bool _obscure = false;
  return
      Container(
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10, ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(aTheme.radius),
          border: Border.all(
            color: aTheme.mainColor.withAlpha(100),
            width: 1.0,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: (String value) async {
            if (onchange != null)
              onchange(value)!;
          },
          cursorColor: Colors.black,
          style: style,
          cursorWidth: 1,
          keyboardType: type,
          obscureText: _obscure,
          textAlign: TextAlign.left,
          maxLines: 1,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: hint,
              hintStyle: hintStyle,
              contentPadding: EdgeInsets.only(bottom: 10)
          ),
        ),
      );
}
