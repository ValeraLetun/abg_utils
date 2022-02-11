import 'package:flutter/material.dart';
import '../../../abg_utils.dart';

buttonIOS(String icon, Function() callback, double width, String _text){
  Widget _icon = Container(
    margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
    height: 25,
    width: 25,
    child: Image.asset(icon, color: Colors.white,),
  );
  return InkWell(
    onTap: callback,
    child: Container(
      width: width,
      height: 40.0,
      padding: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _icon,
              Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: Text(_text, style: aTheme.style16W800White,))),
            ],
          )
      ),
    ),
  );
}
