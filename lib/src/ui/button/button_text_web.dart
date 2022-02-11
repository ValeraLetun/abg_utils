import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

class ButtonTextWeb extends StatefulWidget {
  final String text;
  final Function()? onTap;

  const ButtonTextWeb({Key? key, required this.text, this.onTap}) : super(key: key);

  @override
  _ButtonTextWebState createState() => _ButtonTextWebState();
}

class _ButtonTextWebState extends State<ButtonTextWeb> {

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  bool _isHovering = false;
  void _mouseEnter(bool hovering) {
    _isHovering = hovering;
    _redraw();
  }

  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;

    var _style = _isHovering ? aTheme.style14W800MainColor : aTheme.style14W800;
    if (windowWidth < 800)
      _style = _isHovering ? aTheme.style12W800MainColor : aTheme.style12W800;

    return MouseRegion(
        onEnter: (e) => _mouseEnter(true),
        onExit: (e) => _mouseEnter(false),
        child: InkWell(
            onTap: (){
              if (widget.onTap != null)
                widget.onTap!();
            },
            hoverColor: Colors.transparent,
            child: Text(widget.text, style: _style))
    );
  }

}


