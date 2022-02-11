import 'package:flutter/material.dart';

card51(int stars, Color starsColor, double _size){
  return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
      if (stars >= 1)
        Icon(Icons.star, color: starsColor, size: _size,),
      if (stars < 1)
        Icon(Icons.star_border, color: starsColor, size: _size,),
      if (stars >= 2)
        Icon(Icons.star, color: starsColor, size: _size,),
      if (stars < 2)
        Icon(Icons.star_border, color: starsColor, size: _size,),
      if (stars >= 3)
        Icon(Icons.star, color: starsColor, size: _size,),
      if (stars < 3)
        Icon(Icons.star_border, color: starsColor, size: _size,),
      if (stars >= 4)
        Icon(Icons.star, color: starsColor, size: _size,),
      if (stars < 4)
        Icon(Icons.star_border, color: starsColor, size: _size,),
      if (stars >= 5)
        Icon(Icons.star, color: starsColor, size: _size,),
      if (stars < 5)
        Icon(Icons.star_border, color: starsColor, size: _size,),
  ]);
}

