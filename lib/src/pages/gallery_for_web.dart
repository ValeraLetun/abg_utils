import 'dart:math';
import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';

Function()? openGallery;

openGalleryScreen(List<ImageData> gallery, ImageData image){
  _gallery = gallery;
  _imageToGallery = image;
  if (openGallery != null)
    openGallery!();
}

List<ImageData> _gallery = [];
ImageData _imageToGallery = ImageData.createEmpty();

class GalleryScreenWeb extends StatefulWidget {
  @override
  _GalleryScreenWebState createState() => _GalleryScreenWebState();
}

class _GalleryScreenWebState extends State<GalleryScreenWeb>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;

  TabController? _tabController;
  var _index = 0;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: _gallery.length);
    _tabController!.addListener((){
      _index = _tabController!.index;
      setState(() {});
    });
    _tabController!.animateTo(_gallery.indexOf(_imageToGallery));
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
    return Stack(
      children: [

        Container(
          margin: EdgeInsets.all(windowWidth*0.1),
            child: TabBarView(
          controller: _tabController,
          children: _gallery.map((item) {
            return Image.network(item.serverPath);
          }).toList()
        )),

        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 20),
          child: pagination1(_tabController!.length, _index, aTheme.mainColor),
        ),
     ]
    );
  }


}
