import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

/*
  для обводки и тени

  decor = BoxDecoration(
      color: (darkMode) ? blackColorTitleBkg: Colors.white,
      borderRadius: new BorderRadius.circular(radius),
      border: Border.all(color: Colors.grey.withAlpha(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(1, 1),
        ),
      ],
    );
 */

class Edit26 extends StatefulWidget {
  final String hint;
  final GlobalKey? keyForEdit;
  final Function(String)? onChangeText;
  final Function()? onSuffixIconPress;
  final Function()? onTap;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final Color borderColor;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextStyle style;
  final TextStyle? hintStyle;
  final bool useAlpha;
  final FocusNode? focusNode;
  final Decoration? decor;
  final bool enabled;

  Edit26({this.hint = "", required this.controller, this.type = TextInputType.text, this.color = Colors.black,
    this.onChangeText, this.icon, this.borderColor = Colors.transparent, this.style = const TextStyle(),
    this.useAlpha = true, this.onTap, this.suffixIcon, this.onSuffixIconPress, this.focusNode, this.keyForEdit, this.decor,
    this.hintStyle, this.enabled = true});

  @override
  _Edit26State createState() => _Edit26State();
}

class _Edit26State extends State<Edit26> {

  @override
  Widget build(BuildContext context) {

    return Container(
        // height: 40,
        padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        decoration: widget.decor,
      child: TextField(
            //scrollPadding: EdgeInsets.all(0),
            key: widget.keyForEdit,
            focusNode: widget.focusNode,
            obscureText: false,
            enabled: widget.enabled,
            cursorColor: widget.style.color,
            keyboardType: widget.type,
            controller: widget.controller,
            onTap: () async {
              if (widget.onTap != null)
                widget.onTap!();
            },
            onChanged: (String value) async {
              if (widget.onChangeText != null)
                widget.onChangeText!(value);
            },
            textAlignVertical: TextAlignVertical.center,
            style: widget.style,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: widget.icon != null ? Icon(
                widget.icon,
                color: aTheme.mainColor,
              ) : null,
              suffixIcon: widget.suffixIcon != null ? IconButton(icon: Icon(
                widget.suffixIcon,
                color: aTheme.mainColor,
              ), onPressed: () {
                if (widget.onSuffixIconPress != null)
                  widget.onSuffixIconPress!();
              },) : null,
              hintText: widget.hint,
              hintStyle: widget.hintStyle ?? aTheme.style12W600Grey,
            ),
          ),
    );
  }
}