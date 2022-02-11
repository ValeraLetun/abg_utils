import 'package:flutter/material.dart';

edit22(TextEditingController _controller, String _hint, double radius, {TextStyle? style, Function(String)? onChange}){
  bool _obscure = false;
  var color = Colors.black.withAlpha(100);
  if (style != null){
    if (style.color != null)
      color = style.color!.withAlpha(100);
  }
  return
    Container(
      padding: EdgeInsets.only(left: 10, right: 10, ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: color,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (String value) async {
          if (onChange != null)
            onChange(value);
        },
        cursorColor: style != null ? style.color : Colors.black,
        style: style,
        cursorWidth: 1,
        obscureText: _obscure,
        textAlign: TextAlign.left,
        maxLines: 5,
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
          hintText: _hint,
          hintStyle: TextStyle(fontSize: 14),
        ),
      ),
    );
}