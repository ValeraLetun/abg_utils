import 'package:flutter/material.dart';
import '../../abg_utils.dart';

oneShimmerItem(double _width, double _height, Animation<double> _animation){
  return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: _width,
          height: _height,
          decoration: customBoxDecoration(
              animation: _animation,
              isRectBox: true,
              isPurplishMode: false,
              isDarkMode: aTheme.darkMode,
              hasCustomColors: false,
              colors: defaultColors),
        );
      }
  );
}

const List<Color> defaultColors = [Color.fromRGBO(0, 0, 0, 0.1), Color(0x44CCCCCC), Color.fromRGBO(0, 0, 0, 0.1)];

Decoration customBoxDecoration({
  required Animation animation,
  bool isRectBox = false,
  bool isDarkMode = false,
  bool isPurplishMode = false,
  bool hasCustomColors = false,
  List<Color> colors = defaultColors,
  AlignmentGeometry beginAlign = Alignment.topLeft,
  AlignmentGeometry endAlign = Alignment.bottomRight,
}) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(aTheme.radius),
      shape: isRectBox ? BoxShape.rectangle : BoxShape.circle,
      gradient: LinearGradient(
          begin: beginAlign,
          end: endAlign,
          colors: hasCustomColors
              ? colors.map((color) {
            return color;
          }).toList()
              : [
            isPurplishMode
                ? Color(0xFF8D71A9)
                : isDarkMode
                ? Color(0xFF1D1D1D)
                : Color.fromRGBO(0, 0, 0, 0.1),
            isPurplishMode
                ? Color(0xFF36265A)
                : isDarkMode
                ? Color(0XFF3C4042)
                : Color(0x44CCCCCC),
            isPurplishMode
                ? Color(0xFF8D71A9)
                : isDarkMode
                ? Color(0xFF1D1D1D)
                : Color.fromRGBO(0, 0, 0, 0.1),
          ],
          stops: [animation.value - 2, animation.value, animation.value + 1]));
}
