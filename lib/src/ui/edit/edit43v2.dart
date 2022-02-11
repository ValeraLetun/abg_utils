import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

class Edit43V2 extends StatefulWidget {
  final String text;
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Widget? prefixIcon;
  final bool needDecoration;
  final Decoration? decor;
  Edit43V2({this.hint = "", required this.controller, this.type = TextInputType.text,
    this.prefixIcon, this.decor,
    this.onChangeText, this.text = "", this.needDecoration = true});

  @override
  _Edit43V2State createState() => _Edit43V2State();
}

class _Edit43V2State extends State<Edit43V2> {

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
        color: Colors.grey,
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
        // Text(widget.text, style: widget.textStyle),
        Container(
          height: 40,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: widget.needDecoration ? widget.decor : null,
          child: TextField(
            controller: widget.controller,
            onChanged: (String value) async {},
            cursorColor: Colors.black,
            style: aTheme.style14W400,
            cursorWidth: 1,
            obscureText: _obscure,
            textAlign: TextAlign.left,
            maxLines: 1,
            decoration: InputDecoration(
              suffixIcon: _sicon2,
              prefixIcon: widget.prefixIcon,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: widget.hint,
              hintStyle: aTheme.style14W400Grey,
            ),
          ),
        )
      ],
    );
  }
}

class Edit43a extends StatefulWidget {
  final String text;
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Widget? prefixIcon;
  final bool needDecoration;
  final Decoration? decor;

  Edit43a({this.hint = "", required this.controller, this.type = TextInputType.text,
    this.prefixIcon, this.decor,
    this.onChangeText, this.text = "",
    this.needDecoration = false});

  @override
  _Edit43aState createState() => _Edit43aState();
}

class _Edit43aState extends State<Edit43a> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(widget.text, style: widget.textStyle),
        Container(
          height: 40,
          decoration: widget.needDecoration ? widget.decor : null,
          child: TextField(
            controller: widget.controller,
            onChanged: (String value) async {},
            cursorColor: Colors.black,
            style: aTheme.style14W400,
            cursorWidth: 1,
            keyboardType: widget.type,
            textAlign: TextAlign.left,
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: widget.hint,
              hintStyle: aTheme.style14W400Grey,
            ),
          ),
        )
      ],
    );
  }
}