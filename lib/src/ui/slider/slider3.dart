import 'package:flutter/material.dart';

class Slider3 extends StatefulWidget {
  final Function(int) callback;
  final int initStars;
  final Color iconStarsColor;
  final double iconSize;

  Slider3({required this.callback, required this.iconStarsColor, required this.iconSize, required this.initStars});

  @override
  _Slider3State createState() => _Slider3State();
}

class _Slider3State extends State<Slider3>{

  final ValueNotifier<double> _rowWidth = ValueNotifier<double>(-1);
  final GlobalKey _rowKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    int _currentSelect = widget.initStars;
    Future.delayed(Duration.zero, () =>
    {
      if (_rowKey.currentContext != null){
        _rowWidth.value = _rowKey.currentContext!.size!.width,
      }
    });
    return Container(
        alignment: Alignment.center,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragDown: (v){
            _onMove(v.localPosition.dx);
          },
          onHorizontalDragStart: (v){
            _onMove(v.localPosition.dx);
          },
          onHorizontalDragUpdate: (v){
            _onMove(v.localPosition.dx);
          },

          child: Row(
              key: _rowKey,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentSelect >= 1)
                  Icon(Icons.star, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect < 1)
                  Icon(Icons.star_border, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect >= 2)
                  Icon(Icons.star, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect < 2)
                  Icon(Icons.star_border, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect >= 3)
                  Icon(Icons.star, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect < 3)
                  Icon(Icons.star_border, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect >= 4)
                  Icon(Icons.star, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect < 4)
                  Icon(Icons.star_border, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect >= 5)
                  Icon(Icons.star, color: widget.iconStarsColor, size: widget.iconSize,),
                if (_currentSelect < 5)
                  Icon(Icons.star_border, color: widget.iconStarsColor, size: widget.iconSize,),
              ]
          ),
        ));

  }

  _onMove(double dx){
    // print("dx=$dx _rowHeight.value =${_rowWidth.value}");
    var one = _rowWidth.value~/5;

    var _currentSelect = dx~/one;
    _currentSelect++;
    if (_currentSelect < 1)
      _currentSelect = 1;
    if (_currentSelect > 5)
      _currentSelect = 5;
    // print("one=$one _currentSelect=$_currentSelect");
    widget.callback(_currentSelect);
    setState(() {

    });
  }
}

