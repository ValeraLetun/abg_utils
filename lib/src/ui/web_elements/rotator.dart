import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';

class Rotator extends StatefulWidget {
  final double width;
  final List<Widget> list;

  const Rotator({Key? key, required this.width, required this.list}) : super(key: key);

  @override
  _RotatorState createState() => _RotatorState();
}

class _RotatorState extends State<Rotator> {

  double windowWidth = 0;
  final _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;

    return Stack(
          children: [

            Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                padding: EdgeInsets.only( top: 10, bottom: 10),
                child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                      controller: _controllerScroll,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.list,
                      )),
                    ],
                  ))),

            Positioned.fill(child: Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: IconButton(
                          onPressed: () {
                            var p = _controllerScroll.position.pixels;
                            int t = p~/(windowWidth*0.2-8);
                            double t1 = (t * (windowWidth*0.2-8)).toDouble();
                            print("p=$p t=$t t1=$t1");
                            t1 -= (windowWidth*0.8-34);
                            print("t1=$t1");
                            _controllerScroll.animateTo(t1, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black,))),
                ))),

            Positioned.fill(child: Container(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      var p = _controllerScroll.position.pixels;
                      int t = p~/(windowWidth*0.2-8);
                      double t1 = (t * (windowWidth*0.2-8)).toDouble();
                      print("p=$p t=$t t1=$t1");
                      t1 += (windowWidth*0.8-26);
                      print("t1=$t1");
                      _controllerScroll.animateTo(t1, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                    },
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.black,),),
                ))),

          ],
        );
  }
}