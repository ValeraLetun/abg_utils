import 'dart:async';
import 'package:flutter/material.dart';

import '../../abg_utils.dart';

// 14.11.2021 customer v2

class IBanner extends StatefulWidget {
  final List<BannerData> dataPromotion;
  final double width;
  final Color colorProgressBar;
  final double height;
  final Color colorGrey;
  final Color colorActive;
  final TextStyle style;
  final double radius;
  final int shadow;
  final Function(String id, String heroId, String image) callback;
  final int seconds;
  IBanner(this.dataPromotion, {Key? key, this.width = 100, this.height = 100, this.colorGrey = const Color.fromARGB(255, 180, 180, 180),
    this.colorActive = Colors.red, this.style = const TextStyle(),
    required this.callback, this.seconds = 3, this.colorProgressBar = Colors.black,
    this.radius = 0, this.shadow = 0}) : super(key: key);

  @override
  _IBannerState createState() => _IBannerState();
}

class _IBannerState extends State<IBanner> {

  int realCountPage = 0;
  var _currentPage = 1000;
  final _controller = PageController(initialPage: 1000, keepPage: false, viewportFraction: 0.79);

  Timer? _timer;
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: widget.seconds),
        (Timer timer) {
            int _page = _currentPage+1;
            _controller.animateToPage(_page, duration: Duration(seconds: 1), curve: Curves.ease);
      },
    );
  }

  @override
  void dispose() {
    if (_timer != null)
      _timer!.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    realCountPage = widget.dataPromotion.length;
    startTimer();
    super.initState();
  }

  int _getT(int itemIndex){
    var d = itemIndex;
    while(d >= realCountPage){
      d -= realCountPage;
    }
    return d;
  }

  _image(BannerData item, int index){
    var _id = UniqueKey().toString();
    return InkWell(
        onTap: () {
          widget.callback(item.id, _id, item.serverImage);
    }, // needed
    child: Stack(
      children: <Widget>[
        Container(
          width: widget.width,
          height: widget.height,
          child:
          Hero(
              tag: _id,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                child:Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                child: showImage(item.serverImage)
                // CachedNetworkImage(
                //     placeholder: (context, url) =>
                //         UnconstrainedBox(child:
                //         Container(
                //           alignment: Alignment.center,
                //           width: 40,
                //           height: 40,
                //           child: CircularProgressIndicator(),
                //         )),
                //     imageUrl: item.serverImage,
                //     imageBuilder: (context, imageProvider) => Container(
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: imageProvider,
                //           fit: BoxFit.contain,
                //         ),
                //       ),
                //     ),
                //     errorWidget: (context,url,error) => Icon(Icons.error),
                //   ),
                // ),
              )
          )
        )),
    ],
    ));
  }

  _lines(){
    List<Widget> lines = [];
    for (int i = 0; i < realCountPage; i++){
      if (i == _currentBanner)
        lines.add(Container(width: 15, height: 3,
          decoration: BoxDecoration(
            color: widget.colorActive,
            border: Border.all(color: widget.colorActive),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
      else
        lines.add(Container(width: 15, height: 3,
          decoration: BoxDecoration(
            color: widget.colorGrey,
            border: Border.all(color: widget.colorGrey),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
      lines.add(SizedBox(width: 5,),);
    }
    return lines;
  }

  int _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: widget.width,
          height: widget.height,
          child: PageView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 10000,
            onPageChanged: (int page){
              setState(() {});
              _currentPage = page;
            },
            controller: _controller,
            itemBuilder: (BuildContext context, int itemIndex) {
              _currentBanner = _getT(itemIndex);
              double scale = 0.75;
              if (itemIndex == _currentPage)
                scale = 1;
              var maxHeight = widget.height * scale;
              var maxWidth = widget.width * scale;
              var item = widget.dataPromotion[_currentBanner];
              return Stack(children: [
                  Center(child: Container(
                      width: maxWidth,
                      height: maxHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.radius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(widget.shadow),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ]
                    ) ,
                    child: _image(item, _currentBanner),
                  )),
              ],);
            },
          ),
        ),
        Container(
            height: widget.height,
            child:Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    margin: EdgeInsets.only(bottom: 25, right: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _lines(),
                    )
                )
            )),
      ],
    );
  }
}