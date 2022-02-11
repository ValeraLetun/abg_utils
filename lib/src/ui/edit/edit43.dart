import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

class Edit43 extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String hint;
  final TextStyle? editStyle;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Widget? prefixIcon;
  final Color color;
  Edit43({this.hint = "", required this.controller, this.type = TextInputType.text, this.color = Colors.grey,
    this.onChangeText, this.text = "", this.textStyle, this.editStyle, this.hintStyle, this.prefixIcon,});

  @override
  _Edit43State createState() => _Edit43State();
}

class _Edit43State extends State<Edit43> {

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    var _icon = Icons.visibility_off;
    if (!_obscure)
      _icon = Icons.visibility;

    var _sicon2 = IconButton(
      iconSize: 20,
      icon: Icon(
        _icon,
        color: widget.color,
      ),
      onPressed: () {
        setState(() {
          _obscure = !_obscure;
        });
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.text, style: widget.textStyle ?? aTheme.style12W400),
        Container(
          height: 40,
          child: TextField(
            controller: widget.controller,
            onChanged: (String value) async {},
            cursorColor: Colors.black,
            style: widget.editStyle ?? aTheme.style14W400,
            cursorWidth: 1,
            obscureText: _obscure,
            textAlign: TextAlign.left,
            maxLines: 1,
            decoration: InputDecoration(
              suffixIcon: _sicon2,
              prefixIcon: widget.prefixIcon,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color),
              ),
              hintText: widget.hint,
              hintStyle: widget.hintStyle ?? aTheme.style14W400Grey,
            ),
          ),
        )
      ],
    );
  }
}