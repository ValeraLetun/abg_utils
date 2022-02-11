import 'package:flutter/material.dart';

// 15.11.2021 - теперь можно устанавливать состояние извне - раньше не было

class CheckBox12 extends StatefulWidget {
  final Color color;
  final Function() getValue;
  final Function(bool) setValue;

  CheckBox12(this.getValue, this.setValue, {this.color = Colors.black});

  @override
  _CheckBox12State createState() => _CheckBox12State();
}

class _CheckBox12State extends State<CheckBox12> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.getValue();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 50).animate(_controller!)..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
    });
    if (_currentValue)
      _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  bool _currentValue = false;

  @override
  Widget build(BuildContext context) {
    bool need = widget.getValue();
    if (need != _currentValue){
      if (need)
        _controller!.forward();
      else
        _controller!.reverse();
      _currentValue = need;
    }
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          widget.setValue(!_currentValue);
        },
        child: Stack(
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

        ));
  }
}

class RoundedClipper1 extends CustomClipper<Path> {
  final double width;

  RoundedClipper1(this.width);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class RoundedClipper2 extends CustomClipper<Path> {
  final double width;

  RoundedClipper2(this.width);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
