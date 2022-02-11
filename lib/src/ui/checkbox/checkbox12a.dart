import 'package:flutter/material.dart';

import '../../../abg_utils.dart';

// ignore: must_be_immutable
class CheckBox12a extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color color;
  bool init;
  final Function(bool) callback;

  CheckBox12a(this.text, this.style, this.init, this.callback, {this.color = Colors.black});

  @override
  _CheckBox12aState createState() => _CheckBox12aState();
}

class _CheckBox12aState extends State<CheckBox12a> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 50).animate(_controller!)..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
    });
    if (widget.init)
      _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (widget.init)
            _controller!.reverse();
          else
            _controller!.forward();
          setState(() {
          });
          widget.callback(!widget.init);
        },
        child: Row(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 35,
                  child: ClipPath(
                    clipper: RoundedClipper2(animation!.value),
                    child: Image.asset(
                    "assets/elements/checkbox12_off.png",
                    fit: BoxFit.contain,
                  )),
                ),
                Container(
                  width: 50,
                  height: 35,
                  child: ClipPath(
                  clipper: RoundedClipper1(animation!.value),
                  child: Image.asset(
                    "assets/elements/checkbox12.png",
                    fit: BoxFit.contain,
                    color: widget.color,
                  ),
                )
                ),

              ],
            ),
            SizedBox(width: 10,),
            Text(widget.text, style: widget.style)
          ],
        ));
  }
}
