import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  final ImageData item;
  final List<ImageData> gallery;
  final String tag;
  final TextDirection textDirection;

  const GalleryScreen({Key? key, required this.item, required this.gallery, required this.tag,
    required this.textDirection}) : super(key: key);
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {

  double windowWidth = 0;
  double windowHeight = 0;
  double? windowSize;
  TabController? _tabController;
  var _index = 0;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: widget.gallery.length);
    _tabController!.addListener((){
      _index = _tabController!.index;
      setState(() {});
    });
    _tabController!.animateTo(widget.gallery.indexOf(widget.item));
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Hero(
        tag: widget.tag.isEmpty ? UniqueKey().toString() : widget.tag,
    child: Scaffold(
      backgroundColor: Colors.black,
        body: Directionality(
        textDirection: widget.textDirection,
        child: Stack(
          children: <Widget>[
            Container(
              height: windowHeight,
              width: windowWidth,
              child: TabBarView(
                controller: _tabController,
                children: widget.gallery.map((item) {
                  return Container(
                      child: showImage(item.serverPath)

                        // Container(
                        //   child: CachedNetworkImage(
                        //     placeholder: (context, url) =>
                        //         UnconstrainedBox(child:
                        //         Container(
                        //           alignment: Alignment.center,
                        //           width: 40,
                        //           height: 40,
                        //           child: CircularProgressIndicator(backgroundColor: Colors.black, ),
                        //         )),
                        //     imageUrl: item.serverPath,
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
                      );
                }).toList()
              ),
        ),

        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 20),
          child: pagination1(_tabController!.length, _index, aTheme.mainColor),
        ),

        appbar1(Colors.transparent, aTheme.mainColor, "", context, () {Navigator.pop(context);})

    ]))));
  }
}


