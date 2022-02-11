import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

edit42(String text, TextEditingController _controller,
    String _hint, {TextInputType type = TextInputType.text,
      TextStyle? style, TextStyle? hintStyle, bool? enabled, Color color = Colors.transparent,
      Function(String)? onchange
    }){
  bool _obscure = false;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text, style: aTheme.style12W400),
      Container(
        color: color,
        height: 40,
        child: TextField(
          controller: _controller,
          onChanged: (String value) async {
            if (onchange != null)
              onchange(value);
          },
          cursorColor: Colors.black,
          style: style ?? aTheme.style14W400,
          enabled: enabled,
          cursorWidth: 1,
          keyboardType: type,
          obscureText: _obscure,
          textAlign: TextAlign.left,
          maxLines: 1,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: _hint,
              hintStyle: hintStyle ?? aTheme.style14W400Grey,
          ),
        ),
      )
    ],
  );
}

