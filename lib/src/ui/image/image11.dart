import 'package:flutter/material.dart';

image11(Widget item, double radius){
    return Container(
        child: ClipPath(
            clipper: ClipImageClass(radius),
            child: item
    ));
}

class ClipImageClass extends CustomClipper<Path> {
  final double radius;
  ClipImageClass(this.radius);
  @override
  Path getClip(Size size) {
    print(size.toString());
    var path = Path();
    path.moveTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);
    path.lineTo(0, size.height-radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);
    path.lineTo(size.width-radius, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height-radius);
    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width, 0, size.width-radius, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
