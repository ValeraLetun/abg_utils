import 'package:flutter/material.dart';

class ClipPathClass23 extends CustomClipper<Path> {
  double needSize = 0;
  ClipPathClass23(this.needSize);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(0, size.height-needSize, needSize, size.height-needSize);
    path.lineTo(size.width-needSize, size.height-needSize);
    path.quadraticBezierTo(size.width, size.height-needSize, size.width, size.height);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

