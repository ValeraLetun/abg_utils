import 'package:flutter/material.dart';

class ScrollerResizerController extends ChangeNotifier {
  List<Widget> childs = [];
  List<ScaleData> widgets = [];
  int select = 0;
  double scale = 0.7;
  double scrollWidth = 0;

  List<Widget> w = [];

  void update() {
    widgets = [];
    for (var item in childs) {
      if (select == childs.indexOf(item))
        widgets.add(ScaleData(1, item));
      else
        widgets.add(ScaleData(scale, item));
    }
    buildList();
    notifyListeners();
  }

  buildList(){
    w = [];
    w.add(SizedBox(width: scrollWidth));

    for (var item in widgets){
      w.add(Transform.scale(
          scale: item.scale,
          child: item.widget));
    }
    w.add(SizedBox(width: scrollWidth));
  }
}

class ScrollerResizer extends StatefulWidget {
  final ScrollerResizerController controller;
  final double windowWidth;
  final double childWidth;

  const ScrollerResizer({Key? key, required this.windowWidth, required this.childWidth,
    required this.controller}) : super(key: key);

  @override
  _ScrollerResizerState createState() => _ScrollerResizerState();
}

class _ScrollerResizerState extends State<ScrollerResizer> {

  final ScrollController _scrollController = ScrollController();



  @override
  void initState() {

    widget.controller.scrollWidth = widget.windowWidth/2-widget.childWidth/2;

    widget.controller.update();

    if (widget.controller.select != 0 && widget.controller.select < widget.controller.widgets.length){
      var def = widget.childWidth*widget.controller.select;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(def);
      });
    }

    widget.controller.buildList();

    _scrollController.addListener((){
      var _scrollPosition = _scrollController.position.pixels;

      var v = (1-widget.controller.scale)*100;
      var p1 = widget.childWidth/v;
      var p = _scrollPosition/p1/100;

      var t1 = 0;
      var t2 = 1;
      int k = _scrollPosition~/(widget.childWidth);
      var sp = _scrollPosition-(widget.childWidth*k);
      p = sp/p1/100;
      if  (k < widget.controller.widgets.length-1){
        t1 = k;
        t2 = k+1;
      }else{
        t1 = widget.controller.widgets.length-2;
        t2 = widget.controller.widgets.length-1;
        p = 0.3;
      }

      for (var item in widget.controller.widgets)
        item.scale = widget.controller.scale;

      widget.controller.widgets[t1].scale = 1-p;
      if (widget.controller.widgets[t1].scale < widget.controller.scale) widget.controller.widgets[t1].scale = widget.controller.scale;

      widget.controller.widgets[t2].scale = widget.controller.scale+p;
      if (widget.controller.widgets[t2].scale > 1) widget.controller.widgets[t2].scale = 1;

      widget.controller.buildList();
      _redraw();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: widget.windowWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: widget.controller.w
                ))
          ],
        ));
  }
}


class ScaleData{
  double scale;
  Widget widget;
  ScaleData(this.scale, this.widget);
}