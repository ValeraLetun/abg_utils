import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

class Card50 extends StatefulWidget {
  final ProductData item;
  final bool categoryEnable;
  final ProviderData providerData;
  final String shadowText;
  final String locale;
  final TextDirection direction;
  final List<CategoryData> category;
  final Color? color;

  Card50({
    this.shadowText = "",
    required this.item,
    required this.providerData,
    required this.locale,
    required this.direction,
    required this.category,
    this.color,
    this.categoryEnable = true
  });

  @override
  _Card50State createState() => _Card50State();
}

class _Card50State extends State<Card50>{

  @override
  Widget build(BuildContext context) {

    Widget image = widget.item.gallery.isNotEmpty
        ? showImage(widget.item.gallery[0].serverPath, fit: BoxFit.cover) : Container();
    // widget.item.gallery.isNotEmpty ? CachedNetworkImage(
    //     imageUrl: widget.item.gallery[0].serverPath,
    //     imageBuilder: (context, imageProvider) => Container(
    //       child: Container(
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: imageProvider,
    //               fit: BoxFit.cover,
    //             )),
    //       ),
    //     )
    // ) : Container();

    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // ignore: prefer_if_null_operators
          color: widget.color == null ? aTheme.darkMode ? Colors.black : Colors.white : widget.color,
          borderRadius: BorderRadius.circular(aTheme.radius),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(aTheme.radius)),
                child: Stack(
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        child: image),
                    if (widget.shadowText.isNotEmpty)
                      Positioned.fill(
                          child: Container(
                            color: Colors.black.withAlpha(150),
                            child: Center(child: Text(widget.shadowText, style: aTheme.style12W600White,)),
                          ))
                  ],
                )),

            SizedBox(width: 10,),

            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 10,),
                Container(
                    margin: widget.direction == TextDirection.ltr ? EdgeInsets.only(right: 30) : EdgeInsets.only(left: 30),
                    child: Text(getTextByLocale(widget.item.name, widget.locale), style: aTheme.style14W800, textAlign: TextAlign.start,)),
                SizedBox(height: 4,),
                Text(getStringDistanceByProviderId(widget.item.providers[0]),
                  style: aTheme.style12W600Grey, textAlign: TextAlign.start,),
                SizedBox(height: 2,),
                Divider(color: aTheme.style14W800.color),
                Row(children: [
                  card51(widget.item.rating.toInt(), Colors.orange, 16),
                  Text(widget.item.rating.toStringAsFixed(1), style: aTheme.style12W600Orange, textAlign: TextAlign.center,),
                  SizedBox(width: 5,),
                  Text("(${widget.item.countRating.toString()})", style: aTheme.style12W800, textAlign: TextAlign.center,),

                  Expanded(child: Text(getPriceString(getMinAmountInProduct(widget.item.price)),
                    style: aTheme.style16W800Orange, textAlign: TextAlign.end, maxLines: 1,)),
                ],),

                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
                    SizedBox(width: 5,),
                    Expanded(child: Text(widget.providerData.address, style: aTheme.style10W400),)
                  ],
                ),
                SizedBox(height: 5,),
                Divider(color: aTheme.style14W800.color),
                SizedBox(height: 5,),
                if (widget.categoryEnable)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: getCategories(widget.item.category, widget.locale, widget.category).map((e) {
                    return Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(aTheme.radius),
                      ),
                      child: Text(e, style: aTheme.style12W600White,),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10,),
              ],
            ))

          ],
        )
    );
  }
}

