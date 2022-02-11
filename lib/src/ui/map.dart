import 'package:flutter/material.dart';

class IBoxCircle extends StatelessWidget {
  final Widget child;
  final Color color;
  IBoxCircle({this.color = Colors.white, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(40),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 2), // changes position of shadow
              ),
            ],
          ),
          child: Container(
              child: child)
      ),
    );
  }
}

buttonPlus(Function() callback){
  return Stack(
    children: <Widget>[
      Container(
        height: 60,
        width: 60,
        child: IBoxCircle(child: Icon(Icons.add, size: 30, color: Colors.black,)),
      ),
      Container(
        height: 60,
        width: 60,
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: callback,
            )),
      )
    ],
  );
}

buttonMinus(Function() _onMapMinus){
  return Stack(
    children: <Widget>[
      Container(
        height: 60,
        width: 60,
        child: IBoxCircle(child: Icon(Icons.remove, size: 30, color: Colors.black,)),
      ),
      Container(
        height: 60,
        width: 60,
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: _onMapMinus,
            )),
      )
    ],
  );
}

buttonMyLocation(Function _getCurrentLocation){
  return Stack(
    children: <Widget>[
      Container(
        height: 60,
        width: 60,
        child: IBoxCircle(child: Icon(Icons.my_location, size: 30, color: Colors.black.withOpacity(0.5),)),
      ),
      Container(
        height: 60,
        width: 60,
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: (){
                _getCurrentLocation();
              }, // needed
            )),
      )
    ],
  );
}