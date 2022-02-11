import 'package:flutter/material.dart';

//
// v 1.0 - 29/09/2020
// v 1.2 - 01/10/2020
// v 1.3 - 15.09.2021
// v 1.4 - 26/09/2021
// 02.11.2021

class IEasyDialog2 extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  final Function(double) setPosition;
  final Function() getPosition;
  final Function() getBody;
  final Color? fonColor;
  final Function(double, double)? setPosition2;
  final bool closeable;
  final double? width;

  IEasyDialog2({this.color = Colors.black, required this.setPosition, required this.getPosition, required this.getBody,
    this.backgroundColor = Colors.white, this.fonColor, this.setPosition2, this.closeable = true, this.width
  });

  @override
  _IEasyDialog2State createState() {
    return _IEasyDialog2State();
  }
}

class _IEasyDialog2State extends State<IEasyDialog2>{

  DragUpdateDetails? _detailsStart;
  DragUpdateDetails? _detailsEnd;

  final ValueNotifier<double> _rowHeight = ValueNotifier<double>(-1);
  double height = 0;

  Color _fonColor = Colors.black;

  @override
  void initState(){
    if (widget.fonColor != null)
      _fonColor = widget.fonColor!;
    else
      _fonColor = Colors.black.withAlpha(100);
    _needRedraw = true;
    super.initState();
  }

  final GlobalKey _rowKey = GlobalKey();
  bool _needRedraw = true;
  Widget? _lastBody;
  bool _dragStart = false;

  @override
  Widget build(BuildContext context) {
    if (widget.getPosition() == 1){
      _needRedraw = true;
      height = 0;
    }
    var t = widget.getBody();
    if (t is Column && _lastBody != null && _lastBody is Column){
      var t2 = _lastBody as Column;
      if (t2.children.length != t.children.length){
        _lastBody = t;
        Future.delayed(Duration.zero, () =>
        {
          if (_rowKey.currentContext != null){
            _needRedraw = true,
            _rowHeight.value = _rowKey.currentContext!.size!.height,
          }
        });
      }
    }else
    if (_lastBody != t) {
      _lastBody = t;
      Future.delayed(Duration.zero, () =>
      {
        if (_rowKey.currentContext != null){
          _needRedraw = true,
          _rowHeight.value = _rowKey.currentContext!.size!.height,
        }
      });
    }
    // if (_lastBody != widget.getBody()) {
    //   _lastBody = widget.getBody();
    //   Future.delayed(Duration.zero, () =>
    //   {
    //     if (_rowKey.currentContext != null){
    //       _needRedraw = true,
    //       _rowHeight.value = _rowKey.currentContext!.size!.height,
    //     }
    //   });
    // }

    double windowWidth = widget.width != null ? widget.width! : MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          if (widget.getPosition() != 0){
            setState(() {
              widget.setPosition(0);
              if (widget.setPosition2 != null)
                widget.setPosition2!(0, height);
            });
            return false;
          }
          return true;
        },
        child: Stack(
          children: [

            if (widget.getPosition() != 0)
              InkWell(
                onTap: (){
                  widget.setPosition(0);
                  _needRedraw = true;
                  setState(() {
                  });
                },
                child: Container(
                  width: windowWidth,
                  height: windowHeight,
                  color: _fonColor,
                ),
              ),

            ValueListenableBuilder<double>(
                valueListenable: _rowHeight,
                builder: (BuildContext context, double h, Widget? child) {
                  if (_needRedraw && _rowHeight.value != -1 && !_dragStart) {
                    if (widget.getPosition() != 0) {
                      widget.setPosition(_rowHeight.value+50);
                      if (widget.setPosition2 != null)
                        widget.setPosition2!(_rowHeight.value, height);
                      height = _rowHeight.value;
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        setState(() {});
                      });

                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   setState(() {});
                      // });
                      _needRedraw = false;
                    }
                  }

                  return Container();
                }),

            AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                height: widget.getPosition() > windowHeight ? windowHeight-100 : widget.getPosition(),
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  width: windowWidth,
                  child: Stack(
                    children: [
                      GestureDetector(
                          onVerticalDragStart: (DragStartDetails details) {
                            _dragStart = true;
                            _needRedraw = true;
                            setState(() {
                              widget.setPosition(-(details.localPosition.dy - height)+50);
                              if (widget.setPosition2 != null)
                                widget.setPosition2!(-(details.localPosition.dy - height), height);
                            });
                          },
                          onVerticalDragUpdate: (DragUpdateDetails details) {
                            _detailsStart = _detailsEnd;
                            _detailsEnd = details;
                            // print("${-(details.localPosition.dy - height)}");
                            widget.setPosition(-(details.localPosition.dy - height)+50);
                            if (widget.setPosition2 != null)
                              widget.setPosition2!(-(details.localPosition.dy - height), height);
                            _needRedraw = true;
                            setState(() {});
                          },
                          onVerticalDragEnd: (DragEndDetails details) {
                            _dragStart = false;
                            var pos = 0.0;
                            if (_detailsStart != null)
                              if (_detailsStart!.localPosition.dy > _detailsEnd!.localPosition.dy)
                                pos = height + 50;
                            widget.setPosition(pos);
                            if (widget.setPosition2 != null)
                              widget.setPosition2!(pos, height);
                            _needRedraw = true;
                            setState(() {});
                            if (pos == 0 && widget.closeable)
                              Future.delayed(const Duration(milliseconds: 100), (){
                                _needRedraw = true;
                                height = 0;
                              });
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 20,
                                width: windowWidth,
                                decoration: BoxDecoration(
                                  color: widget.color,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              ),
                              Container(
                                height: 20,
                                margin : EdgeInsets.only( top: 2),
                                width: windowWidth,
                                decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 13),
                                    width: 60,
                                    child: Column(
                                      children: [
                                        // Container(height: 2, color: widget.color,),
                                        // SizedBox(height: 2,),
                                        // Container(height: 2, color: widget.color,),
                                        // SizedBox(height: 2,),
                                        Container(height: 1, color: widget.color,),
                                      ],
                                    ),
                                  )),
                            ],

                          )),

                      Container(
                          margin: EdgeInsets.only(top: 30),
                          child: ListView(
                        padding: EdgeInsets.only(top: 0),
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                            child: Container(
                              key: _rowKey,
                              child: widget.getBody(),
                            ),
                          )

                        ],
                      ))
                    ],

                  ),
                )
            )

          ],
        ));
  }
}

