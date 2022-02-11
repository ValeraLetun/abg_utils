import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../abg_utils.dart';

class RouteData{
  String name;
  double pos;

  RouteData(this.name, this.pos);
}

List<RouteData> _callbackStack = [];

late Function(Widget) openDialog;
late Function() closeDialog;
late Function(String) route;
late BuildContext buildContext;
late Function() redrawMainWindow;
bool redrawMainWindowInitialized = false;
late Function(bool) waitInMainWindow;
bool waitInMainWindowInitialized = false;
double windowWidth = 0;
double windowHeight = 0;
bool isMobile() => windowWidth < 800;
bool isDesktopMore1300() => windowWidth >= 1300;

String currentBase = "";
String currentHost = "";
String locale = "en";
var direction = TextDirection.ltr;

String _getCallback(){
  if (_callbackStack.isEmpty)
    return "home";
  if (_callbackStack.length == 1)
    return "home";
  _callbackStack.removeLast();
  _debugPrintStack();
  return _callbackStack[_callbackStack.length-1].name;
}

goBack(){
  //dprint("Navigator: goBack");
  route(_getCallback());
}

String currentScreen(){
  if (_callbackStack.isNotEmpty)
    return _callbackStack[_callbackStack.length-1].name;
  return "";
}

_debugPrintStack(){
  var _text = "";
  for (var item in _callbackStack)
    _text = "$_text | $item";
  //dprint("_debugPrintStack = $_text");
}

drawState(String _val, Function(String) _route, BuildContext context, Function() redraw,
    String _locale, TextDirection _direction){
  direction = _direction;
  // mainWindowWidth = _mainWindowWidth;
  // mainWindowHeight = _mainWindowHeight;
  route = _route;
  buildContext = context;
  redrawMainWindow = redraw;
  redrawMainWindowInitialized = true;
  locale = _locale;
  // waitInMainWindow = _waitInMainWindow;
  waitInMainWindowInitialized = true;
  //
  var url = Uri.base.toString();
  // dprint(url);
  // print(window.location.href);
  // print(Uri.base.path);
  // if (url.endsWith("main"))
  //   currentBase = url.substring(0, url.length-4);
  if (kIsWeb && currentBase.isEmpty) {
    var index = url.lastIndexOf("/");
    if (url.isNotEmpty && index != 0) {
      try{
        currentBase = url.substring(0, index);
        // currentBase = url.substring(0, index + 2);
        // currentHost = url.substring(0, index - 1); // для nexmo
        currentHost = currentBase;
      }catch(ex){
        dprint("drawState $ex");
      }
    }
    // dprint(currentHost);
  }
  //
  // dprint("Navigator: drawState - add route $_val");
  if (_callbackStack.isEmpty)
    _callbackStack.add(RouteData(_val, 0));
  else
  if (_callbackStack[_callbackStack.length-1].name != _val)
    _callbackStack.add(RouteData(_val, 0));
  _debugPrintStack();
}

callbackStackRemoveLast(){
  if (_callbackStack.isNotEmpty)
    _callbackStack.removeLast();
}

callbackStackRemovePenultimate(){
  if (_callbackStack.length > 2)
    _callbackStack.removeAt(_callbackStack.length-2);
  _debugPrintStack();
}

routeSavePosition(double pos){
  if (_callbackStack.isNotEmpty)
    return _callbackStack[_callbackStack.length-1].pos = pos;
}

double routeGetPosition(){
  if (_callbackStack.isNotEmpty)
    return _callbackStack[_callbackStack.length-1].pos;
  return 0;
}