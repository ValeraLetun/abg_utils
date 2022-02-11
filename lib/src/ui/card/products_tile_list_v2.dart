import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// 11.02.2022 to abg_utils
// 14.03.2021 skins
// 09.03.2021
// 25.10.2020

class ProductsTileListV2 extends StatefulWidget {
  final double width;
  final double height;
  final String text;
  final String price;
  final String discountPrice;
  final String image;
  final String id;
  final Function(String id)? callback;
  final Function(String) onAddToCartClick;
  final String? bannerText;
  // final ProductDataCache item;

  ProductsTileListV2({this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.price = "",
    this.id = "", this.callback,
    required this.onAddToCartClick,
    required this.discountPrice, this.bannerText,
    // required this.item,
  });

  @override
  _ProductsTileListV2State createState() => _ProductsTileListV2State();
}

class _ProductsTileListV2State extends State<ProductsTileListV2>{

  @override
  Widget build(BuildContext context) {
    Widget _favorites = Container();
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user != null){
    //   bool favorite = userAccountData.userFavoritesProviders.contains(widget.id);
    //   _favorites = Container(
    //     alignment: Alignment.topRight,
    //     margin: EdgeInsets.only(top: 5, right: 5),
    //     child: Stack(
    //       children: <Widget>[
    //         Container(
    //             width: 20,
    //             height: 20,
    //             alignment: Alignment.center,
    //             child: Stack(
    //               children: [
    //                 Icon(favorite ? Icons.favorite : Icons.favorite_border, color: theme.mainColor, size: 20,),
    //               ],
    //             )
    //         ),
    //         Positioned.fill(
    //           child: Material(
    //               color: Colors.transparent,
    //               shape: CircleBorder(),
    //               clipBehavior: Clip.hardEdge,
    //               child: InkWell(
    //                 splashColor: Colors.grey[400],
    //                 onTap: (){
    //                   changeFavorites(widget.item);
    //                   redrawMainWindow();
    //                 }, // needed
    //               )),
    //         )
    //       ],
    //     ),
    //   );
    // }
    return InkWell(
        onTap: () {
          if (widget.callback != null)
            widget.callback!(widget.id);
        }, // needed
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: aTheme.mainColor,
            borderRadius: BorderRadius.circular(aTheme.radius),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(aTheme.radius)),
                child: Container(
                    child: showImage(widget.image, fit: BoxFit.cover, )
                ),
              ),


              Container(
                margin: EdgeInsets.only(top: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 6, right: 6),
                      child: Text(widget.text, style: aTheme.style16W800, maxLines: 3,),
                    ),
                    if (widget.bannerText != null)
                      Container(
                          margin: EdgeInsets.only(top: 8),
                          alignment: Alignment.centerLeft,
                          child: ClipPath(
                              clipper: ClipPathClass1(),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
                                color: Colors.lightGreen,
                                child: Text("13"),
                              ))),

                    _favorites,
                  ],
                ),
              ),

              Container(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.all(6),
                    child: widget.discountPrice.isNotEmpty ?
                    Row(children: [
                      Text(widget.price, style: aTheme.style16W400U, overflow: TextOverflow.ellipsis),
                      SizedBox(width: 5,),
                      Expanded(child: Text(widget.discountPrice, style: aTheme.style16W800, overflow: TextOverflow.ellipsis,)),
                    ],)
                        : Text(widget.price, style: aTheme.style16W800, overflow: TextOverflow.ellipsis),
                  )
              ),

              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    widget.onAddToCartClick(widget.id);
                  },
                  child: UnconstrainedBox(
                      child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: aTheme.mainColor,
                            borderRadius: BorderRadius.circular(aTheme.radius),
                          ),
                          child: Image.asset("assets/addtocart.png",
                            fit: BoxFit.contain, color: Colors.black,
                          )
                      )),
                ),
              ),

            ],
          ),
        ));
  }
}
